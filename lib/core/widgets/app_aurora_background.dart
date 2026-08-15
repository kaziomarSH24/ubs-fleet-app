import 'package:flutter/material.dart';

class AppAuroraBackground extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  
  const AppAuroraBackground({
    super.key, 
    required this.child,
    this.floatingActionButton,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090514), // Very dark background
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          // 1. Deep Blue / Purple glow on bottom left
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4A148C).withValues(alpha: 0.4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A148C).withValues(alpha: 0.4),
                    blurRadius: 200,
                    spreadRadius: 100,
                  )
                ],
              ),
            ),
          ),
          
          // 2. Cyan / Teal glow top right
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                    blurRadius: 200,
                    spreadRadius: 100,
                  )
                ],
              ),
            ),
          ),

          // 3. Magenta / Pink diagonal wave in the middle
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: -100,
            right: -100,
            child: Transform.rotate(
              angle: -0.3, // slight diagonal tilt
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(125),
                  color: const Color(0xFFE20074).withValues(alpha: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE20074).withValues(alpha: 0.25),
                      blurRadius: 250,
                      spreadRadius: 120,
                    )
                  ],
                ),
              ),
            ),
          ),

          // 4. Dot Grid Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _DotGridPainter(),
            ),
          ),

          // The actual page content
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const double spacing = 20.0;
    const double radius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
