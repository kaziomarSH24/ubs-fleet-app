import 'dart:ui';
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
      backgroundColor: const Color(0xFF090D14), // Very dark slate/blue background
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          // 1. Subtle Teal/Cyan glow on top left
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00E5FF).withValues(alpha: 0.6),
              ),
            ),
          ),
          
          // 2. Subtle Purple glow top right
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7B1FA2).withValues(alpha: 0.6),
              ),
            ),
          ),

          // The magical blur that turns shapes into smooth gradients
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
              child: Container(
                color: const Color(0xFF090D14).withValues(alpha: 0.7), // Soft overlay to tone down the colors further
              ),
            ),
          ),

          // The actual page content
          SafeArea(child: child),
        ],
      ),
    );
  }
}
