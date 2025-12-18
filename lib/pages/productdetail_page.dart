import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/favorite_manager.dart';
import '../models/product_listing.dart';
import '../data/cart_manager.dart';
import '../data/checkout.dart';
import 'cart_page.dart';
import 'home_page.dart' show HomePage;
import 'main_navigation.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  int quantity = 1;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final product = widget.product;
    final basePrice =
    product.isDiscounted ? product.discountedPrice : product.originalPrice;
    final taxAmount = basePrice * product.taxPercent / 100;
    final totalPrice = basePrice + taxAmount;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      /// 🔝 APP BAR WITH CART BADGE
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartPage(),
                    ),
                  );
                },
              ),
              if (CartManager.cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.black,
                    child: Text(
                      CartManager.cartCount.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          /// 🖼 PRODUCT IMAGE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.shopping_bag_outlined, size: 80),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 👇 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME + FAV
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.inter(
                          fontSize: w * 0.055,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            FavouriteManager.toggle(product);
                          });
                        },
                        child: Icon(
                          FavouriteManager.isFavourite(product)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// PRICE
                  Text(
                    "₹$basePrice",
                    style: GoogleFonts.inter(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 📄 DESCRIPTION (FADE + READ MORE)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: GoogleFonts.inter(
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          maxLines: expanded ? null : 3,
                          overflow: expanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: w * 0.038,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () =>
                              setState(() => expanded = !expanded),
                          child: Text(
                            expanded ? "Read less" : "Read more",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// 💰 TAX BREAKUP
                  Text(
                    "Price Details",
                    style: GoogleFonts.inter(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _priceRow("Base price", basePrice),
                  _priceRow(
                      "GST (${product.taxPercent.toInt()}%)", taxAmount),
                  const Divider(),
                  _priceRow("Total", totalPrice, bold: true),

                  const SizedBox(height: 30),

                  /// 🛒 BUY + CART
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleBuyNow(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding:
                            const EdgeInsets.symmetric(vertical: 16),
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
                      const SizedBox(width: 12),

                      /// CART ICON WITH SNACKBAR
                      GestureDetector(
                        onTap: () {
                          CartManager.add(product);

                          _showTopSnackBar(
                            context,
                            "${product.name} added to cart",
                          );

                          setState(() {});
                        },
                        child: _circleIcon(Icons.shopping_cart_outlined),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PRICE ROW
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
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// BUY BOTTOM SHEET
  void _showBuySheet(BuildContext context, double totalPrice) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.product.name,
                  style:
                  GoogleFonts.inter(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(
                "₹${(totalPrice * quantity).toStringAsFixed(2)}",
              ),
              const SizedBox(height: 20),

              /// QTY
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    onPressed: () => setState(() => quantity++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  CartManager.add(widget.product);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CheckoutSuccessPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                ),
                child: const Text(
                  "Confirm Purchase",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ROUND ICON
  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:
      const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon),
    );
  }
  void _showTopSnackBar(BuildContext context, String message) {
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
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
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
                      style: const TextStyle(color: Colors.black),
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
  void _handleBuyNow(BuildContext context) async {
    // Optional: add product to cart or process checkout
    CartManager.add(widget.product);

    // Navigate to success page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutSuccessPage(),
      ),
    );

    // Wait for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    // Go back to Home Page (remove all previous routes)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNav()),
          (route) => false,
    );
  }

}
