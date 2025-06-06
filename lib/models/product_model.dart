class Product {
  String? id;
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
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.stock,
    required this.material,
    required this.isFeatured,
  });
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

  factory Product.fromMap(Map<String, dynamic> map, {String? id}) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      imageUrls: map['imageUrls'] ?? '',
      category: map['category'] ?? '',
      rating: map['rating'] ?? '',
      stock: map['stock'] ?? '',
      material: map['material'] ?? '',
      isFeatured: map['isFeatured'] ?? '',
    );
  }
}
