import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Subscribe to unlock premium servers and faster speeds.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Placeholder: implement purchase flow
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Purchase flow not implemented.'),
          ));
        },
        label: const Text('Subscribe'),
        icon: const Icon(Icons.lock_open),
      ),
    );
  }
}
