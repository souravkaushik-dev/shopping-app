import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_listing.dart';
import 'product_data.dart';

class CartManager {
  /// 🛒 ProductName → Quantity
  static Map<String, int> _cart = {};

  /// 🔔 Reactive cart count (for UI)
  static final ValueNotifier<int> cartCountNotifier =
  ValueNotifier<int>(0);

  /// 🔹 Get cart as Product → Qty
  static Map<Product, int> get cartItems {
    final Map<Product, int> result = {};
    _cart.forEach((name, qty) {
      try {
        final product = products.firstWhere((p) => p.name == name);
        result[product] = qty;
      } catch (_) {}
    });
    return result;
  }

  /// 🔢 Total quantity
  static int get cartCount => cartCountNotifier.value;

  /// ➕ ADD ITEM
  static Future<void> add(Product product, {int qty = 1}) async {
    _cart[product.name] = (_cart[product.name] ?? 0) + qty;
    _syncCount();
    await _save();
  }

  /// ➖ DECREASE ITEM
  static Future<void> decrease(Product product) async {
    if (!_cart.containsKey(product.name)) return;

    if (_cart[product.name]! > 1) {
      _cart[product.name] = _cart[product.name]! - 1;
    } else {
      _cart.remove(product.name);
    }

    _syncCount();
    await _save();
  }

  /// ❌ REMOVE ITEM COMPLETELY
  static Future<void> remove(Product product) async {
    _cart.remove(product.name);
    _syncCount();
    await _save();
  }

  /// 🧹 CLEAR CART
  static Future<void> clear() async {
    _cart.clear();
    _syncCount();
    await _save();
  }

  /// 🔄 Update notifier
  static void _syncCount() {
    cartCountNotifier.value =
        _cart.values.fold(0, (sum, qty) => sum + qty);
  }

  /// 💾 SAVE LOCALLY
  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart_map', jsonEncode(_cart));
  }

  /// 🔄 LOAD ON APP START
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cart_map');
    if (data == null) {
      _syncCount();
      return;
    }

    final Map<String, dynamic> decoded = jsonDecode(data);
    _cart = decoded.map((k, v) => MapEntry(k, v as int));
    _syncCount();
  }
}
