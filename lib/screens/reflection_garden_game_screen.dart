import 'package:flutter/material.dart';
import 'package:forge/utils/app_dimensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../models/game_models.dart';
import '../services/game_tracking_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/responsive_helper.dart';

class ReflectionGardenGameScreen extends StatefulWidget {
  const ReflectionGardenGameScreen({Key? key}) : super(key: key);

  @override
  State<ReflectionGardenGameScreen> createState() =>
      _ReflectionGardenGameScreenState();
}

class _ReflectionGardenGameScreenState
    extends State<ReflectionGardenGameScreen> {
  int currentPromptIndex = 0;
  int completedPrompts = 0;
  final TextEditingController _reflectionController = TextEditingController();
  final List<String> reflections = [];
  late Stopwatch _stopwatch;
  Timer? _timer;

  final List<Map<String, dynamic>> prompts = [
    {
      'title': 'Daily Gratitude',
      'prompt': 'What are three things you\'re grateful for today?',
      'hint': 'Think about small moments, people, or experiences...',
    },
    {
      'title': 'Acts of Kindness',
      'prompt': 'Describe a recent act of kindness you witnessed or performed.',
      'hint': 'How did it make you or others feel?',
    },
    {
      'title': 'Personal Growth',
      'prompt': 'What is one way you\'ve grown spiritually this week?',
      'hint':
          'Consider new insights, challenges overcome, or lessons learned...',
    },
    {
      'title': 'Prayer Reflection',
      'prompt':
          'Write about a prayer that has been meaningful to you recently.',
      'hint': 'What made it special? How did it impact you?',
    },
    {
      'title': 'Scripture Meditation',
      'prompt':
          'Reflect on a Bible verse that speaks to your current situation.',
      'hint': 'How does it apply to your life right now?',
    },
    {
      'title': 'Community Connection',
      'prompt': 'How have you felt God\'s presence through your community?',
      'hint': 'Think about relationships, support, or shared experiences...',
    },
    {
      'title': 'Overcoming Challenges',
      'prompt':
          'Describe a challenge you\'re facing and how your faith helps you.',
      'hint': 'What strength or guidance do you find in your beliefs?',
    },
    {
      'title': 'Future Hopes',
      'prompt': 'What are your hopes and dreams for your spiritual journey?',
      'hint': 'How do you want to grow in the coming months?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _stopwatch.start();
    _startTimer();

    // Shuffle prompts for variety
    prompts.shuffle();

    // Take only 5 prompts for this session
    prompts.removeRange(5, prompts.length);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _reflectionController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _submitReflection() {
    final reflection = _reflectionController.text.trim();
    if (reflection.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Please write a reflection before continuing',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() {
      reflections.add(reflection);
      completedPrompts++;
      _reflectionController.clear();
    });

    if (currentPromptIndex < prompts.length - 1) {
      setState(() {
        currentPromptIndex++;
      });
    } else {
      _finishSession();
    }
  }

  void _skipPrompt() {
    if (currentPromptIndex < prompts.length - 1) {
      setState(() {
        reflections.add(''); // Add empty reflection for skipped prompt
        currentPromptIndex++;
      });
    } else {
      _finishSession();
    }
  }

  Future<void> _finishSession() async {
    _stopwatch.stop();
    _timer?.cancel();

    final currentUser = AuthService.instance.currentUser;
    if (currentUser != null) {
      // Calculate score based on completed reflections and quality
      int score = 0;
      for (final reflection in reflections) {
        if (reflection.isNotEmpty) {
          if (reflection.length > 50) {
            score += 2; // Thoughtful reflection
          } else {
            score += 1; // Basic reflection
          }
        }
      }

      final session = GameSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id ?? 'unknown_user',
        gameType: GameType.reflectionGarden,
        score: score,
        totalQuestions: prompts.length * 2, // Max possible score
        timeTaken: _stopwatch.elapsed,
        createdAt: DateTime.now(),
        metadata: {
          'completedPrompts': completedPrompts,
          'totalPrompts': prompts.length,
          'reflectionCount': reflections.where((r) => r.isNotEmpty).length,
          'averageLength': reflections.where((r) => r.isNotEmpty).isEmpty
              ? 0
              : reflections
                        .where((r) => r.isNotEmpty)
                        .map((r) => r.length)
                        .reduce((a, b) => a + b) /
                    reflections.where((r) => r.isNotEmpty).length,
        },
      );

      await GameTrackingService.instance.recordGameSession(session);
    }

    if (mounted) {
      _showSessionCompleteDialog();
    }
  }

  void _showSessionCompleteDialog() {
    final completionRate = (completedPrompts / prompts.length * 100).toInt();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.dark800,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.custom(24.0),
          side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 2),
        ),
        title: Text(
          'Reflection Complete!',
          style: GoogleFonts.archivoBlack(
            fontSize: 24,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Achievement icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.2),
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: Icon(
                Icons.self_improvement,
                color: AppColors.primary,
                size: 40,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Session summary
            Text(
              'Session Summary',
              style: GoogleFonts.archivo(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Stats section
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: AppBorderRadius.custom(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Time Spent',
                        style: GoogleFonts.archivo(
                          fontSize: 14,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '${_stopwatch.elapsed.inMinutes}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 40, color: AppColors.dark700),
                  Column(
                    children: [
                      Text(
                        'Completed',
                        style: GoogleFonts.archivo(
                          fontSize: 14,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '$completedPrompts/${prompts.length}',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 40, color: AppColors.dark700),
                  Column(
                    children: [
                      Text(
                        'Progress',
                        style: GoogleFonts.archivo(
                          fontSize: 14,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '$completionRate%',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            Text(
              'Great work on your spiritual reflection journey!',
              style: GoogleFonts.archivo(fontSize: 14, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          // Return to Games button
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: AppSpacing.sm),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to games page
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.custom(16.0),
                  side: BorderSide(
                    color: AppColors.primary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Return to Games',
                style: GoogleFonts.archivo(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // New Session button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _restartSession();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.custom(16.0),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'New Session',
                style: GoogleFonts.archivo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _restartSession() {
    setState(() {
      currentPromptIndex = 0;
      completedPrompts = 0;
      reflections.clear();
      _reflectionController.clear();
      prompts.shuffle();
    });

    _stopwatch.reset();
    _stopwatch.start();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final currentPrompt = prompts[currentPromptIndex];
    final progress = (currentPromptIndex + 1) / prompts.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, title, and timer
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.dark800,
                      borderRadius: AppBorderRadius.custom(12.0),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Reflection Garden',
                        style: GoogleFonts.archivoBlack(
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  // Timer
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppBorderRadius.custom(20.0),
                    ),
                    child: Text(
                      '${_stopwatch.elapsed.inMinutes}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: GoogleFonts.archivo(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress section
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  // Prompt count and completed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prompt ${currentPromptIndex + 1} of ${prompts.length}',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Completed: $completedPrompts',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  // Progress bar
                  Container(
                    width: double.infinity,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.dark800,
                      borderRadius: AppBorderRadius.custom(6.0),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppBorderRadius.custom(6.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xxl),

            // Prompt card
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prompt title
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: AppColors.dark800,
                        borderRadius: AppBorderRadius.custom(24.0),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.self_improvement,
                            color: AppColors.primary,
                            size: 28,
                          ),
                          SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Text(
                              currentPrompt['title'],
                              style: GoogleFonts.archivoBlack(
                                fontSize: 22,
                                color: AppColors.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    // Prompt question
                    Text(
                      currentPrompt['prompt'],
                      style: GoogleFonts.archivo(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Hint
                    Text(
                      currentPrompt['hint'],
                      style: GoogleFonts.archivo(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Text input
                    Expanded(
                      child: TextField(
                        controller: _reflectionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.archivo(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Share your thoughts and reflections...',
                          hintStyle: GoogleFonts.archivo(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: AppBorderRadius.custom(16.0),
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppBorderRadius.custom(16.0),
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppBorderRadius.custom(16.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _skipPrompt,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.custom(16.0),
                                side: BorderSide(
                                  color: Colors.grey[700]!,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.archivo(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.lg),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _submitReflection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.custom(16.0),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              currentPromptIndex < prompts.length - 1
                                  ? 'Next Prompt'
                                  : 'Complete Session',
                              style: GoogleFonts.archivo(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
