import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 80});

  Future<Uint8List?> _extractEmbeddedPngBytes() async {
    try {
      final svg = await rootBundle.loadString('assets/images/zpn_logo.svg');
      // Look for data:image/png;base64,.... inside the svg
      final reg = RegExp(r'data:image\/png;base64,([^"\)\s]+)', multiLine: true);
      final m = reg.firstMatch(svg);
      if (m != null && m.groupCount >= 1) {
        final b64 = m.group(1)!.replaceAll(RegExp(r'\s+'), '');
        return base64Decode(b64);
      }
    } catch (_) {
      // ignore and fallback to svg rendering
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _extractEmbeddedPngBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Reserve space while loading
          return SizedBox(width: size, height: size);
        }

        final bytes = snapshot.data;
        if (bytes != null && bytes.isNotEmpty) {
          return Image.memory(bytes, width: size, height: size, fit: BoxFit.contain);
        }

        // Fallback to SVG rendering
        return SvgPicture.asset(
          'assets/images/zpn_logo.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
          semanticsLabel: 'ZPN Logo',
        );
      },
    );
  }
}
