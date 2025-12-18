import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_listing.dart';
import 'product_data.dart';

class FavouriteManager {
  static Set<String> _favourites = {};

  /// 🔹 Resolve favourites → Product list
  static List<Product> get favourites {
    return products
        .where((p) => _favourites.contains(p.id))
        .toList();
  }

  /// ❤️ Check
  static bool isFavourite(Product product) {
    return _favourites.contains(product.id);
  }

  /// 🔁 Toggle (used everywhere)
  static Future<bool> toggle(Product product) async {
    if (_favourites.contains(product.id)) {
      _favourites.remove(product.id);
    } else {
      _favourites.add(product.id);
    }
    await _save();
    return _favourites.contains(product.id);
  }

  /// ❌ Remove
  static Future<void> remove(Product product) async {
    _favourites.remove(product.id);
    await _save();
  }

  /// 💾 Save locally
  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'favourites',
      jsonEncode(_favourites.toList()),
    );
  }

  /// 🔄 Load on app start
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favourites');
    if (data == null) return;

    final List decoded = jsonDecode(data);
    _favourites = decoded.cast<String>().toSet();
  }
}
