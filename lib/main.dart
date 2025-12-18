import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopart/pages/splash_screen.dart';

import 'models/theme_manager.dart';
import 'pages/main_navigation.dart';
import 'data/cart_manager.dart';
import 'data/favorite_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CartManager.load();
  await FavouriteManager.load();
  await ThemeManager.load(); // 👈 LOAD SAVED THEME

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          /// 🔥 THIS IS THE KEY
          themeMode: mode,

          /// 🌞 LIGHT THEME
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF4F4F4),
            textTheme: GoogleFonts.interTextTheme(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),

          /// 🌙 DARK THEME
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            textTheme: GoogleFonts.interTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),

          home: const SplashPage(), // 👈 YOUR NAV STAYS
        );
      },
    );
  }
}
