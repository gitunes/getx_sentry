import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_sentry/getx_sentry.dart';

/// Details Screen - Demonstrates HTTP breadcrumb tracking
/// 
/// Shows how to:
/// - Track HTTP requests as breadcrumbs
/// - Track page navigation automatically
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    
    // ============================================
    // Manual Page Tracking (Optional)
    // ============================================
    // Note: If you use SentryRouteObserver, pages are tracked automatically.
    // This is an example of manual page tracking if needed.
    SentryService.instance?.setCurrentPage(
      'DetailsScreen',
      metadata: {
        'screen_type': 'details',
        'loaded_at': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Screen Info
              const Icon(
                Icons.analytics,
                size: 64,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),
              const Text(
                'Details Screen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This screen was automatically tracked by SentryRouteObserver',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              
              // HTTP Breadcrumb Example
              ElevatedButton.icon(
                onPressed: _simulateHttpRequest,
                icon: const Icon(Icons.cloud_download),
                label: const Text('Simulate GET Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 12),
              
              ElevatedButton.icon(
                onPressed: _simulatePostRequest,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Simulate POST Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 12),
              
              ElevatedButton.icon(
                onPressed: _simulateFailedRequest,
                icon: const Icon(Icons.cloud_off),
                label: const Text('Simulate Failed Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 32),
              
              // Back Button
              OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Home'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Simulate a GET HTTP request with breadcrumb tracking
  void _simulateHttpRequest() {
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.http,
      message: 'GET /api/users',
      data: {
        'method': 'GET',
        'url': 'https://api.example.com/api/users',
        'status_code': 200,
        'duration_ms': 145,
        'response_size': '2.5 KB',
      },
    );
    
    Get.snackbar(
      'HTTP GET Request',
      'Request tracked as breadcrumb',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Simulate a POST HTTP request with breadcrumb tracking
  void _simulatePostRequest() {
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.http,
      message: 'POST /api/users',
      data: {
        'method': 'POST',
        'url': 'https://api.example.com/api/users',
        'status_code': 201,
        'duration_ms': 320,
        'request_size': '1.2 KB',
        'response_size': '0.5 KB',
      },
    );
    
    Get.snackbar(
      'HTTP POST Request',
      'Request tracked as breadcrumb',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Simulate a failed HTTP request and capture as error
  Future<void> _simulateFailedRequest() async {
    // First add breadcrumb for the request attempt
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.http,
      message: 'GET /api/data - Request started',
      data: {
        'method': 'GET',
        'url': 'https://api.example.com/api/data',
      },
      level: SentryLevel.info,
    );
    
    // Simulate the failure
    final error = Exception('Network timeout: Connection failed after 30 seconds');
    
    // Add error breadcrumb
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.error,
      message: 'HTTP request failed: Network timeout',
      data: {
        'method': 'GET',
        'url': 'https://api.example.com/api/data',
        'error': 'Network timeout',
        'duration_ms': 30000,
      },
      level: SentryLevel.error,
    );
    
    // Capture the exception
    await SentryService.instance?.captureException(
      error,
      hint: 'HTTP request failed',
      extra: {
        'endpoint': '/api/data',
        'timeout': '30s',
      },
      tags: [
        {'key': 'error_type', 'value': 'network_timeout'},
        {'key': 'http_method', 'value': 'GET'},
      ],
    );
    
    Get.snackbar(
      'HTTP Request Failed',
      'Error captured and sent to Sentry',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
    );
  }
}
