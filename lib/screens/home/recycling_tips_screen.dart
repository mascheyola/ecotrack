
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Data class for a single recycling tip
class RecyclingTip {
  final String title;
  final String description;
  final IconData icon;

  const RecyclingTip({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class RecyclingTipsScreen extends StatelessWidget {
  const RecyclingTipsScreen({super.key});

  // A top-level, final list of the recycling tips using the new data class.
  static final List<RecyclingTip> _recyclingTips = [
    const RecyclingTip(
      icon: Icons.cleaning_services_outlined,
      title: "Limpia los envases",
      description:
          "Asegúrate de que los envases de plástico, vidrio y latas estén limpios y secos antes de reciclarlos para evitar la contaminación.",
    ),
    const RecyclingTip(
      icon: Icons.article_outlined,
      title: "Separa el papel y el cartón",
      description:
          "No mezcles papel y cartón con otros materiales. Quita cualquier cinta adhesiva o grapas antes de desecharlos.",
    ),
    const RecyclingTip(
      icon: Icons.broken_image_outlined,
      title: "Cuidado con el vidrio roto",
      description:
          "Envuelve los objetos de vidrio rotos en papel de periódico o cartón antes de tirarlos para la seguridad de los trabajadores de reciclaje.",
    ),
    const RecyclingTip(
      icon: Icons.battery_charging_full_outlined,
      title: "No tires las baterías a la basura",
      description:
          "Las baterías contienen químicos peligrosos. Llévalas a un punto de recolección especial para su correcto desecho.",
    ),
    const RecyclingTip(
      icon: Icons.shopping_bag_outlined,
      title: "Reduce el uso de bolsas de plástico",
      description:
          "Utiliza bolsas de tela reutilizables cuando vayas de compras para disminuir la cantidad de plástico de un solo uso.",
    ),
    const RecyclingTip(
      icon: Icons.local_drink_outlined,
      title: "Conoce los tipos de plástico",
      description:
          "Busca el número dentro del triángulo de reciclaje en los envases de plástico. No todos los plásticos se reciclan de la misma manera.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consejos de Reciclaje'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: _recyclingTips.length,
        itemBuilder: (context, index) {
          final tip = _recyclingTips[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ExpansionTile(
              leading: Icon(tip.icon, size: 40, color: Theme.of(context).primaryColor),
              title: Text(
                tip.title,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    tip.description,
                     style: GoogleFonts.lato(fontSize: 15, height: 1.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
