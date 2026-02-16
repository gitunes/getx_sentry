import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_sentry/getx_sentry.dart';

/// Settings Screen - Demonstrates Sentry event types and page tracking
/// 
/// Shows how to:
/// - Track page views
/// - Available breadcrumb types
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    
    // Track page view
    SentryService.instance?.setCurrentPage('SettingsScreen');
    
    // Add navigation breadcrumb
    SentryService.instance?.addBreadcrumb(
      type: SentryEventType.navigation,
      message: 'User navigated to Settings',
      data: {
        'from': 'HomeScreen',
        'to': 'SettingsScreen',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sentry Event Types Section
            const Text(
              'Sentry Event Types',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Available breadcrumb types in getx_sentry package',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Event Type Cards
            _buildEventTypeCard(
              'Navigation',
              'Track page/route transitions',
              Icons.navigation,
              Colors.blue,
            ),
            _buildEventTypeCard(
              'User Interaction',
              'Track button taps, gestures',
              Icons.touch_app,
              Colors.green,
            ),
            _buildEventTypeCard(
              'HTTP',
              'Track API requests and responses',
              Icons.http,
              Colors.orange,
            ),
            _buildEventTypeCard(
              'Error',
              'Track error occurrences',
              Icons.error,
              Colors.red,
            ),
            _buildEventTypeCard(
              'Warning',
              'Track warning events',
              Icons.warning,
              Colors.amber,
            ),
            _buildEventTypeCard(
              'Info',
              'Track informational events',
              Icons.info,
              Colors.purple,
            ),
            const SizedBox(height: 24),
            
            // Back Button
            OutlinedButton.icon(
              onPressed: () => Get.offNamed('/home'),
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
