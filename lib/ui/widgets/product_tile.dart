import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../routes.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 56,
          child: Image.asset(product.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.fastfood)),
        ),
        title: Text(product.name),
        subtitle: Text('${product.price.toStringAsFixed(2)} S/'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pushNamed(context, Routes.product, arguments: product);
        },
      ),
    );
  }
}
