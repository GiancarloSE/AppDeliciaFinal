import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_model.dart';
import '../../services/firebase_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _finalizarCompra(BuildContext context, CartModel cart) async {
    final firebaseService = FirebaseService();
    final currentUser = firebaseService.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para finalizar la compra'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Convertir items del carrito a formato para Firebase
    final items = cart.items.map((item) {
      return {
        'productId': item.product.id,
        'name': item.product.name,
        'price': item.product.price,
        'quantity': item.quantity,
        'image': item.product.image,
      };
    }).toList();

    // Guardar orden en Firebase
    final orderId = await firebaseService.createOrder(
      userId: currentUser.uid,
      items: items,
      total: cart.totalPrice,
    );

    if (orderId != null && context.mounted) {
      // Limpiar carrito
      cart.clear();

      // Mostrar confirmación
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text('¡Compra exitosa!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tu pedido ha sido registrado correctamente.'),
              const SizedBox(height: 8),
              Text('ID de orden: $orderId', style: const TextStyle(fontSize: 12)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar la compra'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Vaciar carrito'),
                    content: const Text('¿Estás seguro de que quieres vaciar todo el carrito?'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cart.clear();
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Vaciar'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 120, color: Colors.grey.shade300),
                  const SizedBox(height: 24),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Ir a comprar'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item.product.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.cake, size: 40),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'S/ ${item.product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Color(0xFFE91E63),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE91E63),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, size: 18),
                                          color: Colors.white,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                          onPressed: () => cart.removeProduct(item.product.id),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 18),
                                          color: Colors.white,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                          onPressed: () => cart.addProduct(item.product),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'S/ ${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total de productos:', style: TextStyle(fontSize: 16)),
                            Text('${cart.totalItems}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TOTAL:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                              'S/ ${cart.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _finalizarCompra(context, cart),
                            icon: const Icon(Icons.shopping_bag),
                            label: const Text('FINALIZAR COMPRA', style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}