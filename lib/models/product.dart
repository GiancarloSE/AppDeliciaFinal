class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  // Crear desde Firestore
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] as String,
      description: data['description'] as String,
      price: (data['price'] as num).toDouble(),
      image: data['image'] as String,
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  // Métodos anteriores (compatibilidad)
  factory Product.fromMap(Map<String, dynamic> m) => Product(
        id: m['id'] as String,
        name: m['name'] as String,
        description: m['description'] as String,
        price: (m['price'] as num).toDouble(),
        image: m['image'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'image': image,
      };
}