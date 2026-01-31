import 'package:flutter/material.dart';
import 'package:zpn/widgets/logo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info
            Center(
              child: Column(
                children: [
                  // App logo
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: AppLogo(size: 56)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "VPN User",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Secure Connection • Privacy First",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Options List
            ListTile(
              leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
              title: Text("Privacy Policy", style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                // Navigate to Privacy / Terms if needed
                Navigator.pushNamed(context, '/terms');
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
              title: Text("About", style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "VPN App",
                  applicationVersion: "1.0.0",
                  applicationIcon: Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
                  children: [
                    const Text("This VPN app provides a secure and private connection.\nWe do not collect or store your data."),
                  ],
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star_rate, color: Theme.of(context).colorScheme.primary),
              title: Text("Rate Us", style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                // Placeholder for app store link
              },
            ),
          ],
        ),
      ),
    );
  }
}
