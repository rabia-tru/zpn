import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terms and Conditions',
                            style: theme.textTheme.displayLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _termsText,
                            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      // Persist acceptance and go to home. Avoid using BuildContext across async gaps by
                      // scheduling navigation in a post-frame callback after confirming mounted.
                      try {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('accepted_terms', true);
                      } catch (_) {}
                      if (!mounted) return;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, '/home');
                      });
                    },
                    child: Text('I Agree', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary)),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Decline', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _termsText = '''
1. Acceptance of Terms

By using this application ("App"), you agree to these Terms and Conditions and our Privacy Policy. If you do not agree, please do not use the App.

2. Service Description

The App provides access to a virtual private network (VPN) service. Use of the service is subject to availability, and we may modify or discontinue the service at any time.

3. User Obligations

You agree to use the App in accordance with all applicable laws and these Terms. You must not use the App for any unlawful activity or to transmit content that infringes the rights of others.

4. Intellectual Property

All intellectual property rights in the App and its content are owned by or licensed to the App provider. You receive only a limited, non-exclusive licence to use the App as provided.

5. Privacy

Use of the App is subject to our Privacy Policy, which describes how we collect and use information. By using the App you consent to such collection and use.

6. Payments and Subscriptions

Where applicable, subscription terms, fees, and renewal rules are disclosed at the point of purchase. Refunds and cancellations are handled according to the terms presented at purchase.

7. Disclaimers and Limitation of Liability

The App is provided "as is" and "as available" without warranties of any kind. To the maximum extent permitted by law, the App and its providers are not liable for indirect, incidental, special, or consequential damages arising from your use of the App.

8. Indemnification

You agree to indemnify and hold harmless the App provider and its affiliates from any claims, liabilities, losses, or expenses arising from your use of the App or violation of these Terms.

9. Termination

We may suspend or terminate your access to the App at any time for violation of these Terms or for operational reasons.

10. Governing Law

These Terms are governed by the laws of the jurisdiction in which the App provider is established.

11. Changes to Terms

We may modify these Terms from time to time. Continued use of the App after changes indicates your acceptance of the updated Terms.

12. Contact

For questions about these Terms or the Privacy Policy, contact support@example.com.

By tapping "I Agree" you acknowledge that you have read and accepted these Terms and Conditions.
''';
