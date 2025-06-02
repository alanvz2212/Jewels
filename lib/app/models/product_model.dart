// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final List<String> imageUrls;
//   final String category;
//   final double rating;
//   final int stock;
//   final String material;
//   final bool isFeatured;

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.imageUrls,
//     required this.category,
//     required this.rating,
//     required this.stock,
//     required this.material,
//     this.isFeatured = false,
//   });

//   // A factory constructor to convert a Map<String, dynamic> to a Product object
//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       id: map['id'],
//       name: map['name'],
//       description: map['description'],
//       price: map['price'],
//       imageUrls: List<String>.from(map['imageUrls']),
//       category: map['category'],
//       rating: map['rating'],
//       stock: map['stock'],
//       material: map['material'],
//       isFeatured: map['isFeatured'] ?? false,
//     );
//   }
// }
class Product {
  String? id; // Optional field to store Firebase-generated ID
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String category;
  final double rating;
  final int stock;
  final String material;
  final bool isFeatured;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.stock,
    required this.material,
    this.isFeatured = false,
  });

  // Convert Product to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'category': category,
      'rating': rating,
      'stock': stock,
      'material': material,
      'isFeatured': isFeatured,
    };
  }

  // Create Product from Firebase Map
  factory Product.fromMap(Map<String, dynamic> map, {String? id}) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      category: map['category'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      stock: map['stock']?.toInt() ?? 0,
      material: map['material'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
    );
  }
}
