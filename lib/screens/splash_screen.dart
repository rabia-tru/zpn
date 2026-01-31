import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zpn/widgets/logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _pulseAnim = Tween<double>(begin: 0.99, end: 1.03).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _ctrl.forward().whenComplete(() {
      // start a subtle repeating pulse after entrance
      _pulseCtrl.repeat(reverse: true);
    });


    // Keep splash for 6 seconds then navigate; but avoid using BuildContext across async gaps
    Timer(const Duration(seconds: 6), () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final accepted = prefs.getBool('accepted_terms') ?? false;
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(accepted ? '/home' : '/terms');
      } catch (_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // compute responsive sizes so logo is big on phones but not oversized on tablets
    final mq = MediaQuery.of(context);
    final minSide = mq.size.shortestSide;
    final logoSize = (minSide * 0.45).clamp(140.0, 300.0);
    final containerSize = logoSize + 80.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Entrance animation nested with a subtle repeating pulse
                  AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (context, child) {
                      final pulse = _pulseAnim.value;
                      return Transform.scale(
                        scale: pulse,
                        child: child,
                      );
                    },
                    child: Material(
                      color: Colors.white,
                      elevation: 8,
                      shape: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: SizedBox(
                          width: containerSize,
                          height: containerSize,
                          child: Center(child: AppLogo(size: logoSize)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'ZPN',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
