import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class DonationPage extends StatelessWidget {
  final List<Map<String, String>> donationNeeds = [
    {
      'name': 'John Doe',
      'account': '1234567890',
      'bank': 'GTBank',
      'reason': 'Medical bills for surgery',
    },
    {
      'name': 'Mary Smith',
      'account': '0987654321',
      'bank': 'Access Bank',
      'reason': 'School fees for children',
    },
    {
      'name': 'Hope Foundation',
      'account': '1122334455',
      'bank': 'Zenith Bank',
      'reason': 'Feeding the homeless',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Needs', style: AppTextStyles.h5),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: donationNeeds.length,
        itemBuilder: (context, index) {
          final need = donationNeeds[index];
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
                    need['name'] ?? '',
                    style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Account: ${need['account']} (${need['bank']})',
                    style: AppTextStyles.bodyMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Reason: ${need['reason']}',
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
