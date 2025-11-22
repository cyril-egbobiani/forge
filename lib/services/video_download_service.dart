import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class VideoDownloadService {
  static final VideoDownloadService _instance =
      VideoDownloadService._internal();
  factory VideoDownloadService() => _instance;
  VideoDownloadService._internal();

  final Dio _dio = Dio();
  final Map<String, double> _downloadProgress = {};
  final Map<String, CancelToken> _downloadTokens = {};

  // Stream for download progress
  Stream<double> getDownloadProgress(String url) {
    return Stream.periodic(const Duration(milliseconds: 100), (_) {
      return _downloadProgress[url] ?? 0.0;
    });
  }

  // Check if file is already downloaded
  Future<String?> getLocalFilePath(String fileName) async {
    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) return null;

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking local file: $e');
      }
      return null;
    }
  }

  // Download video file to phone's internal storage
  Future<String?> downloadVideo({
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      // Request storage permission
      if (!await _requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      final directory = await _getDownloadDirectory();
      if (directory == null) {
        throw Exception('Cannot access storage directory');
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Check if file already exists
      if (await file.exists()) {
        return filePath;
      }

      // Create cancel token for this download
      final cancelToken = CancelToken();
      _downloadTokens[url] = cancelToken;

      // Download the file
      final response = await _dio.download(
        url,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            _downloadProgress[url] = progress;
            onProgress?.call(progress);
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      // Clean up
      _downloadProgress.remove(url);
      _downloadTokens.remove(url);

      if (response.statusCode == 200) {
        return filePath;
      } else {
        throw Exception('Download failed with status: ${response.statusCode}');
      }
    } catch (e) {
      _downloadProgress.remove(url);
      _downloadTokens.remove(url);

      if (kDebugMode) {
        print('Download error: $e');
      }
      throw Exception('Failed to download video: $e');
    }
  }

  // Cancel download
  void cancelDownload(String url) {
    final token = _downloadTokens[url];
    token?.cancel('Download cancelled by user');
    _downloadProgress.remove(url);
    _downloadTokens.remove(url);
  }

  // Delete downloaded file
  Future<bool> deleteDownloadedFile(String fileName) async {
    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) return false;

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting file: $e');
      }
      return false;
    }
  }

  // Get download directory
  Future<Directory?> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        // Use external storage Downloads directory for Android
        return await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        // Use documents directory for iOS
        return await getApplicationDocumentsDirectory();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting download directory: $e');
      }
      return null;
    }
  }

  // Request storage permission
  Future<bool> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (status.isDenied) {
          status = await Permission.storage.request();
        }

        // For Android 11+ (API 30+), also request manage external storage
        if (Platform.isAndroid) {
          var manageStatus = await Permission.manageExternalStorage.status;
          if (manageStatus.isDenied) {
            manageStatus = await Permission.manageExternalStorage.request();
          }
          return status.isGranted || manageStatus.isGranted;
        }

        return status.isGranted;
      } else if (Platform.isIOS) {
        // iOS doesn't need explicit storage permission for app documents
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Permission request error: $e');
      }
      return false;
    }
  }

  // Get all downloaded files info
  Future<List<Map<String, dynamic>>> getDownloadedFiles() async {
    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) return [];

      final files = directory
          .listSync()
          .where((entity) => entity is File)
          .cast<File>()
          .where(
            (file) => file.path.endsWith('.mp4') || file.path.endsWith('.webm'),
          )
          .toList();

      final downloadedFiles = <Map<String, dynamic>>[];

      for (final file in files) {
        final stat = await file.stat();
        downloadedFiles.add({
          'path': file.path,
          'name': file.path.split('/').last,
          'size': stat.size,
          'modified': stat.modified,
        });
      }

      return downloadedFiles;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting downloaded files: $e');
      }
      return [];
    }
  }
}
