import 'dart:async';
import 'package:just_audio/just_audio.dart';
import '../models/teaching.dart';

class TeachingAudioService {
  static final TeachingAudioService _instance =
      TeachingAudioService._internal();
  factory TeachingAudioService() => _instance;
  TeachingAudioService._internal();

  AudioPlayer? _audioPlayer;
  Teaching? _currentTeaching;

  // Stream controllers for UI updates
  final _playbackStateController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration?>.broadcast();
  final _currentTeachingController = StreamController<Teaching?>.broadcast();

  // Getters for streams
  Stream<bool> get isPlayingStream => _playbackStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration?> get durationStream => _durationController.stream;
  Stream<Teaching?> get currentTeachingStream =>
      _currentTeachingController.stream;

  // Current state getters
  bool get isPlaying => _audioPlayer?.playing ?? false;
  Duration get position => _audioPlayer?.position ?? Duration.zero;
  Duration? get duration => _audioPlayer?.duration;
  Teaching? get currentTeaching => _currentTeaching;

  Future<void> init() async {
    if (_audioPlayer != null) return; // Already initialized

    _audioPlayer = AudioPlayer();

    // Listen to playback state changes
    _audioPlayer!.playingStream.listen((playing) {
      _playbackStateController.add(playing);
    });

    // Listen to position changes
    _audioPlayer!.positionStream.listen((position) {
      _positionController.add(position);
    });

    // Listen to duration changes
    _audioPlayer!.durationStream.listen((duration) {
      _durationController.add(duration);
    });
  }

  Future<void> playTeaching(Teaching teaching) async {
    try {
      if (_audioPlayer == null) await init();

      _currentTeaching = teaching;
      _currentTeachingController.add(teaching);

      // For now, we'll simulate audio URL since we don't have actual audio files
      // In production, you would use: teaching.audioUrl
      const demoAudioUrl =
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

      await _audioPlayer!.setUrl(demoAudioUrl);
      await _audioPlayer!.play();

      print('🎵 Playing: ${teaching.title}');
    } catch (e) {
      print('❌ Error playing audio: $e');
    }
  }

  Future<void> play() async {
    if (_audioPlayer == null) await init();
    await _audioPlayer!.play();
  }

  Future<void> pause() async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.pause();
  }

  Future<void> stop() async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.stop();
    _currentTeaching = null;
    _currentTeachingController.add(null);
  }

  Future<void> seek(Duration position) async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.seek(position);
  }

  Future<void> setSpeed(double speed) async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.setSpeed(speed);
  }

  void dispose() {
    _audioPlayer?.dispose();
    _playbackStateController.close();
    _positionController.close();
    _durationController.close();
    _currentTeachingController.close();
  }
}
