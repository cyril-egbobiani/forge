import 'package:flutter_svg/svg.dart';
import '../models/user_info.dart';
import '../models/teaching.dart';
import '../models/quick_action.dart';
import '../models/activity.dart';

// Network Image URLs
class ImageUrls {
  static const String avatar = 'https://placehold.co/50x50/F5F5F5/grey?text=S';
  static const String teachingSpeaker =
      'https://images.unsplash.com/photo-1507003211169-0a3ad86888cb?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  static const String activityCamp =
      'https://images.unsplash.com/photo-1593883861545-c1e550c608b4?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  static const String activityGaming =
      'https://images.unsplash.com/photo-1550007887-34f36a5c1064?q=80&w=1975&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  static const String activityBrainstorm =
      'https://images.unsplash.com/photo-1553531649-166258414457?q=80&w=1969&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  static const String activityDiscussion =
      'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
}

// Mock Data Repository
class MockData {
  static const UserInfo userInfo = UserInfo(
    name: 'Segun',
    greeting: 'Good Morning',
    avatarUrl: ImageUrls.avatar,
  );

  static const Teaching latestTeaching = Teaching(
    title: 'Building and Maintaining',
    speaker: 'Pastor Ikemefuna Chiedu',
    duration: '1hr 42mins',
    description:
        'Understanding the importance and value when it comes to a life that requires proper construction and elevation.',
    imageUrl: ImageUrls.teachingSpeaker,
  );

  static final List<QuickAction> quickActions = [
    QuickAction(title: 'Events', icon: SvgPicture.asset('assets/event.svg')),
    QuickAction(
      title: 'Prayer Request',
      icon: SvgPicture.asset('assets/heart.svg'),
    ),
    QuickAction(title: 'Donate', icon: SvgPicture.asset('assets/donate.svg')),
    QuickAction(title: 'Devotion', icon: SvgPicture.asset('assets/book.svg')),
  ];

  static const List<Activity> latestActivities = [
    Activity(
      title: 'Preparation for summer camp coaching',
      imageUrl: ImageUrls.activityCamp,
    ),
    Activity(
      title: 'Forward Nation hangout with games involved',
      imageUrl: ImageUrls.activityGaming,
    ),
    Activity(
      title: 'Creative brainstorming session for team projects',
      imageUrl: ImageUrls.activityBrainstorm,
    ),
    Activity(
      title: 'Monthly verse discussion with pastors',
      imageUrl: ImageUrls.activityDiscussion,
    ),
  ];
}
