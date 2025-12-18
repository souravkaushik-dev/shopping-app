import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/favorite_manager.dart';
import '../data/cart_manager.dart';
import '../models/product_listing.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  String? expandedProductId;
  final Map<String, int> quantities = {};

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final items = FavouriteManager.favourites;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// 🔝 HEADING
              Text(
                "Favourites",
                style: GoogleFonts.inter(
                  fontSize: w * 0.085,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Products you loved",
                style: GoogleFonts.inter(
                  fontSize: w * 0.045,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              if (items.isEmpty)
                const Expanded(
                  child: Center(child: Text("No favourites yet")),
                ),

              if (items.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items[index];
                      final isExpanded =
                          expandedProductId == product.id;

                      quantities.putIfAbsent(product.id, () => 1);

                      return Column(
                        children: [
                          /// ❤️ MAIN CARD
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expandedProductId =
                                isExpanded ? null : product.id;
                              });
                            },
                            child: _favCard(product),
                          ),

                          /// ⬇️ EXPANDED DETAILS
                          AnimatedCrossFade(
                            firstChild: const SizedBox(),
                            secondChild:
                            _expandedDetails(product),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration:
                            const Duration(milliseconds: 250),
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// ❤️ MAIN FAV CARD
  Widget _favCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              product.name,
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.favorite, color: Colors.black),
        ],
      ),
    );
  }

  /// ⬇️ EXPANDED DETAIL CARD
  Widget _expandedDetails(Product product) {
    final price = product.isDiscounted
        ? product.discountedPrice
        : product.originalPrice;

    final qty = quantities[product.id]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DESCRIPTION
          Text(
            product.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          /// PRICE + TAX
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Price",
                  style:
                  GoogleFonts.inter(fontWeight: FontWeight.w500)),
              Text("₹$price"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("GST (${product.taxPercent.toInt()}%)"),
              Text(
                  "₹${(price * product.taxPercent / 100).toStringAsFixed(2)}"),
            ],
          ),

          const Divider(height: 24),

          /// QTY + ADD TO CART
          Row(
            children: [
              _qtyBtn(
                icon: Icons.remove,
                onTap: () {
                  if (qty > 1) {
                    setState(() {
                      quantities[product.id] = qty - 1;
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(qty.toString()),
              ),
              _qtyBtn(
                icon: Icons.add,
                onTap: () {
                  setState(() {
                    quantities[product.id] = qty + 1;
                  });
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await CartManager.add(product, qty: qty);

                  _showTopGlassSnackBar(
                    context,
                    "${product.name} added to cart",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
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
  void _showTopGlassSnackBar(BuildContext context, String message) {
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
                color: Colors.white.withOpacity(0.85), // glassy
                borderRadius: BorderRadius.circular(22),
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
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
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
