import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

// A dedicated, public data class for a recycling tip to ensure type safety.
class RecyclingTip {
  final IconData icon;
  final String title;
  final String description;

  const RecyclingTip({
    required this.icon,
    required this.title,
    required this.description,
  });
}

// A top-level, final list of the recycling tips using the new data class.
final List<RecyclingTip> _recyclingTips = [
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
    title: "Pilas y baterías, por separado",
    description:
        "Nunca tires las pilas o baterías a la basura común. Llévalas a puntos de recolección específicos para su tratamiento especial.",
  ),
  const RecyclingTip(
    icon: Icons.eco_outlined,
    title: "Composta los residuos orgánicos",
    description:
        "Los restos de comida y residuos de jardín pueden convertirse en abono para tus plantas. ¡Considera iniciar una compostera en casa!",
  ),
  const RecyclingTip(
    icon: Icons.reduce_capacity_outlined,
    title: "Reduce y Reutiliza",
    description:
        "El mejor residuo es el que no se genera. Antes de reciclar, piensa si puedes reducir tu consumo o reutilizar los objetos.",
  ),
];

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  void _shareTips(BuildContext context) {
    final String tipsText = _recyclingTips
        .map((tip) => "*${tip.title}*\n${tip.description}\n")
        .join("\n");
    Share.shareXFiles(
      [
        XFile.fromData(
          Uint8List.fromList(tipsText.codeUnits),
          name: 'recycling_tips.txt',
          mimeType: 'text/plain',
        ),
      ],
      text: "¡Hola! Aquí te comparto unos consejos de reciclaje de EcoTrack:\n\n$tipsText",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.recycling),
            const SizedBox(width: 10),
            Text(
              'EcoTrack',
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareTips(context),
            tooltip: 'Compartir consejos',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Consejos de Reciclaje',
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ..._recyclingTips.map((tip) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(tip.icon, size: 40, color: Colors.green),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip.title,
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  tip.description,
                                  style: GoogleFonts.lato(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Inicio'),
            ),
          ),
        ],
      ),
    );
  }
}
