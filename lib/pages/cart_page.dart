import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/cart_manager.dart';
import '../data/checkout.dart';
import '../models/product_listing.dart';
import 'main_navigation.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool couponApplied = false;
  double couponDiscount = 0;
  String appliedCoupon = "";

  Map<Product, int> get items => CartManager.cartItems;

  double get subtotal {
    double sum = 0;
    items.forEach((product, qty) {
      final price = product.isDiscounted
          ? product.discountedPrice
          : product.originalPrice;
      sum += price * qty;
    });
    return sum;
  }

  double get taxTotal {
    double tax = 0;
    items.forEach((product, qty) {
      final price = product.isDiscounted
          ? product.discountedPrice
          : product.originalPrice;
      tax += (price * qty) * product.taxPercent / 100;
    });
    return tax;
  }

  double get couponEligibleAmount {
    double sum = 0;
    items.forEach((product, qty) {
      if (!product.isDiscounted) {
        sum += product.originalPrice * qty;
      }
    });
    return sum;
  }

  double get finalTotal =>
      subtotal + taxTotal - (couponApplied ? couponDiscount : 0);

  void applyCoupon(String code) {
    if (subtotal < 1000) {
      _showMsg("Minimum cart value ₹1000 required");
      return;
    }

    final discount = couponEligibleAmount * 0.2;
    couponDiscount = discount > 300 ? 300 : discount;

    setState(() {
      couponApplied = true;
      appliedCoupon = code;
    });

    _showMsg("Coupon $code applied");
  }

  void _showMsg(String msg) {
    _showTopGlassSnackBar(msg);
  }


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔝 HEADING
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "My Cart",
                    style: GoogleFonts.inter(
                      fontSize: w * 0.085,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Review your selected items",
                    style: GoogleFonts.inter(
                      fontSize: w * 0.045,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (items.isEmpty)
              const Expanded(
                child: Center(child: Text("Your cart is empty")),
              ),

            if (items.isNotEmpty)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  children: [
                    /// 🎟 COUPONS
                    Text(
                      "Coupons Available",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _couponCard(
                      title: "SAVE20",
                      subtitle: "20% off • Max ₹300 • Min ₹1000",
                      onApply: () => applyCoupon("SAVE20"),
                    ),

                    _couponCard(
                      title: "BIGDEAL",
                      subtitle: "Extra savings on eligible items",
                      onApply: () => applyCoupon("BIGDEAL"),
                    ),

                    const SizedBox(height: 24),

                    /// 🧾 CART ITEMS
                    ...items.entries.map((entry) {
                      final product = entry.key;
                      final qty = entry.value;
                      final price = product.isDiscounted
                          ? product.discountedPrice
                          : product.originalPrice;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                  Icons.shopping_bag_outlined),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹$price",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _qtyBtn(
                                  icon: Icons.remove,
                                  onTap: () async {
                                    await CartManager.decrease(product);
                                    setState(() {});
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(qty.toString()),
                                ),
                                _qtyBtn(
                                  icon: Icons.add,
                                  onTap: () async {
                                    await CartManager.add(product);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    /// 💰 TOTALS
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          _priceRow("Subtotal", subtotal),
                          _priceRow("Tax", taxTotal),
                          if (couponApplied)
                            _priceRow(
                              "Coupon ($appliedCoupon)",
                              -couponDiscount,
                            ),
                          const Divider(height: 24),
                          _priceRow("Total", finalTotal, bold: true),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _handleBuyNow(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                "Buy Now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 🎟 COUPON CARD
  Widget _couponCard({
    required String title,
    required String subtitle,
    required VoidCallback onApply,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: couponApplied ? null : onApply,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: couponApplied
                    ? Colors.grey.shade300
                    : Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                couponApplied ? "Applied" : "Apply",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight:
              bold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  void _handleBuyNow(BuildContext context) async {
    if (items.isEmpty) return;

    // Go to checkout success
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutSuccessPage(),
      ),
    );

    // Wait 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    // Clear cart if needed
    CartManager.clear();

    // Go to HomePage & clear stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNav()),
          (route) => false,
    );
  }
  void _showTopGlassSnackBar(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: -20, end: 0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: value == 0 ? 1 : 0,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88), // glassy
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.black),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

}
