import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:neon_lecture/core/theme/colors.dart';
import 'package:neon_lecture/core/theme/text_styles.dart';
import 'package:neon_lecture/core/widgets/gradient_background.dart';
import 'package:neon_lecture/core/widgets/neon_button.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'LISTEN & LEARN',
      description: 'Real-time high-accuracy transcription of your live lectures.',
      icon: Icons.mic_none_rounded,
      color: NeonColors.neonCyan,
    ),
    OnboardingData(
      title: 'BREAK BARRIERS',
      description: 'Instant translation into your preferred language as the speaker talks.',
      icon: Icons.translate_rounded,
      color: NeonColors.neonPurple,
    ),
    OnboardingData(
      title: 'VISUALIZE SUCCESS',
      description: 'Smart visual aids and images generated automatically from the context.',
      icon: Icons.auto_awesome_rounded,
      color: NeonColors.neonPink,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              
              // Bottom Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 48.0, 
                  vertical: MediaQuery.of(context).size.height < 600 ? 12.0 : 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => _buildIndicator(index),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height < 600 ? 16 : 32),
                    
                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: NeonButton(
                        text: _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                        color: _pages[_currentPage].color,
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index 
            ? _pages[_currentPage].color 
            : _pages[_currentPage].color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final bool isSmallScreen = screenHeight < 600;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0, 
                vertical: isSmallScreen ? 10.0 : 20.0
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: data.color.withValues(alpha: 0.5), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: data.color.withValues(alpha: 0.2),
                            blurRadius: isSmallScreen ? 20 : 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        data.icon,
                        size: isSmallScreen ? 32 : 40,
                        color: data.color,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      data.title,
                      style: NeonTextStyles.displaySmall.copyWith(
                        fontSize: isSmallScreen ? 20 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      data.description,
                      style: NeonTextStyles.bodyMedium.copyWith(
                        color: NeonColors.textSecondary,
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
