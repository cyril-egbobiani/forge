import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class NetworkTestScreen extends StatefulWidget {
  const NetworkTestScreen({super.key});

  @override
  State<NetworkTestScreen> createState() => _NetworkTestScreenState();
}

class _NetworkTestScreenState extends State<NetworkTestScreen> {
  final ApiService _apiService = ApiService();
  String _testResults = 'Tap "Test Connection" to start...';
  bool _isLoading = false;

  Future<void> _testConnectivity() async {
    setState(() {
      _isLoading = true;
      _testResults = 'Testing connectivity...\n';
    });

    // Test each URL individually
    for (String baseUrl in ApiConfig.baseUrls) {
      setState(() {
        _testResults += '\n🔍 Testing: $baseUrl\n';
      });

      try {
        final healthUrl = '$baseUrl/api/health';
        setState(() {
          _testResults += '  📡 Trying: $healthUrl\n';
        });

        final response = await _apiService.healthCheck();
        if (response != null) {
          setState(() {
            _testResults += '  ✅ SUCCESS: Connected!\n';
            _testResults += '  📋 Response: ${response.toString()}\n';
          });
          break;
        } else {
          setState(() {
            _testResults += '  ❌ FAILED: No response\n';
          });
        }
      } catch (e) {
        setState(() {
          _testResults += '  ❌ ERROR: $e\n';
        });
      }

      // Small delay between attempts
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      _isLoading = false;
      _testResults += '\n🏁 Test completed.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Connection Test'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Backend Connectivity Test',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Current API URLs being tested:',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ApiConfig.baseUrls
                    .map(
                      (url) =>
                          Text('• $url', style: const TextStyle(fontSize: 12)),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnectivity,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Test Connection'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Test Results:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
