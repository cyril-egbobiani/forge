import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/game_models.dart' as game;
import '../services/game_tracking_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class LightAndPathGameScreen extends StatefulWidget {
  const LightAndPathGameScreen({Key? key}) : super(key: key);

  @override
  State<LightAndPathGameScreen> createState() => _LightAndPathGameScreenState();
}

class _LightAndPathGameScreenState extends State<LightAndPathGameScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  int? selectedAnswerIndex;
  late Stopwatch _stopwatch;
  Timer? _timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Who built the ark?',
      'answers': ['Moses', 'Noah', 'Abraham', 'David'],
      'correct': 1,
    },
    {
      'question': 'How many days did it rain during the flood?',
      'answers': ['7 days', '40 days', '100 days', '365 days'],
      'correct': 1,
    },
    {
      'question': 'What did God create on the first day?',
      'answers': ['Animals', 'Plants', 'Light', 'Water'],
      'correct': 2,
    },
    {
      'question': 'Who was the first man created by God?',
      'answers': ['Abel', 'Cain', 'Seth', 'Adam'],
      'correct': 3,
    },
    {
      'question': 'What fruit did Adam and Eve eat?',
      'answers': ['Apple', 'Forbidden Fruit', 'Orange', 'Grape'],
      'correct': 1,
    },
    {
      'question': 'How many disciples did Jesus have?',
      'answers': ['10', '11', '12', '13'],
      'correct': 2,
    },
    {
      'question': 'Who betrayed Jesus?',
      'answers': ['Peter', 'John', 'Judas', 'Matthew'],
      'correct': 2,
    },
    {
      'question': 'In which city was Jesus born?',
      'answers': ['Jerusalem', 'Nazareth', 'Bethlehem', 'Galilee'],
      'correct': 2,
    },
    {
      'question': 'Who parted the Red Sea?',
      'answers': ['Moses', 'Aaron', 'Joshua', 'Elijah'],
      'correct': 0,
    },
    {
      'question': 'How many books are in the New Testament?',
      'answers': ['25', '26', '27', '28'],
      'correct': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _stopwatch.start();
    _startTimer();

    // Shuffle questions for variety
    questions.shuffle(Random());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _selectAnswer(int answerIndex) {
    if (isAnswered) return;

    setState(() {
      selectedAnswerIndex = answerIndex;
      isAnswered = true;

      if (answerIndex == questions[currentQuestionIndex]['correct']) {
        score++;
      }
    });

    // Auto advance to next question after 2 seconds
    Timer(const Duration(seconds: 2), _nextQuestion);
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = false;
        selectedAnswerIndex = null;
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    _stopwatch.stop();
    _timer?.cancel();

    final currentUser = AuthService.instance.currentUser;
    if (currentUser != null) {
      final session = game.GameSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id ?? 'unknown_user',
        gameType: game.GameType.lightAndPath,
        score: score,
        totalQuestions: questions.length,
        timeTaken: _stopwatch.elapsed,
        createdAt: DateTime.now(),
        metadata: {
          'questionsOrder': questions.map((q) => q['question']).toList(),
        },
      );

      await GameTrackingService.instance.recordGameSession(session);
    }

    if (mounted) {
      _showGameCompleteDialog();
    }
  }

  void _showGameCompleteDialog() {
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
          'Game Complete!',
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
                color: score == questions.length
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2),
                border: Border.all(
                  color: score == questions.length
                      ? Colors.amber
                      : Colors.green,
                  width: 3,
                ),
              ),
              child: Icon(
                score == questions.length ? Icons.star : Icons.check_circle,
                color: score == questions.length ? Colors.amber : Colors.green,
                size: 40,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Score section
            Text(
              'Your Score',
              style: GoogleFonts.archivo(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: AppSpacing.sm),

            Text(
              '$score/${questions.length}',
              style: GoogleFonts.archivoBlack(
                fontSize: 32,
                color: AppColors.primary,
                letterSpacing: -1,
              ),
            ),

            Text(
              '${((score / questions.length) * 100).toInt()}%',
              style: GoogleFonts.archivo(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
                        'Time',
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
                        'Accuracy',
                        style: GoogleFonts.archivo(
                          fontSize: 14,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '${((score / questions.length) * 100).toInt()}%',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

          // Play Again button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _restartGame();
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
                'Play Again',
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

  void _restartGame() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isAnswered = false;
      selectedAnswerIndex = null;
      questions.shuffle(Random());
    });

    _stopwatch.reset();
    _stopwatch.start();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

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
                        'Light and Path',
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
                  // Question count and score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${currentQuestionIndex + 1} of ${questions.length}',
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Score: $score',
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

            // Question card
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Question container
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
                      child: Text(
                        currentQuestion['question'],
                        style: GoogleFonts.archivoBlack(
                          fontSize: 24,
                          color: Colors.white,
                          height: 1.3,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    // Answer options
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion['answers'].length,
                        itemBuilder: (context, index) {
                          final answer = currentQuestion['answers'][index];
                          final isCorrect = index == currentQuestion['correct'];
                          final isSelected = selectedAnswerIndex == index;

                          Color backgroundColor;
                          Color borderColor;
                          Color textColor = Colors.white;
                          List<BoxShadow>? shadows;

                          if (isAnswered) {
                            if (isCorrect) {
                              backgroundColor = Colors.green.withOpacity(0.2);
                              borderColor = Colors.green;
                              textColor = Colors.green;
                              shadows = null;
                            } else if (isSelected && !isCorrect) {
                              backgroundColor = Colors.red.withOpacity(0.2);
                              borderColor = Colors.red;
                              textColor = Colors.red;
                            } else {
                              backgroundColor = AppColors.dark800;
                              borderColor = AppColors.dark700;
                              textColor = Colors.grey[400]!;
                            }
                          } else {
                            backgroundColor = AppColors.dark800;
                            borderColor = AppColors.dark700;
                            shadows = null;
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: AppSpacing.md),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _selectAnswer(index),
                                borderRadius: AppBorderRadius.custom(16.0),
                                child: Container(
                                  padding: EdgeInsets.all(AppSpacing.lg),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: AppBorderRadius.custom(16.0),
                                    border: Border.all(
                                      color: borderColor,
                                      width: 2,
                                    ),
                                    boxShadow: shadows,
                                  ),
                                  child: Row(
                                    children: [
                                      // Answer letter indicator
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: textColor.withOpacity(0.2),
                                          border: Border.all(
                                            color: textColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            String.fromCharCode(
                                              65 + index,
                                            ), // A, B, C, D
                                            style: GoogleFonts.archivo(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: AppSpacing.lg),

                                      // Answer text
                                      Expanded(
                                        child: Text(
                                          answer,
                                          style: GoogleFonts.archivo(
                                            color: textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),

                                      // Status icon
                                      if (isAnswered && isCorrect)
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        )
                                      else if (isAnswered &&
                                          isSelected &&
                                          !isCorrect)
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
