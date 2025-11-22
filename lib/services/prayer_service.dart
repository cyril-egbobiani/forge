import '../models/prayer_request.dart';
import '../services/api_service.dart';

class PrayerService {
  final ApiService _apiService = ApiService();

  Future<List<PrayerRequest>> getPrayerRequests() async {
    try {
      // First, establish connection
      final healthResult = await _apiService.healthCheck();
      if (healthResult == null) {
        throw Exception(
          'Cannot connect to server. Please check your connection.',
        );
      }

      // Fetch prayer requests
      return await _apiService.getPrayerRequests();
    } catch (e) {
      throw Exception('Failed to load prayer requests: $e');
    }
  }

  List<PrayerRequest> filterByCategory(
    List<PrayerRequest> requests,
    String category,
  ) {
    if (category == 'All') {
      return requests;
    }
    return requests.where((request) => request.category == category).toList();
  }

  static const List<String> categories = [
    'All',
    'Personal',
    'Family',
    'Health',
    'Church',
    'Community',
  ];
}
