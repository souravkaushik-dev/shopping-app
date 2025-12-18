import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopart/pages/productdetail_page.dart';
import '../data/product_data.dart';
import '../models/product_listing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  int selectedIndex = 0;
  Timer? _autoScrollTimer;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: 4),
          (_) {
        if (!_userInteracting && _pageController.hasClients) {
          selectedIndex = (selectedIndex + 1) % products.length;
          _pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<Product> _relatedProducts(Product selected) {
    return products
        .where((p) =>
    p.taxPercent == selected.taxPercent &&
        p.name != selected.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final selectedProduct = products[selectedIndex];
    final related = _relatedProducts(selectedProduct);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.02),

              /// TOP BAR
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    Icon(Icons.notifications_none),
                  ],
                ),
              ),

              SizedBox(height: h * 0.04),

              /// TITLE
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discover",
                      style: GoogleFonts.inter(
                        fontSize: w * 0.085,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Your best products",
                      style: GoogleFonts.inter(
                        fontSize: w * 0.045,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.04),

              /// CAROUSEL
              SizedBox(
                height: h * 0.38,
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction != ScrollDirection.idle) {
                      _userInteracting = true;
                    } else {
                      _userInteracting = false;
                    }
                    return false;
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const PageScrollPhysics(),
                    itemCount: products.length,
                    onPageChanged: (index) {
                      setState(() => selectedIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: _carouselCard(products[index], w),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: h * 0.015),

              /// DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  products.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: selectedIndex == index ? 18 : 6,
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? Colors.black
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.04),

              /// VARIETIES
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Text(
                  "More like ${selectedProduct.name}",
                  style: GoogleFonts.inter(
                    fontSize: w * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: w > 600 ? 3 : 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: related.length,
                  itemBuilder: (context, index) {
                    return _miniCard(related[index]);
                  },
                ),
              ),

              SizedBox(height: h * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  /// CAROUSEL CARD
  Widget _carouselCard(Product product, double w) {
    final price = product.isDiscounted
        ? product.discountedPrice
        : product.originalPrice;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(w * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                  child: Icon(Icons.shopping_bag_outlined, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(product.name,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            if (product.isDiscounted)
              Text(
                "₹${product.originalPrice}",
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            Text(
              "₹$price",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "GST ${product.taxPercent.toInt()}%",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }


  /// MINI CARD
  Widget _miniCard(Product product) {
    final price = product.isDiscounted
        ? product.discountedPrice
        : product.originalPrice;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              "₹$price",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

}
