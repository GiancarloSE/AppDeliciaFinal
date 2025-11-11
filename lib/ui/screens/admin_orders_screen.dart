import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  bool _isAdmin(String email) {
    final adminEmails = [
      'admin@appdelicia.com',
      'soto@gmail.com',
    ];
    return adminEmails.contains(email.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || !_isAdmin(user.email ?? '')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pedidos')),
        body: const Center(child: Text('Acceso denegado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Pedidos'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No hay pedidos', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDoc = orders[index];
              final order = orderDoc.data() as Map<String, dynamic>;
              final orderId = orderDoc.id;
              final items = List<Map<String, dynamic>>.from(order['items'] ?? []);
              final total = order['total'] ?? 0.0;
              final createdAt = order['createdAt'] as Timestamp?;
              final date = createdAt?.toDate() ?? DateTime.now();
              final estado = order['estado'] ?? 'pendiente';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text('Pedido ${orderId.substring(0, 8)}...'),
                  subtitle: Text('${DateFormat('dd/MM/yyyy HH:mm').format(date)} - ${order['userEmail']}'),
                  trailing: _buildEstadoChip(estado),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...items.map((item) => Text('${item['quantity']}x ${item['name']}')),
                          const Divider(height: 24),
                          Text('Total: S/ ${total.toStringAsFixed(2)}', 
                               style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: () => _updateEstado(orderId, 'preparando'),
                                child: const Text('Preparando'),
                              ),
                              ElevatedButton(
                                onPressed: () => _updateEstado(orderId, 'enviado'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                child: const Text('Enviado'),
                              ),
                              ElevatedButton(
                                onPressed: () => _updateEstado(orderId, 'entregado'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text('Entregado'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEstadoChip(String estado) {
    Color color;
    switch (estado) {
      case 'preparando':
        color = Colors.blue;
        break;
      case 'enviado':
        color = Colors.purple;
        break;
      case 'entregado':
        color = Colors.green;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _updateEstado(String orderId, String nuevoEstado) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'estado': nuevoEstado});
  }
}