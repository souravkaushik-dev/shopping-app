class Product {
  final String id; // 👈 NEW
  final String name;
  final double originalPrice;
  final double discountedPrice;
  final bool isDiscounted;
  final double taxPercent;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.originalPrice,
    this.discountedPrice = 0,
    this.isDiscounted = false,
    required this.taxPercent,
    required this.description,
  });
}
