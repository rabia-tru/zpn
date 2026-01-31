import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final svgPath = 'assets/images/zpn_logo.svg';
  final outPath = 'android/app/src/main/res/drawable/launch_image.png';

  final svgFile = File(svgPath);
  if (!await svgFile.exists()) {
    stderr.writeln('SVG file not found at $svgPath');
    exit(2);
  }

  final svg = await svgFile.readAsString();
  // Allow base64 to contain newlines or whitespace; we'll strip whitespace before decoding.
  final reg = RegExp(r'data:image\\/png;base64,([A-Za-z0-9+/=\\s]+)', multiLine: true);
  final m = reg.firstMatch(svg);
  if (m == null) {
    stderr.writeln('No embedded PNG found in $svgPath');
    exit(3);
  }

  final b64 = m.group(1)!.replaceAll(RegExp(r'\s+'), '');
  try {
    final bytes = base64Decode(b64);
    final outFile = File(outPath);
    await outFile.create(recursive: true);
    await outFile.writeAsBytes(bytes, flush: true);
    stdout.writeln('Wrote embedded PNG to: $outPath (${bytes.length} bytes)');
    exit(0);
  } catch (e) {
    stderr.writeln('Failed to decode/write PNG: $e');
    exit(4);
  }
}
