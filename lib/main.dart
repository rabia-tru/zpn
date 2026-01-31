import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/terms_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/server_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(VPNApp());
}

class VPNApp extends StatelessWidget {
  const VPNApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      debugShowCheckedModeBanner: false,
  theme: AppTheme.appTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/terms': (context) => TermsScreen(),
        '/home': (context) => HomeScreen(),
        '/servers': (context) => ServerScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
