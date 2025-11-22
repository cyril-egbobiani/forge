import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import '../models/teaching.dart';
import '../services/video_download_service.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../utils/app_text_styles.dart';

class TeachingVideoPlayer extends StatefulWidget {
  final Teaching teaching;

  const TeachingVideoPlayer({super.key, required this.teaching});

  @override
  State<TeachingVideoPlayer> createState() => _TeachingVideoPlayerState();
}

class _TeachingVideoPlayerState extends State<TeachingVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final VideoDownloadService _downloadService = VideoDownloadService();

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    if (!widget.teaching.hasVideo) {
      setState(() {
        _hasError = true;
        _errorMessage = 'No video available for this teaching';
        _isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Check if video is already downloaded locally
      final fileName = _getVideoFileName();
      _localFilePath = await _downloadService.getLocalFilePath(fileName);

      if (_localFilePath != null) {
        setState(() {
          _isDownloaded = true;
        });
        await _setupVideoPlayer(_localFilePath!);
      } else {
        await _setupVideoPlayer(widget.teaching.videoUrl!);
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load video: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _setupVideoPlayer(String source) async {
    try {
      // Initialize video controller
      if (source.startsWith('http')) {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(source),
        );
      } else {
        _videoPlayerController = VideoPlayerController.file(File(source));
      }

      await _videoPlayerController!.initialize();

      // Setup Chewie controller with custom controls
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: Colors.grey.shade800,
          bufferedColor: Colors.black,
        ),
        placeholder: Container(
          color: Colors.black,
          child: widget.teaching.thumbnailUrl != null
              ? Image.network(
                  widget.teaching.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.video_library,
                        color: Colors.white,
                        size: 50,
                      ),
                    );
                  },
                )
              : const Center(
                  child: Icon(
                    Icons.video_library,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
        ),
        errorBuilder: (context, errorMessage) {
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    'Error playing video',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to setup video player: $e';
        _isLoading = false;
      });
    }
  }

  String _getVideoFileName() {
    final title = widget.teaching.title.replaceAll(RegExp(r'[^\w\s-]'), '');
    final speaker = widget.teaching.speaker.replaceAll(RegExp(r'[^\w\s-]'), '');
    return '${title}_${speaker}.${widget.teaching.videoFormat ?? 'mp4'}'
        .replaceAll(' ', '_')
        .toLowerCase();
  }

  Future<void> _downloadVideo() async {
    if (_isDownloading || widget.teaching.videoUrl == null) return;

    try {
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      final fileName = _getVideoFileName();

      final filePath = await _downloadService.downloadVideo(
        url: widget.teaching.videoUrl!,
        fileName: fileName,
        onProgress: (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
      );

      if (filePath != null) {
        setState(() {
          _localFilePath = filePath;
          _isDownloaded = true;
          _isDownloading = false;
        });

        _showSnackBar('Video downloaded successfully!');

        // Optionally switch to local file
        // You could ask user if they want to switch to local playback
      } else {
        throw Exception('Download failed');
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
      _showSnackBar('Download failed: $e');
    }
  }

  Future<void> _deleteDownload() async {
    if (!_isDownloaded) return;

    try {
      final fileName = _getVideoFileName();
      final success = await _downloadService.deleteDownloadedFile(fileName);

      if (success) {
        setState(() {
          _localFilePath = null;
          _isDownloaded = false;
        });
        _showSnackBar('Downloaded video deleted');
      } else {
        _showSnackBar('Failed to delete video');
      }
    } catch (e) {
      _showSnackBar('Error deleting video: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.dark900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player Container
          Container(
            width: double.infinity,
            height: ResponsiveHelper.h(220),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildVideoContent(),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // Video Controls and Info
          _buildVideoControls(),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Iconify(Lucide.alert_circle, size: 50, color: Colors.red),
            SizedBox(height: ResponsiveHelper.h(16)),
            Text(
              'Video Error',
              style: AppTextStyles.h6.copyWith(color: Colors.white),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
              child: Text(
                _errorMessage ?? 'Unable to load video',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(16)),
            ElevatedButton(
              onPressed: _initializePlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const Center(child: Text('No video available'));
  }

  Widget _buildVideoControls() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Download Status and Controls
          Row(
            children: [
              Icon(
                _isDownloaded ? Icons.download_done : Icons.cloud_download,
                color: _isDownloaded ? Colors.green : AppColors.primary,
                size: ResponsiveHelper.w(20),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Expanded(
                child: Text(
                  _isDownloaded
                      ? 'Downloaded to device'
                      : _isDownloading
                      ? 'Downloading... ${(_downloadProgress * 100).toStringAsFixed(0)}%'
                      : 'Available for download',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              if (widget.teaching.videoSizeBytes != null)
                Text(
                  widget.teaching.videoSizeText,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
            ],
          ),

          if (_isDownloading) ...[
            SizedBox(height: ResponsiveHelper.h(12)),
            LinearProgressIndicator(
              value: _downloadProgress,
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],

          SizedBox(height: ResponsiveHelper.h(16)),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _isDownloaded
                    ? ElevatedButton.icon(
                        onPressed: _deleteDownload,
                        icon: const Iconify(Lucide.trash_2, size: 16),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: _isDownloading ? null : _downloadVideo,
                        icon: _isDownloading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Iconify(Lucide.download, size: 16),
                        label: Text(
                          _isDownloading ? 'Downloading' : 'Download',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.black,
                        ),
                      ),
              ),
              if (_isDownloaded && _localFilePath != null) ...[
                SizedBox(width: ResponsiveHelper.w(12)),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Switch to local file playback
                    await _setupVideoPlayer(_localFilePath!);
                  },
                  icon: const Iconify(Lucide.hard_drive, size: 16),
                  label: const Text('Local'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),

          // Video Info
          if (widget.teaching.hasVideo) ...[
            SizedBox(height: ResponsiveHelper.h(16)),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.white.withOpacity(0.6),
                  size: ResponsiveHelper.w(16),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Expanded(
                  child: Text(
                    'Video will be saved to your device\'s internal storage and can be played offline.',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
