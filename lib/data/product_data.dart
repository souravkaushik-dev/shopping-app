import '../models/product_listing.dart';

final List<Product> products = [
  Product(
    id: "p1",
    name: 'Wireless Headphones',
    originalPrice: 2000,
    discountedPrice: 1500,
    isDiscounted: true,
    taxPercent: 18,
    description:
    'High-quality wireless headphones with immersive sound and deep bass.',
  ),
  Product(
    id: "p2",
    name: 'Bluetooth Speaker',
    originalPrice: 1200,
    taxPercent: 18,
    description:
    'Portable Bluetooth speaker with clear sound and punchy bass.',
  ),
  Product(
    id: "p3",
    name: 'Notebook',
    originalPrice: 200,
    taxPercent: 5,
    description:
    'Premium notebook for daily notes and office work.',
  ),
  Product(
    id: "p4",
    name: 'Smart Watch',
    originalPrice: 3500,
    discountedPrice: 3000,
    isDiscounted: true,
    taxPercent: 18,
    description:
    'Smart watch with fitness tracking and notifications.',
  ),
  Product(
    id: "p5",
    name: 'Water Bottle',
    originalPrice: 500,
    taxPercent: 5,
    description:
    'Durable and lightweight bottle for daily hydration.',
  ),
];
