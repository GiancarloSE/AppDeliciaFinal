import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product?;
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Producto no encontrado')),
      );
    }

    final cart = context.watch<CartModel>();
    final quantityInCart = cart.quantityOf(product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen del producto
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: const Color(0xFFE91E63),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.cake,
                      size: 120,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Contenido del producto
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F0),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Rating (decorativo)
                    Row(
                      children: [
                        ...List.generate(5, (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        )),
                        const SizedBox(width: 8),
                        const Text(
                          '(4.8)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Precio
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink.shade50,
                            Colors.orange.shade50,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Precio:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'S/ ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Descripción
                    const Text(
                      'Descripción',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Información adicional
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.local_shipping, 'Entrega disponible'),
                          const Divider(),
                          _buildInfoRow(Icons.schedule, 'Preparación: 30 min'),
                          const Divider(),
                          _buildInfoRow(Icons.verified, '100% Fresco'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Cantidad en carrito
                    if (quantityInCart > 0)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE91E63),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              color: Color(0xFFE91E63),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'En tu carrito: $quantityInCart ${quantityInCart == 1 ? "unidad" : "unidades"}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE91E63),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 100), // Espacio para los botones
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Botones de acción
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Botón quitar del carrito
              if (quantityInCart > 0)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE91E63),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    color: const Color(0xFFE91E63),
                    onPressed: () {
                      context.read<CartModel>().removeProduct(product.id);
                    },
                  ),
                ),
              if (quantityInCart > 0) const SizedBox(width: 8),
              
              // Botón agregar al carrito
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<CartModel>().addProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('${product.name} agregado al carrito'),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text(
                    'Agregar al carrito',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFE91E63),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}