import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class InvoiceService {
  // Generar factura/boleta en PDF
  static Future<void> generateInvoice({
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required Map<String, dynamic> address,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double deliveryCost,
    required double total,
    required String paymentMethod,
    required String deliveryMethod,
    required DateTime orderDate,
  }) async {
    final pdf = pw.Document();

    // Formato de fecha
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDate = dateFormat.format(orderDate);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.pink500,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'AppDelicia',
                          style: pw.TextStyle(
                            fontSize: 32,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Pastelería y Repostería',
                          style: const pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'BOLETA DE VENTA',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'N° $orderId',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Información de la empresa
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'AppDelicia S.A.C.',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text('RUC: 20123456789', style: const pw.TextStyle(fontSize: 11)),
                    pw.Text('Dirección: Av. Principal 123, Huancayo', style: const pw.TextStyle(fontSize: 11)),
                    pw.Text('Teléfono: (064) 123-4567', style: const pw.TextStyle(fontSize: 11)),
                    pw.Text('Email: contacto@appdelicia.com', style: const pw.TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Información del cliente
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'DATOS DEL CLIENTE',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.pink500,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text('Nombre: $customerName', style: const pw.TextStyle(fontSize: 10)),
                          pw.Text('Email: $customerEmail', style: const pw.TextStyle(fontSize: 10)),
                          pw.Text('Teléfono: $customerPhone', style: const pw.TextStyle(fontSize: 10)),
                          if (deliveryMethod == 'delivery') ...[
                            pw.SizedBox(height: 5),
                            pw.Text('Dirección:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            pw.Text('${address['direccion']}', style: const pw.TextStyle(fontSize: 10)),
                            pw.Text('${address['distrito']}', style: const pw.TextStyle(fontSize: 10)),
                            if (address['referencia'] != null && address['referencia'].toString().isNotEmpty)
                              pw.Text('Ref: ${address['referencia']}', style: const pw.TextStyle(fontSize: 10)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 15),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'DETALLES DEL PEDIDO',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.pink500,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 10)),
                          pw.Text('Entrega: ${deliveryMethod == "delivery" ? "Delivery" : "Recojo en tienda"}', 
                                  style: const pw.TextStyle(fontSize: 10)),
                          pw.Text('Pago: ${_getPaymentMethodName(paymentMethod)}', 
                                  style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Tabla de productos
              pw.Text(
                'DETALLE DE PRODUCTOS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Producto',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Cant.',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'P. Unit.',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Subtotal',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  // Items
                  ...items.map((item) {
                    final itemSubtotal = item['price'] * item['quantity'];
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(item['name'], style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '${item['quantity']}',
                            style: const pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'S/ ${item['price'].toStringAsFixed(2)}',
                            style: const pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'S/ ${itemSubtotal.toStringAsFixed(2)}',
                            style: const pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 20),

              // Totales
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 250,
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 11)),
                            pw.Text('S/ ${subtotal.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 11)),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Costo de entrega:', style: const pw.TextStyle(fontSize: 11)),
                            pw.Text('S/ ${deliveryCost.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 11)),
                          ],
                        ),
                        pw.Divider(thickness: 2),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'TOTAL:',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'S/ ${total.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.pink500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      '¡Gracias por tu compra!',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Este documento es una representación impresa de una Boleta de Venta Electrónica',
                      style: const pw.TextStyle(fontSize: 9),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Descargar/Compartir PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Boleta_AppDelicia_$orderId.pdf',
    );
  }

  static String _getPaymentMethodName(String method) {
    switch (method) {
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
}