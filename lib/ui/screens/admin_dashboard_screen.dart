import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_products_screen.dart';
import 'admin_promotions_screen.dart';
import 'admin_orders_screen.dart';
import 'analytics_screen.dart';  // ← AGREGAR

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  // Verificar si el usuario es administrador
  bool _isAdmin(String email) {
    final adminEmails = [
      'admin@appdelicia.com',
      'soto@gmail.com', // Tu email para pruebas
    ];
    return adminEmails.contains(email.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Verificar acceso de administrador
    if (user == null || !_isAdmin(user.email ?? '')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Administración'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Acceso denegado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('No tienes permisos de administrador'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, ordersSnapshot) {
          final totalOrders = ordersSnapshot.data?.docs.length ?? 0;
          double totalRevenue = 0;
          
          if (ordersSnapshot.hasData) {
            for (var doc in ordersSnapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              totalRevenue += (data['total'] ?? 0.0) as double;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Estadísticas rápidas
                const Text(
                  'Resumen General',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Pedidos',
                        '$totalOrders',
                        Icons.shopping_bag,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Ingresos',
                        'S/ ${totalRevenue.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Opciones de administración
                const Text(
                  'Gestión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildAdminOption(
                  context,
                  title: 'Productos',
                  subtitle: 'Crear, editar y eliminar productos',
                  icon: Icons.inventory_2,
                  color: const Color(0xFFE91E63),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminProductsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                _buildAdminOption(
                  context,
                  title: 'Promociones',
                  subtitle: 'Gestionar ofertas y descuentos',
                  icon: Icons.local_offer,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPromotionsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                _buildAdminOption(
                  context,
                  title: 'Pedidos',
                  subtitle: 'Ver y gestionar pedidos',
                  icon: Icons.list_alt,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminOrdersScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                _buildAdminOption(
                  context,
                  title: 'Analítica',
                  subtitle: 'Ver reportes y estadísticas',
                  icon: Icons.bar_chart,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnalyticsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}