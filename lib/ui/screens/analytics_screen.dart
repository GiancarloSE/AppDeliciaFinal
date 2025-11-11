import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'week'; // week, month, year

  bool _isAdmin(String email) {
    final adminEmails = [
      'admin@appdelicia.com',
      'soto@gmail.com',
    ];
    return adminEmails.contains(email.toLowerCase());
  }

  DateTime _getStartDate() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'week':
        return now.subtract(const Duration(days: 7));
      case 'month':
        return DateTime(now.year, now.month - 1, now.day);
      case 'year':
        return DateTime(now.year - 1, now.month, now.day);
      default:
        return now.subtract(const Duration(days: 7));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || !_isAdmin(user.email ?? '')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Analítica')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Acceso denegado',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        title: const Text('Analítica de Ventas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('createdAt', isGreaterThan: _getStartDate())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          // Calcular KPIs
          final totalOrders = orders.length;
          double totalRevenue = 0;
          double averageOrderValue = 0;
          int totalProducts = 0;
          Map<String, int> productSales = {};
          Map<String, double> dailySales = {};
          Map<String, int> ordersByStatus = {
            'pendiente': 0,
            'preparando': 0,
            'enviado': 0,
            'entregado': 0,
            'cancelado': 0,
          };
          Map<String, int> paymentMethods = {
            'efectivo': 0,
            'tarjeta': 0,
            'yape': 0,
            'plin': 0,
          };

          for (var doc in orders) {
            final data = doc.data() as Map<String, dynamic>;
            final total = (data['total'] ?? 0.0) as double;
            totalRevenue += total;

            // Productos vendidos
            final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
            for (var item in items) {
              final productName = item['name'] as String;
              final quantity = item['quantity'] as int;
              totalProducts += quantity;
              productSales[productName] = (productSales[productName] ?? 0) + quantity;
            }

            // Ventas por día
            if (data['createdAt'] != null) {
              final date = (data['createdAt'] as Timestamp).toDate();
              final dateKey = DateFormat('dd/MM').format(date);
              dailySales[dateKey] = (dailySales[dateKey] ?? 0) + total;
            }

            // Estados de pedidos
            final status = data['estado'] ?? 'pendiente';
            ordersByStatus[status] = (ordersByStatus[status] ?? 0) + 1;

            // Métodos de pago
            final paymentMethod = data['metodoPago'] ?? 'efectivo';
            paymentMethods[paymentMethod] = (paymentMethods[paymentMethod] ?? 0) + 1;
          }

          if (totalOrders > 0) {
            averageOrderValue = totalRevenue / totalOrders;
          }

          // Top 5 productos más vendidos
          final topProducts = productSales.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final top5Products = topProducts.take(5).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selector de período
                Row(
                  children: [
                    const Text(
                      'Período: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'week',
                            label: Text('7 días'),
                            icon: Icon(Icons.calendar_today, size: 16),
                          ),
                          ButtonSegment(
                            value: 'month',
                            label: Text('30 días'),
                            icon: Icon(Icons.calendar_month, size: 16),
                          ),
                          ButtonSegment(
                            value: 'year',
                            label: Text('1 año'),
                            icon: Icon(Icons.calendar_view_month, size: 16),
                          ),
                        ],
                        selected: {_selectedPeriod},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _selectedPeriod = newSelection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // KPIs principales
                const Text(
                  'Métricas Principales',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildKPICard(
                        'Ingresos Totales',
                        'S/ ${totalRevenue.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.green,
                        subtitle: _getPeriodLabel(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKPICard(
                        'Pedidos',
                        '$totalOrders',
                        Icons.shopping_bag,
                        Colors.blue,
                        subtitle: 'Total de órdenes',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildKPICard(
                        'Ticket Promedio',
                        'S/ ${averageOrderValue.toStringAsFixed(2)}',
                        Icons.receipt_long,
                        Colors.orange,
                        subtitle: 'Por pedido',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKPICard(
                        'Productos Vendidos',
                        '$totalProducts',
                        Icons.inventory_2,
                        Colors.purple,
                        subtitle: 'Unidades',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Top 5 productos más vendidos
                const Text(
                  'Productos Más Vendidos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (top5Products.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'No hay datos de ventas',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  ...top5Products.asMap().entries.map((entry) {
                    final index = entry.key;
                    final product = entry.value;
                    final percentage = totalProducts > 0
                        ? (product.value / totalProducts * 100)
                        : 0.0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getTopColor(index).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getTopColor(index),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: percentage / 100,
                                          backgroundColor: Colors.grey[200],
                                          valueColor: AlwaysStoppedAnimation(
                                            _getTopColor(index),
                                          ),
                                          minHeight: 8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${percentage.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${product.value}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 32),

                // Estados de pedidos
                const Text(
                  'Estados de Pedidos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      _buildStatusRow(
                        'Pendientes',
                        ordersByStatus['pendiente'] ?? 0,
                        Colors.orange,
                        Icons.schedule,
                      ),
                      const Divider(height: 24),
                      _buildStatusRow(
                        'Preparando',
                        ordersByStatus['preparando'] ?? 0,
                        Colors.blue,
                        Icons.restaurant,
                      ),
                      const Divider(height: 24),
                      _buildStatusRow(
                        'Enviados',
                        ordersByStatus['enviado'] ?? 0,
                        Colors.purple,
                        Icons.local_shipping,
                      ),
                      const Divider(height: 24),
                      _buildStatusRow(
                        'Entregados',
                        ordersByStatus['entregado'] ?? 0,
                        Colors.green,
                        Icons.check_circle,
                      ),
                      const Divider(height: 24),
                      _buildStatusRow(
                        'Cancelados',
                        ordersByStatus['cancelado'] ?? 0,
                        Colors.red,
                        Icons.cancel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Métodos de pago
                const Text(
                  'Métodos de Pago',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      _buildPaymentRow(
                        'Efectivo',
                        paymentMethods['efectivo'] ?? 0,
                        Icons.money,
                      ),
                      const Divider(height: 24),
                      _buildPaymentRow(
                        'Tarjeta',
                        paymentMethods['tarjeta'] ?? 0,
                        Icons.credit_card,
                      ),
                      const Divider(height: 24),
                      _buildPaymentRow(
                        'Yape',
                        paymentMethods['yape'] ?? 0,
                        Icons.qr_code_scanner,
                      ),
                      const Divider(height: 24),
                      _buildPaymentRow(
                        'Plin',
                        paymentMethods['plin'] ?? 0,
                        Icons.phone_android,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Resumen de tendencias
                if (dailySales.isNotEmpty) ...[
                  const Text(
                    'Tendencia de Ventas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: dailySales.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'S/ ${entry.value.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE91E63),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
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
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, int count, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, int count, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE91E63), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '$count pedidos',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE91E63),
          ),
        ),
      ],
    );
  }

  Color _getTopColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return const Color(0xFFE91E63);
    }
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case 'week':
        return 'Últimos 7 días';
      case 'month':
        return 'Últimos 30 días';
      case 'year':
        return 'Último año';
      default:
        return '';
    }
  }
}