import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Manage Your Fleet",
      "description": "Easily assign and manage trips, drivers, and vehicles from a single intuitive dashboard.",
      "lottie": "assets/lottie/car_green.json"
    },
    {
      "title": "Expense Tracking",
      "description": "Record and manage toll, fuel, and maintenance expenses instantly on the go.",
      "lottie": "assets/lottie/money.json"
    },
    {
      "title": "Offline Syncing",
      "description": "Works perfectly without internet. Syncs data automatically when you're back online.",
      "lottie": "assets/lottie/sync.json"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background Gradient accents for premium look
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(color: Colors.cyan.withOpacity(0.1), blurRadius: 100, spreadRadius: 50)
                ]
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(color: Colors.purple.withOpacity(0.1), blurRadius: 100, spreadRadius: 50)
                ]
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                      });
                    },
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      return Lottie.asset(
                        onboardingData[index]["lottie"]!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.broken_image, size: 100, color: Colors.white24),
                      ).p32().animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
                    },
                  ),
                ),
                
                // Bottom Content Card (Glassmorphism style)
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        // Pagination
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: _currentPage == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index ? Colors.cyan : Colors.white24,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ).animate().fade(duration: 500.ms),
                        
                        32.heightBox,

                        // Title & Desc (Animated on page change)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            key: ValueKey<int>(_currentPage),
                            children: [
                              onboardingData[_currentPage]["title"]!
                                  .text
                                  .xl3
                                  .bold
                                  .white
                                  .make()
                                  .animate()
                                  .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut)
                                  .fade(duration: 400.ms),
                              16.heightBox,
                              onboardingData[_currentPage]["description"]!
                                  .text
                                  .lg
                                  .color(Colors.white60)
                                  .center
                                  .textStyle(const TextStyle(height: 1.4))
                                  .make()
                                  .animate()
                                  .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut)
                                  .fade(duration: 500.ms),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Bottom Button
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _currentPage == onboardingData.length - 1
                              ? ElevatedButton(
                                  onPressed: () {
                                    context.go('/login');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan,
                                    foregroundColor: Colors.black,
                                    elevation: 10,
                                    shadowColor: Colors.cyan.withOpacity(0.5),
                                    minimumSize: const Size(double.infinity, 56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: "Get Started".text.xl.bold.make(),
                                ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _pageController.animateToPage(
                                          onboardingData.length - 1,
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: "Skip".text.white.lg.make(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _pageController.nextPage(
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.cyan,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.cyan,
                                              blurRadius: 10,
                                              spreadRadius: -2,
                                            )
                                          ]
                                        ),
                                        child: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
