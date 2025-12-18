import 'package:flutter/material.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:shopart/pages/settings_page.dart';
import '../data/cart_manager.dart';
import 'fav_page.dart';
import 'home_page.dart';
import 'cart_page.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    FavouritePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          /// MAIN CONTENT
          _pages[_currentIndex],

          /// FLOATING NAV BAR
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: w * 0.12,
            right: w * 0.12,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================================================================
/// 🔥 FLOATING NAV BAR (UI PERFECT)
/// ===================================================================
class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const int itemCount = 4;
  static const double navHeight = 72;
  static const double pillWidth = 56;
  static const double pillHeight = 44;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final itemWidth = totalWidth / itemCount;

        return SizedBox(
          height: navHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// NAV BACKGROUND
              Container(
                height: navHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),

              /// SLIDING PILL (USES SAME WIDTH AS ICON GRID)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: itemWidth * currentIndex +
                    (itemWidth - pillWidth) / 2,
                width: pillWidth,
                height: pillHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),

              /// ICON GRID (NO PADDING)
              Row(
                children: List.generate(
                  itemCount,
                      (index) => Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(index),
                      child: Center(
                        child: _NavIcon(
                          index: index,
                          currentIndex: currentIndex,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ===================================================================
/// 🔹 NAV ICON
/// ===================================================================
class _NavIcon extends StatelessWidget {
  final int index;
  final int currentIndex;

  const _NavIcon({
    required this.index,
    required this.currentIndex,
  });

  IconData _icon(bool active) {
    switch (index) {
      case 0:
        return active ? Hicons.home2Bold : Hicons.home2LightOutline;
      case 1:
        return active ? Hicons.buy3Bold : Hicons.buy3LightOutline;
      case 2:
        return active ? Hicons.heart2Bold : Hicons.heart2LightOutline;
      case 3:
        return active ? Hicons.settingBold : Hicons.settingLightOutline;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(
          _icon(isActive),
          size: 26,
          color: Colors.black,
        ),

        /// CART BADGE
        if (index == 1)
          ValueListenableBuilder<int>(
            valueListenable: CartManager.cartCountNotifier,
            builder: (_, count, __) {
              if (count == 0) return const SizedBox();
              return Positioned(
                top: -6,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
