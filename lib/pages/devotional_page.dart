import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';

class DevotionalPage extends StatelessWidget {
  final List<Map<String, String>> devotionals = [
    {
      'scripture': 'Philippians 4:13',
      'text': 'I can do all things through Christ who strengthens me.',
      'explanation':
          'This verse reminds us that our strength comes from Christ, not ourselves. Whatever challenge you face today, rely on His power.',
    },
    {
      'scripture': 'Jeremiah 29:11',
      'text':
          'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.',
      'explanation':
          'God has a good plan for your life. Even when things seem uncertain, trust that He is working for your good.',
    },
    {
      'scripture': 'Psalm 23:1',
      'text': 'The Lord is my shepherd; I shall not want.',
      'explanation':
          'God cares for you as a shepherd cares for his sheep. You can rest in His provision and protection.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Devotionals', style: AppTextStyles.h5),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: devotionals.length,
        itemBuilder: (context, index) {
          final devo = devotionals[index];
          return Card(
            color: Colors.white10,
            margin: EdgeInsets.only(bottom: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    devo['scripture'] ?? '',
                    style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '"${devo['text']}"',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    devo['explanation'] ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
