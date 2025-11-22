import 'package:flutter/material.dart';
import 'package:forge/utils/app_colors.dart';
import 'package:forge/utils/responsive_helper.dart';
import 'package:forge/utils/app_text_styles.dart';
import 'package:forge/utils/app_dimensions.dart';
import 'package:forge/services/api_service.dart';

class NewPrayerScreen extends StatefulWidget {
  const NewPrayerScreen({super.key});

  @override
  State<NewPrayerScreen> createState() => _NewPrayerScreenState();
}

class _NewPrayerScreenState extends State<NewPrayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();

  String _selectedCategory = 'Personal';
  bool _isAnonymous = true;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Personal',
    'Family',
    'Health',
    'Church',
    'Community',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        title: Text(
          'New Prayer Request',
          style: AppTextStyles.h5.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPrayerRequest,
            child: Text(
              'Submit',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _isSubmitting ? Colors.grey : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroSection(),
              SizedBox(height: AppSpacing.lg),
              _buildTitleField(),
              SizedBox(height: AppSpacing.md),
              _buildCategorySelection(),
              SizedBox(height: AppSpacing.md),
              _buildDescriptionField(),
              SizedBox(height: AppSpacing.md),
              _buildPrivacySettings(),
              SizedBox(height: AppSpacing.lg),
              _buildSubmitButton(),
              SizedBox(height: AppSpacing.md),
              _buildGuidelines(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: AppColors.primary,
                size: ResponsiveHelper.w(24),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Text(
                'Share Your Prayer Request',
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            'Our community believes in the power of prayer. Share your request so others can join you in prayer.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prayer Title *',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        TextFormField(
          controller: _titleController,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Brief title for your prayer request',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
            filled: true,
            fillColor: AppColors.dark900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.all(ResponsiveHelper.w(16)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title for your prayer request';
            }
            if (value.length < 5) {
              return 'Title must be at least 5 characters long';
            }
            return null;
          },
          maxLength: 100,
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Wrap(
          spacing: ResponsiveHelper.w(8),
          runSpacing: ResponsiveHelper.h(8),
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(16),
                  vertical: ResponsiveHelper.h(10),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getCategoryColor(category)
                      : AppColors.dark900,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
                  border: Border.all(
                    color: isSelected
                        ? _getCategoryColor(category)
                        : Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      color: isSelected
                          ? Colors.white
                          : _getCategoryColor(category),
                      size: ResponsiveHelper.w(18),
                    ),
                    SizedBox(width: ResponsiveHelper.w(6)),
                    Text(
                      category,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.8),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prayer Description *',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        TextFormField(
          controller: _descriptionController,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          maxLines: 6,
          decoration: InputDecoration(
            hintText:
                'Share details about your prayer request. Be as specific or general as you\'re comfortable with.',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
            filled: true,
            fillColor: AppColors.dark900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.all(ResponsiveHelper.w(16)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please describe your prayer request';
            }
            if (value.length < 10) {
              return 'Description must be at least 10 characters long';
            }
            return null;
          },
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Settings',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(12)),
          SwitchListTile(
            value: _isAnonymous,
            onChanged: (value) {
              setState(() {
                _isAnonymous = value;
              });
            },
            title: Text(
              'Submit Anonymously',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            subtitle: Text(
              'Your name will not be visible to others',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submitPrayerRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          ),
          elevation: 0,
        ),
        icon: _isSubmitting
            ? SizedBox(
                width: ResponsiveHelper.w(20),
                height: ResponsiveHelper.w(20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(Icons.send),
        label: Text(
          _isSubmitting ? 'Submitting...' : 'Submit Prayer Request',
          style: AppTextStyles.buttonMedium.copyWith(
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelines() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber,
                size: ResponsiveHelper.w(16),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),
              Text(
                'Prayer Guidelines',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          Text(
            '• Be respectful and appropriate\n'
            '• Avoid sharing personal details of others without permission\n'
            '• Focus on requests that build up the community\n'
            '• Remember that your request will be visible to others',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Colors.blue;
      case 'family':
        return Colors.green;
      case 'health':
        return Colors.red;
      case 'church':
        return Colors.purple;
      case 'community':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Icons.person;
      case 'family':
        return Icons.family_restroom;
      case 'health':
        return Icons.health_and_safety;
      case 'church':
        return Icons.church;
      case 'community':
        return Icons.groups;
      default:
        return Icons.favorite;
    }
  }

  Future<void> _submitPrayerRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // First establish connection
      final healthResult = await _apiService.healthCheck();
      if (healthResult == null) {
        throw Exception('Unable to connect to server');
      }

      // Create prayer request
      final prayerRequest = await _apiService.createPrayerRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        isAnonymous: _isAnonymous,
      );

      if (prayerRequest != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prayer request submitted successfully!'),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        throw Exception('Failed to create prayer request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit prayer request: $e'),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
