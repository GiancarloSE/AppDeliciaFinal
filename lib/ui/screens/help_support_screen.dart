import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y Soporte'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Información de contacto
          const Text(
            'Contáctanos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            'Teléfono',
            '(064) 123-4567',
            Icons.phone,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            'WhatsApp',
            '+51 987 654 321',
            Icons.chat,
            Colors.green[700]!,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            'Email',
            'contacto@appdelicia.com',
            Icons.email,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            'Dirección',
            'Av. Principal 123, Huancayo',
            Icons.location_on,
            Colors.red,
          ),
          const SizedBox(height: 32),

          // Horario de atención
          const Text(
            'Horario de Atención',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                _buildScheduleRow('Lunes - Viernes', '9:00 AM - 8:00 PM'),
                const Divider(height: 24),
                _buildScheduleRow('Sábados', '10:00 AM - 6:00 PM'),
                const Divider(height: 24),
                _buildScheduleRow('Domingos', '10:00 AM - 2:00 PM'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Preguntas Frecuentes
          const Text(
            'Preguntas Frecuentes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            '¿Cómo hago un pedido?',
            'Navega por nuestro catálogo, agrega productos al carrito y completa el proceso de checkout con tus datos de entrega.',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '¿Cuánto tarda la entrega?',
            'El delivery demora entre 30-45 minutos. Si eliges recojo en tienda, tu pedido estará listo en 20 minutos.',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '¿Qué métodos de pago aceptan?',
            'Aceptamos efectivo, tarjetas de crédito/débito, Yape y Plin.',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '¿Puedo cancelar mi pedido?',
            'Sí, puedes cancelar tu pedido contactándonos antes de que entre en preparación.',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '¿Hacen entregas fuera de Huancayo?',
            'Por el momento solo hacemos entregas dentro de Huancayo. Estamos trabajando para expandir nuestro servicio.',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            '¿Los productos son frescos?',
            'Todos nuestros productos se preparan diariamente con ingredientes frescos y de la más alta calidad.',
          ),
          const SizedBox(height: 32),

          // Botón de contacto directo
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Contactar Soporte'),
                    content: const Text(
                      'Puedes contactarnos por:\n\n'
                      '📞 (064) 123-4567\n'
                      '💬 WhatsApp: +51 987 654 321\n'
                      '📧 contacto@appdelicia.com',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.support_agent, size: 24),
              label: const Text(
                'Contactar Soporte',
                style: TextStyle(fontSize: 16),
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
    );
  }

  Widget _buildContactCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
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
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          hours,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.help_outline,
            color: Color(0xFFE91E63),
            size: 20,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}