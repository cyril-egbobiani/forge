import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import 'package:forge/utils/responsive_helper.dart';
import 'package:forge/utils/app_text_styles.dart';
import 'package:forge/models/teaching.dart';
import 'package:forge/services/audio_service.dart';

class TeachingDetailScreen extends StatefulWidget {
  final Teaching teaching;

  const TeachingDetailScreen({super.key, required this.teaching});

  @override
  State<TeachingDetailScreen> createState() => _TeachingDetailScreenState();
}

class _TeachingDetailScreenState extends State<TeachingDetailScreen> {
  final TeachingAudioService _audioService = TeachingAudioService();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  void _initializeAudio() {
    // Listen to audio service streams
    _audioService.isPlayingStream.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });

    _audioService.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioService.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTeachingInfo(),
                  SizedBox(height: ResponsiveHelper.h(16)),
                  _buildAudioPlayer(),
                  SizedBox(height: ResponsiveHelper.h(16)),
                  _buildDescription(),
                  if (widget.teaching.scripture != null) ...[
                    SizedBox(height: ResponsiveHelper.h(16)),
                    _buildScripture(),
                  ],
                  SizedBox(height: ResponsiveHelper.h(32)),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.teaching.title,
          style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  size: 40,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeachingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.teaching.title,
          style: AppTextStyles.h2.copyWith(fontSize: 24),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.person, size: 16, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text(
              widget.teaching.speaker,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 16),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 4),
            Text(
              widget.teaching.formattedDate,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        if (widget.teaching.series != null) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.teaching.series!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress slider
          if (_duration != null)
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                trackHeight: 4,
              ),
              child: Slider(
                value: _position.inMilliseconds.toDouble(),
                max: _duration!.inMilliseconds.toDouble(),
                onChanged: (value) {
                  _audioService.seek(Duration(milliseconds: value.toInt()));
                },
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.3),
              ),
            ),

          // Time display
          if (_duration != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _formatDuration(_duration!),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

          SizedBox(height: 16),

          // Player controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Speed control
              IconButton(
                onPressed: () => _showSpeedDialog(),
                icon: Icon(Icons.speed),
                iconSize: 28,
              ),

              // Rewind 15 seconds
              IconButton(
                onPressed: () => _seekRelative(-15),
                icon: Icon(Icons.replay_10),
                iconSize: 32,
              ),

              // Play/Pause button
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 32,
                ),
              ),

              // Forward 15 seconds
              IconButton(
                onPressed: () => _seekRelative(15),
                icon: Icon(Icons.forward_10),
                iconSize: 32,
              ),

              // More options
              IconButton(
                onPressed: () => _showMoreOptions(),
                icon: Icon(Icons.more_horiz),
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: AppTextStyles.h4.copyWith(fontSize: 18)),
        SizedBox(height: 8),
        Text(
          widget.teaching.description,
          style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildScripture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Scripture', style: AppTextStyles.h4.copyWith(fontSize: 18)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Text(
            widget.teaching.scripture!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _downloadTeaching(),
            icon: Icon(Icons.download),
            label: Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _shareTeaching(),
            icon: Icon(Icons.share),
            label: Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioService.pause();
    } else {
      if (_audioService.currentTeaching?.id != widget.teaching.id) {
        _audioService.playTeaching(widget.teaching);
      } else {
        _audioService.play();
      }
    }
  }

  void _seekRelative(int seconds) {
    final newPosition = _position + Duration(seconds: seconds);
    if (_duration != null) {
      final clampedPosition = Duration(
        milliseconds: newPosition.inMilliseconds.clamp(
          0,
          _duration!.inMilliseconds,
        ),
      );
      _audioService.seek(clampedPosition);
    }
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Playback Speed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _speedButton('0.5x', 0.5),
            _speedButton('0.75x', 0.75),
            _speedButton('Normal', 1.0),
            _speedButton('1.25x', 1.25),
            _speedButton('1.5x', 1.5),
            _speedButton('2.0x', 2.0),
          ],
        ),
      ),
    );
  }

  Widget _speedButton(String label, double speed) {
    return ListTile(
      title: Text(label),
      onTap: () {
        _audioService.setSpeed(speed);
        Navigator.pop(context);
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text('Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement favorites
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement playlists
              },
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text('Sleep Timer'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement sleep timer
              },
            ),
          ],
        ),
      ),
    );
  }

  void _downloadTeaching() {
    // TODO: Implement download functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Download feature coming soon!')));
  }

  void _shareTeaching() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Share feature coming soon!')));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}
