import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_sentry/getx_sentry.dart';

import '../controllers/home_controller.dart';

/// Home Screen - Main demonstration screen for getx_sentry package
/// 
/// This screen shows all the main features of the package:
/// - Exception capturing
/// - Message sending
/// - Breadcrumb tracking
/// - Navigation tracking
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the HomeController instance
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Sentry Example'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Package Info Card
            _buildInfoCard(),
            const SizedBox(height: 16),
            
            // Counter Section
            _buildCounterSection(controller),
            const SizedBox(height: 16),
            
            // Exception Handling Section
            _buildSectionTitle('Exception Handling'),
            _buildActionButton(
              icon: Icons.error,
              label: 'Trigger Test Exception',
              description: 'Captures an exception and sends it to Sentry',
              color: Colors.red,
              onPressed: () => controller.triggerTestException(),
            ),
            const SizedBox(height: 12),
            
            // Message Sending Section
            _buildSectionTitle('Message Logging'),
            _buildActionButton(
              icon: Icons.info,
              label: 'Send Info Message',
              description: 'Sends an informational message to Sentry',
              color: Colors.blue,
              onPressed: () => controller.sendCustomMessage(
                message: 'User performed an action on home screen',
                level: SentryLevel.info,
              ),
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              icon: Icons.warning,
              label: 'Send Warning Message',
              description: 'Sends a warning level message to Sentry',
              color: Colors.orange,
              onPressed: () => controller.sendCustomMessage(
                message: 'Warning: High memory usage detected',
                level: SentryLevel.warning,
              ),
            ),
            const SizedBox(height: 12),
            
            // Breadcrumb Section
            _buildSectionTitle('Breadcrumb Tracking'),
            _buildActionButton(
              icon: Icons.track_changes,
              label: 'Add Custom Breadcrumb',
              description: 'Adds a breadcrumb to track user actions',
              color: Colors.purple,
              onPressed: () {
                SentryService.instance?.addBreadcrumb(
                  type: SentryEventType.userInteraction,
                  message: 'Custom breadcrumb added by user',
                  data: {
                    'action': 'button_tap',
                    'screen': 'home',
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                Get.snackbar(
                  'Breadcrumb Added',
                  'Custom breadcrumb has been recorded',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              icon: Icons.cloud_download,
              label: 'Simulate API Call',
              description: 'Simulates an HTTP request with breadcrumb tracking',
              color: Colors.teal,
              onPressed: () => controller.simulateApiCall(),
            ),
            const SizedBox(height: 12),
            
            // Navigation Section
            _buildSectionTitle('Navigation'),
            _buildActionButton(
              icon: Icons.arrow_forward,
              label: 'Go to Details Screen',
              description: 'Navigate and track route automatically',
              color: Colors.green,
              onPressed: () => Get.toNamed('/details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  'GetX Sentry Package',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'This example demonstrates the integration between GetX and Sentry. '
              'Use the buttons below to test different features.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterSection(HomeController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Counter with Breadcrumb Tracking',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
              '${controller.counter.value}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => controller.incrementCounter(),
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Each increment is tracked as a breadcrumb',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onPressed,
      ),
    );
  }
}
