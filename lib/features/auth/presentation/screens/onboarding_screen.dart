import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

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
      "title": "Track Your Fleet",
      "description": "Real-time tracking of all your vehicles and drivers from anywhere.",
      "lottie": "assets/lottie/track.json"
    },
    {
      "title": "Manage Expenses",
      "description": "Easily record and manage toll, fuel, and maintenance expenses instantly.",
      "lottie": "assets/lottie/expense.json"
    },
    {
      "title": "Offline Sync",
      "description": "Works perfectly without internet. Syncs data automatically when online.",
      "lottie": "assets/lottie/sync.json"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        onboardingData[index]["lottie"]!,
                        height: 300,
                        width: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.error_outline, size: 100, color: Colors.white54),
                      ),
                      40.heightBox,
                      onboardingData[index]["title"]!
                          .text
                          .xl3
                          .bold
                          .white
                          .make(),
                      20.heightBox,
                      onboardingData[index]["description"]!
                          .text
                          .lg
                          .color(Colors.white70)
                          .center
                          .make()
                          .px32(),
                    ],
                  );
                },
              ),
            ),
            
            // Pagination Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.cyan : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ).py32(),

            // Get Started Button
            if (_currentPage == onboardingData.length - 1)
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to Auth/Login screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: "Get Started".text.bold.xl.make(),
              ).px32().py16()
            else
              TextButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: "Next".text.white.xl.make(),
              ).px32().py16(),
          ],
        ),
      ),
    );
  }
}
