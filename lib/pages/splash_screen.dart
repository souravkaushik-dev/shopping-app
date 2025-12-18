import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'main_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PageController _textController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> splashTexts = [
    {
      "title": "Hello Sir\nWelcome",
      "subtitle":
      "This shopping app is built\naccording to your requirements.",
    },
    {
      "title": "Tax & Pricing\nManagement",
      "subtitle":
      "Supports mixed tax groups\nwith 5% or 18% tax applied.",
    },
    {
      "title": "Cart & Checkout\nFeatures",
      "subtitle":
      "Coupon rules, final totals,\nand confetti animation on checkout.",
    },
  ];


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔳 BACKGROUND GRID WITH ICONS
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE6E6E6),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 42,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// ⬜ BOTTOM CARD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: h * 0.38,
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.08,
                vertical: 28,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  /// 🔄 SWIPEABLE TEXT
                  SizedBox(
                    height: h * 0.16,
                    child: PageView.builder(
                      controller: _textController,
                      itemCount: splashTexts.length,
                      onPageChanged: (index) {
                        setState(() => currentIndex = index);
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Text(
                              splashTexts[index]["title"]!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: w * 0.07,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              splashTexts[index]["subtitle"]!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: w * 0.038,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ● DOT INDICATOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      splashTexts.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: currentIndex == index ? 24 : 6,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.black
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// ▶ CONTINUE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainNav(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                        const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
