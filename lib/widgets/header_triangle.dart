import 'package:flutter/material.dart';

/// Mirrors the CSS trick used in every mockup:
///   width: 0; height: 0; border-style: solid;
///   border-width: 0 0 Npx Npx;
///   border-color: transparent transparent #000 transparent;
/// which renders as a solid right-triangle in the top-right corner.
class HeaderTriangle extends StatelessWidget {
  final double size;
  final Color color;

  const HeaderTriangle({super.key, this.size = 16, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrianglePainter(color),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
