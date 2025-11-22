import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import 'package:forge/utils/app_text_styles.dart';
import 'package:forge/models/teaching.dart';
import 'package:forge/services/audio_service.dart';
import 'package:forge/screens/teaching_detail_screen.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final TeachingAudioService _audioService = TeachingAudioService();
  Teaching? _currentTeaching;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
  }

  void _initializeStreams() {
    _audioService.currentTeachingStream.listen((teaching) {
      if (mounted) {
        setState(() {
          _currentTeaching = teaching;
        });
      }
    });

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
    if (_currentTeaching == null) {
      return SizedBox.shrink();
    }

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress bar
          if (_duration != null)
            LinearProgressIndicator(
              value: _duration!.inMilliseconds > 0
                  ? _position.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 2,
            ),

          // Player content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Album art placeholder
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 12),

                  // Teaching info
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeachingDetailScreen(
                              teaching: _currentTeaching!,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentTeaching!.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            _currentTeaching!.speaker,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Controls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _seekRelative(-15),
                        icon: Icon(Icons.replay_10),
                        iconSize: 20,
                        color: AppColors.textSecondary,
                      ),
                      IconButton(
                        onPressed: _togglePlayPause,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        iconSize: 28,
                        color: AppColors.primary,
                      ),
                      IconButton(
                        onPressed: () => _seekRelative(15),
                        icon: Icon(Icons.forward_10),
                        iconSize: 20,
                        color: AppColors.textSecondary,
                      ),
                      IconButton(
                        onPressed: _close,
                        icon: Icon(Icons.close),
                        iconSize: 20,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioService.pause();
    } else {
      _audioService.play();
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

  void _close() {
    _audioService.stop();
  }
}
