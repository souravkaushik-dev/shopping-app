import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showAppInfo = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                /// 🔝 TITLE
                Text(
                  "Settings",
                  style: GoogleFonts.inter(
                    fontSize: w * 0.085,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "About the developer & app",
                  style: GoogleFonts.inter(
                    fontSize: w * 0.045,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 32),

                /// 👨‍💻 ABOUT DEV CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sourav Kaushik",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Pursuing BCA from Amity Online.\n"
                            "Based in Noida, India.\n\n"
                            "A passionate Flutter developer with 2+ years of hands-on experience "
                            "building high-quality, scalable mobile applications. I have successfully "
                            "published 6–7 production-ready apps on the Google Play Store, focusing on "
                            "clean UI, smooth animations, and user-centric design.\n\n"
                            "Skills & Expertise:\n"
                            "• Flutter\n"
                            "• Dart\n"
                            "• Application Security (CEH)\n"
                            "• REST APIs & Firebase\n"
                            "• UI/UX & Performance Optimization",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 🔗 LINKS
                      Row(
                        children: [
                          _linkPill(
                            label: "Play Store",
                            icon: Icons.shop,
                            url:
                            "https://play.google.com/store/apps/dev?id=7398452419891423738",
                          ),
                          const SizedBox(width: 12),
                          _linkPill(
                            label: "GitHub",
                            icon: Icons.code,
                            url:
                            "https://github.com/souravkaushik-dev",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// 🧩 HOW APP IS MADE TILE
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() => showAppInfo = !showAppInfo);
                    },
                    title: Text(
                      "How this app is made",
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Architecture & features",
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                    trailing: Icon(
                      showAppInfo
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// ⬇️ EXPANDED INFO
                AnimatedCrossFade(
                  firstChild: const SizedBox(),
                  secondChild: _appInfoCard(),
                  crossFadeState: showAppInfo
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🧾 APP INFO CARD
  Widget _appInfoCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _point(
            "Flutter Architecture",
            "The app is built using Flutter with a single codebase and Material widgets.",
          ),
          _point(
            "State & Persistence",
            "Cart and favourites are managed using lightweight manager classes "
                "with local persistence.",
          ),
          _point(
            "Design & UI Decisions",
            "Images are not added in the app. I tried to keep the app minimal, modern, "
                "light, and smooth. Dark theme or theme switching is not used intentionally. "
                "The app is designed to stay visually light and performance-friendly.",
          ),
          _point(
            "Features Implemented",
            "• Product listing with tax & discounts\n"
                "• Quantity-based cart & coupons\n"
                "• Persistent favourites & cart\n"
                "• Smooth animations and clean UI",
          ),
        ],
      ),
    );
  }


  Widget _point(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• $title",
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔗 LINK PILL
  Widget _linkPill({
    required String label,
    required IconData icon,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
