import 'package:flutter/material.dart';
import '../design_system.dart';
import '../widgets/common/section_widget.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Chats', style: AppTypography.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment, color: AppColors.primary),
            onPressed: () {
              // TODO: Navigate to new chat
              debugPrint('Start new chat');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.lg),

            // Recent Chats Section
            SectionWidget(title: 'Recent Chats', content: _buildRecentChats()),

            SizedBox(height: AppSpacing.section),

            // Group Chats Section
            SectionWidget(title: 'Group Chats', content: _buildGroupChats()),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentChats() {
    return Column(
      children: [
        _buildChatItem(
          name: 'Pastor Ikemefuna',
          lastMessage:
              'Thank you for your prayer request. I will be praying for you.',
          time: '2:30 PM',
          unreadCount: 0,
          isOnline: true,
        ),
        SizedBox(height: AppSpacing.lg),
        _buildChatItem(
          name: 'Sarah Johnson',
          lastMessage: 'Are you coming to the youth fellowship tonight?',
          time: '1:45 PM',
          unreadCount: 2,
          isOnline: true,
        ),
        SizedBox(height: AppSpacing.lg),
        _buildChatItem(
          name: 'David Thompson',
          lastMessage: 'The Bible study notes were very helpful. Thank you!',
          time: '12:20 PM',
          unreadCount: 0,
          isOnline: false,
        ),
      ],
    );
  }

  Widget _buildGroupChats() {
    return Column(
      children: [
        _buildChatItem(
          name: 'Youth Fellowship',
          lastMessage: 'Michael: Looking forward to tonight\'s meeting!',
          time: '3:15 PM',
          unreadCount: 5,
          isGroup: true,
        ),
        SizedBox(height: AppSpacing.lg),
        _buildChatItem(
          name: 'Prayer Warriors',
          lastMessage: 'Anna: Please pray for my family during this time.',
          time: '11:30 AM',
          unreadCount: 1,
          isGroup: true,
        ),
        SizedBox(height: AppSpacing.lg),
        _buildChatItem(
          name: 'Bible Study Group',
          lastMessage: 'Pastor: Tomorrow we\'ll be studying Romans chapter 8.',
          time: 'Yesterday',
          unreadCount: 0,
          isGroup: true,
        ),
      ],
    );
  }

  Widget _buildChatItem({
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    bool isOnline = false,
    bool isGroup = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.surfaceContainer,
                child: Icon(
                  isGroup ? Icons.group : Icons.person,
                  color: AppColors.secondaryText,
                  size: AppIconSizes.lg,
                ),
              ),
              if (isOnline && !isGroup)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: AppSpacing.xl),

          // Chat details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.tertiaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lastMessage,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      SizedBox(width: AppSpacing.md),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
