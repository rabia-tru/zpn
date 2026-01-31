import 'package:flutter/material.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  // Dummy server list
  final List<Map<String, String>> servers = [
    {"country": "United States", "flag": "🇺🇸"},
    {"country": "Germany", "flag": "🇩🇪"},
    {"country": "United Kingdom", "flag": "🇬🇧"},
    {"country": "Pakistan", "flag": "🇵🇰"},
    {"country": "India", "flag": "🇮🇳"},
    {"country": "Japan", "flag": "🇯🇵"},
  ];

  String? selectedServer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Select Server",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Auto-select option
          Card(
            color: Theme.of(context).cardColor.withAlpha((0.98 * 255).round()),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Auto-select (Best Server)',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).iconTheme.color),
              onTap: () {
                // Simple auto-select algorithm: pick the first available server.
                final choice = servers.isNotEmpty ? servers[0]["country"]! : "Auto";
                Navigator.pop(context, choice);
              },
            ),
          ),
          // Server entries
          for (final server in servers)
            Card(
              color: Theme.of(context).cardColor.withAlpha((0.98 * 255).round()),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Text(
                  server["flag"]!,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(
                  server["country"]!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                ),
                trailing: Icon(
                  selectedServer == server["country"] ? Icons.check_circle : Icons.arrow_forward_ios,
                  color: selectedServer == server["country"] ? Colors.greenAccent : Theme.of(context).iconTheme.color,
                ),
                onTap: () {
                  setState(() {
                    selectedServer = server["country"];
                  });

                  // Pass server back to Home
                  Navigator.pop(context, server["country"]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
