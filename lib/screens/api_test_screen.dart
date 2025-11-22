import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/teaching.dart';
import '../models/prayer_request.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _statusMessage = '';
  List<Teaching> _teachings = [];
  List<PrayerRequest> _prayers = [];

  @override
  void initState() {
    super.initState();
    _testApiConnection();
  }

  Future<void> _testApiConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing API connection...';
    });

    try {
      print('🔍 Starting API connection test...');

      // Test health check
      final healthData = await _apiService.healthCheck();
      if (healthData != null) {
        setState(() {
          _statusMessage = '✅ Backend connected! ${healthData['message']}';
        });
        print('✅ Health check successful: $healthData');
      } else {
        setState(() {
          _statusMessage =
              '❌ Backend connection failed - Check console for details';
        });
        print('❌ Health check returned null');
        return;
      }

      // Test getting teachings
      print('📖 Testing teachings API...');
      final teachings = await _apiService.getTeachings();
      setState(() {
        _teachings = teachings;
        _statusMessage +=
            '\n✅ Teachings API: ${teachings.length} teachings found';
      });

      // Test getting prayer requests
      print('🙏 Testing prayers API...');
      final prayers = await _apiService.getPrayerRequests();
      setState(() {
        _prayers = prayers;
        _statusMessage += '\n✅ Prayers API: ${prayers.length} prayers found';
      });
    } catch (e) {
      print('❌ API Test Error: $e');
      setState(() {
        _statusMessage = '❌ API Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createTestPrayer() async {
    setState(() {
      _isLoading = true;
    });

    final newPrayer = await _apiService.createPrayerRequest(
      title: 'Test Prayer Request',
      description: 'This is a test prayer request created from the Flutter app',
      category: 'general',
      isAnonymous: false,
      urgencyLevel: 'normal',
    );

    if (newPrayer != null) {
      setState(() {
        _prayers.insert(0, newPrayer);
        _statusMessage += '\n✅ Created test prayer request';
      });
    } else {
      setState(() {
        _statusMessage += '\n❌ Failed to create prayer request';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _createSampleData() async {
    setState(() {
      _isLoading = true;
      _statusMessage += '\n📝 Creating sample data...';
    });

    try {
      // Create sample teachings
      final sampleTeachings = [
        {
          'title': 'Building and Maintaining Faith',
          'speaker': 'Pastor David',
          'description':
              'A powerful message about strengthening your faith foundation',
          'series': 'Faith Foundations',
          'scripture': 'Hebrews 11:1',
          'duration': 35,
        },
        {
          'title': 'Love Your Neighbor',
          'speaker': 'Pastor Sarah',
          'description':
              'Understanding the commandment to love others as ourselves',
          'series': 'Love Series',
          'scripture': 'Mark 12:31',
          'duration': 28,
        },
        {
          'title': 'Prayer and Fasting',
          'speaker': 'Elder John',
          'description': 'The spiritual discipline of prayer and fasting',
          'series': 'Spiritual Disciplines',
          'scripture': 'Matthew 6:16-18',
          'duration': 42,
        },
      ];

      for (var teachingData in sampleTeachings) {
        await _apiService.createTeaching(
          title: teachingData['title'] as String,
          speaker: teachingData['speaker'] as String,
          description: teachingData['description'] as String,
          series: teachingData['series'] as String,
          scripture: teachingData['scripture'] as String,
          duration: teachingData['duration'] as int,
        );
      }

      // Create sample prayer requests
      final samplePrayers = [
        {
          'title': 'Healing for my grandmother',
          'description':
              'Please pray for my grandmother who is in the hospital',
          'category': 'health',
          'urgencyLevel': 'high',
        },
        {
          'title': 'Job search guidance',
          'description': 'Seeking God\'s direction in finding new employment',
          'category': 'work',
          'urgencyLevel': 'normal',
        },
        {
          'title': 'Marriage restoration',
          'description': 'Praying for healing and restoration in our marriage',
          'category': 'family',
          'urgencyLevel': 'urgent',
        },
      ];

      for (var prayerData in samplePrayers) {
        await _apiService.createPrayerRequest(
          title: prayerData['title'] as String,
          description: prayerData['description'] as String,
          category: prayerData['category'] as String,
          isAnonymous: false,
          urgencyLevel: prayerData['urgencyLevel'] as String,
        );
      }

      setState(() {
        _statusMessage += '\n✅ Sample data created successfully!';
      });

      // Refresh the data to update counts
      await _testApiConnection();
    } catch (e) {
      setState(() {
        _statusMessage += '\n❌ Error creating sample data: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isLoading)
                    const Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  Text(
                    _statusMessage,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _testApiConnection,
                      child: const Text('Test Connection'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _createTestPrayer,
                      child: const Text('Create Test Prayer'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _createSampleData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Create Sample Data'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Data Display
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      indicatorColor: Colors.orange,
                      tabs: [
                        Tab(text: 'Teachings'),
                        Tab(text: 'Prayers'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Teachings Tab
                          ListView.builder(
                            itemCount: _teachings.length,
                            itemBuilder: (context, index) {
                              final teaching = _teachings[index];
                              return ListTile(
                                title: Text(
                                  teaching.title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'By ${teaching.speaker} • ${teaching.durationText}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Icon(
                                  teaching.hasAudio
                                      ? Icons.audio_file
                                      : Icons.text_fields,
                                  color: Colors.orange,
                                ),
                              );
                            },
                          ),
                          // Prayers Tab
                          ListView.builder(
                            itemCount: _prayers.length,
                            itemBuilder: (context, index) {
                              final prayer = _prayers[index];
                              return ListTile(
                                title: Text(
                                  prayer.title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${prayer.displayAuthor} • ${prayer.timeAgo}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
