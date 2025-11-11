import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/cart_model.dart';
import '../../routes.dart';
import '../../services/invoice_service.dart';  // ← AGREGAR

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controladores para dirección
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _distritoController = TextEditingController();
  final _referenciaController = TextEditingController();

  // Opciones seleccionadas
  String _metodoEntrega = 'delivery'; // delivery o recojo
  String _metodoPago = 'efectivo'; // efectivo, tarjeta, yape, plin

  bool _isProcessing = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _distritoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  List<Step> _getSteps() {
    return [
      // PASO 1: Dirección de entrega
      Step(
        title: const Text('Dirección'),
        subtitle: const Text('¿Dónde entregamos?'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono *',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu teléfono';
                  }
                  if (value.length < 9) {
                    return 'Teléfono inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_metodoEntrega == 'delivery') ...[
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección *',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                    hintText: 'Calle, número, departamento',
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (_metodoEntrega == 'delivery' &&
                        (value == null || value.isEmpty)) {
                      return 'Ingresa tu dirección';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _distritoController,
                  decoration: const InputDecoration(
                    labelText: 'Distrito *',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_metodoEntrega == 'delivery' &&
                        (value == null || value.isEmpty)) {
                      return 'Ingresa tu distrito';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _referenciaController,
                  decoration: const InputDecoration(
                    labelText: 'Referencia (opcional)',
                    prefixIcon: Icon(Icons.info_outline),
                    border: OutlineInputBorder(),
                    hintText: 'Ej: Casa verde, portón negro',
                  ),
                  maxLines: 2,
                ),
              ],
            ],
          ),
        ),
      ),

      // PASO 2: Método de entrega
      Step(
        title: const Text('Entrega'),
        subtitle: const Text('¿Cómo lo recibimos?'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            RadioListTile<String>(
              value: 'delivery',
              groupValue: _metodoEntrega,
              onChanged: (value) {
                setState(() {
                  _metodoEntrega = value!;
                });
              },
              title: const Text('Delivery a domicilio'),
              subtitle: const Text('Entrega en 30-45 min • S/ 5.00'),
              secondary: const Icon(Icons.delivery_dining, size: 32),
              activeColor: const Color(0xFFE91E63),
            ),
            const Divider(),
            RadioListTile<String>(
              value: 'recojo',
              groupValue: _metodoEntrega,
              onChanged: (value) {
                setState(() {
                  _metodoEntrega = value!;
                });
              },
              title: const Text('Recojo en tienda'),
              subtitle: const Text('Listo en 20 min • Gratis'),
              secondary: const Icon(Icons.store, size: 32),
              activeColor: const Color(0xFFE91E63),
            ),
          ],
        ),
      ),

      // PASO 3: Método de pago
      Step(
        title: const Text('Pago'),
        subtitle: const Text('¿Cómo pagas?'),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _buildPaymentOption(
              'efectivo',
              'Efectivo',
              'Paga al recibir tu pedido',
              Icons.money,
            ),
            const Divider(),
            _buildPaymentOption(
              'tarjeta',
              'Tarjeta de crédito/débito',
              'Visa, Mastercard, AMEX',
              Icons.credit_card,
            ),
            const Divider(),
            _buildPaymentOption(
              'yape',
              'Yape',
              'Pago rápido con QR',
              Icons.qr_code_scanner,
            ),
            const Divider(),
            _buildPaymentOption(
              'plin',
              'Plin',
              'Transferencia instantánea',
              Icons.phone_android,
            ),
          ],
        ),
      ),

      // PASO 4: Resumen y confirmación
      Step(
        title: const Text('Confirmar'),
        subtitle: const Text('Revisa tu pedido'),
        isActive: _currentStep >= 3,
        state: StepState.indexed,
        content: Consumer<CartModel>(
          builder: (context, cart, child) {
            final costoEntrega = _metodoEntrega == 'delivery' ? 5.0 : 0.0;
            final total = cart.totalPrice + costoEntrega;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen de productos
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Productos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...cart.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x ${item.product.name}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                'S/ ${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Resumen de entrega
                _buildSummaryCard(
                  'Entrega',
                  _metodoEntrega == 'delivery'
                      ? 'Delivery a domicilio'
                      : 'Recojo en tienda',
                  _metodoEntrega == 'delivery'
                      ? '${_direccionController.text}, ${_distritoController.text}'
                      : 'Av. Principal 123, Huancayo',
                ),
                const SizedBox(height: 16),

                // Resumen de pago
                _buildSummaryCard(
                  'Método de pago',
                  _getPaymentMethodName(),
                  'Al recibir el pedido',
                ),
                const SizedBox(height: 16),

                // Total
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE91E63)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text('S/ ${cart.totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Costo de entrega:'),
                          Text('S/ ${costoEntrega.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'S/ ${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ];
  }

  Widget _buildPaymentOption(
      String value, String title, String subtitle, IconData icon) {
    return RadioListTile<String>(
      value: value,
      groupValue: _metodoPago,
      onChanged: (val) {
        setState(() {
          _metodoPago = val!;
        });
      },
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon, size: 32),
      activeColor: const Color(0xFFE91E63),
    );
  }

  Widget _buildSummaryCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPaymentMethodName() {
    switch (_metodoPago) {
      case 'efectivo':
        return 'Efectivo';
      case 'tarjeta':
        return 'Tarjeta';
      case 'yape':
        return 'Yape';
      case 'plin':
        return 'Plin';
      default:
        return 'Efectivo';
    }
  }

  Future<void> _finalizarPedido() async {
    final cart = Provider.of<CartModel>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para finalizar la compra'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final costoEntrega = _metodoEntrega == 'delivery' ? 5.0 : 0.0;
      final total = cart.totalPrice + costoEntrega;

      // Crear pedido en Firestore
      final orderData = {
        'userId': user.uid,
        'userEmail': user.email,
        'items': cart.items.map((item) {
          return {
            'productId': item.product.id,
            'name': item.product.name,
            'price': item.product.price,
            'quantity': item.quantity,
          };
        }).toList(),
        'subtotal': cart.totalPrice,
        'costoEntrega': costoEntrega,
        'total': total,
        'direccion': {
          'nombre': _nombreController.text,
          'telefono': _telefonoController.text,
          'direccion': _direccionController.text,
          'distrito': _distritoController.text,
          'referencia': _referenciaController.text,
        },
        'metodoEntrega': _metodoEntrega,
        'metodoPago': _metodoPago,
        'estado': 'pendiente',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // Generar factura en PDF (HU-05)
      try {
        await InvoiceService.generateInvoice(
          orderId: DateTime.now().millisecondsSinceEpoch.toString(),
          customerName: _nombreController.text,
          customerEmail: user.email ?? '',
          customerPhone: _telefonoController.text,
          address: {
            'nombre': _nombreController.text,
            'telefono': _telefonoController.text,
            'direccion': _direccionController.text,
            'distrito': _distritoController.text,
            'referencia': _referenciaController.text,
          },
          items: cart.items.map((item) {
            return {
              'productId': item.product.id,
              'name': item.product.name,
              'price': item.product.price,
              'quantity': item.quantity,
            };
          }).toList(),
          subtotal: cart.totalPrice,
          deliveryCost: costoEntrega,
          total: total,
          paymentMethod: _metodoPago,
          deliveryMethod: _metodoEntrega,
          orderDate: DateTime.now(),
        );
      } catch (e) {
        print('Error al generar factura: $e');
        // Continuar aunque falle la generación de factura
      }

      // Limpiar carrito
      cart.clear();

      setState(() {
        _isProcessing = false;
      });

      // Mostrar confirmación
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                '¡Pedido confirmado!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: S/ ${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFE91E63),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tu pedido ha sido registrado exitosamente.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu factura electrónica ha sido generada y descargada.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _metodoEntrega == 'delivery'
                    ? 'Tiempo estimado: 30-45 min'
                    : 'Listo para recoger en 20 min',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Ir al inicio'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, Routes.main);
              },
              child: const Text('Ver mis pedidos'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar el pedido: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            if (_currentStep == 0) {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _currentStep += 1;
                });
              }
            } else {
              setState(() {
                _currentStep += 1;
              });
            }
          } else {
            // Último paso: finalizar pedido
            _finalizarPedido();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Atrás'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : details.onStepContinue,
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _currentStep == 3 ? 'Confirmar pedido' : 'Continuar',
                          ),
                  ),
                ),
              ],
            ),
          );
        },
        steps: _getSteps(),
      ),
    );
  }
}