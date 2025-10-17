import 'package:flutter/material.dart';
import '../../models/quick_action.dart';
import '../buttons/quick_action_button.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsWidget({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions
          .map(
            (action) => QuickActionButton(
              action: action,
              onTap: () => _handleActionTap(action.title),
            ),
          )
          .toList(),
    );
  }

  void _handleActionTap(String actionTitle) {
    // TODO: Implement navigation logic based on action
    switch (actionTitle.toLowerCase()) {
      case 'events':
        // Navigate to events screen
        debugPrint('Navigate to Events');
        break;
      case 'prayer request':
        // Navigate to prayer request screen
        debugPrint('Navigate to Prayer Request');
        break;
      case 'donate':
        // Navigate to donation screen
        debugPrint('Navigate to Donate');
        break;
      case 'devotion':
        // Navigate to devotion screen
        debugPrint('Navigate to Devotion');
        break;
      default:
        debugPrint('Unknown action: $actionTitle');
    }
  }
}
