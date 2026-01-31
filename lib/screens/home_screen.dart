import 'package:flutter/material.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final wireguard = WireGuardFlutter.instance;
  bool isConnected = false;
  bool _isLoading = false;
  String selectedServer = ""; // empty = none selected
  final String _tunnelName = 'wg0';

  final List<String> availableServers = [
    "USA",
    "UK",
    "Germany",
    "Singapore",
    "Japan",
  ];

  // 🔐 Replace with your real configuration
  final String _config = '''
[Interface]
PrivateKey = sLBuDY7AinvgOjjq+xFDzeVhDjqiSEcxA1tHji3Vl30=
Address = 10.0.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = f3jHXTs9U8+Vo308OWbqvmy3H07+uTVEV8GXSviRr04=
Endpoint = 34.201.169.150:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
''';

  bool get hasSelectedServer => selectedServer.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initializeVpn();
  }

  Future<void> _initializeVpn() async {
    try {
      await wireguard.initialize(interfaceName: _tunnelName);
    } catch (e) {
      _showError('Failed to initialize VPN: $e');
    }
  }

  Future<void> _toggleVpn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (isConnected) {
        // 🔴 Disconnect VPN
        await wireguard.stopVpn();
        setState(() {
          isConnected = false;
        });
        _showDisconnected('VPN Disconnected'); // ✅ Fixed: Now shows red bar
      } else {
        // 🟢 Connect VPN
        await wireguard.startVpn(
          serverAddress: _extractEndpoint(),
          wgQuickConfig: _config,
          providerBundleIdentifier: 'com.example.testingnew',
        );
        setState(() {
          isConnected = true;
        });
        _showSuccess('VPN Connected');
      }
    } catch (e) {
      _showError('VPN Error: $e');
      setState(() {
        isConnected = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _extractEndpoint() {
    final match = RegExp(r'Endpoint\s*=\s*(.+)').firstMatch(_config);
    if (match != null) {
      return match.group(1)!.trim();
    }
    throw Exception('Endpoint not found in config');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ✅ New method for showing disconnect message with red bar
  void _showDisconnected(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: theme.colorScheme.primary),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Center area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🟢🔴 Status Text
                    Text(
                      isConnected ? 'Connected' : 'Disconnected',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isConnected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🌍 Server Card
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.pushNamed(context, '/servers');
                        if (result != null && result is String) {
                          setState(() {
                            selectedServer = result;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        margin: const EdgeInsets.only(top: 12, bottom: 18),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.06 * 255).round()),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🌍', style: TextStyle(fontSize: 26)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hasSelectedServer
                                      ? selectedServer
                                      : 'Auto-select (Best Server)',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hasSelectedServer
                                      ? 'Selected server'
                                      : 'Tap to choose best server',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.keyboard_arrow_down,
                                color: theme.iconTheme.color),
                          ],
                        ),
                      ),
                    ),

                    // 🔘 Power Button
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () async {
                              if (!hasSelectedServer) {
                                final result =
                                    await Navigator.pushNamed(context, '/servers');
                                if (result != null && result is String) {
                                  setState(() {
                                    selectedServer = result;
                                  });
                                  await _toggleVpn();
                                }
                                return;
                              }
                              await _toggleVpn();
                            },
                      child: Container(
                        width: 168,
                        height: 168,
                        alignment: Alignment.center,
                        child: Container(
                          width: 148,
                          height: 148,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.colorScheme.primaryContainer,
                                theme.colorScheme.primary,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary
                                    .withAlpha((0.22 * 255).round()),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: theme.colorScheme.onPrimary
                                    .withAlpha((0.6 * 255).round()),
                                blurRadius: 6,
                                offset: const Offset(-6, -6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // 🟢 Green when connected, 🔴 Red when disconnected
                                color: isConnected ? Colors.green : Colors.red,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha((0.12 * 255).round()),
                                    blurRadius: 8,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                  : const Icon(
                                      Icons.power_settings_new,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}