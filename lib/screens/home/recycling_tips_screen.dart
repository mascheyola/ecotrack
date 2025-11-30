import 'package:flutter/material.dart';

class RecyclingTipsScreen extends StatelessWidget {
  const RecyclingTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tips = [
      'Separa los residuos orgánicos de los inorgánicos.',
      'Limpia los envases antes de reciclarlos.',
      'Asegúrate de que el papel y el cartón estén secos.',
      'No todos los plásticos son reciclables, verifica los símbolos.',
      'Reutiliza las bolsas de plástico o lleva tus propias bolsas de tela.',
      'Las baterías y los aparatos electrónicos deben reciclarse en puntos específicos.',
      'El aceite de cocina usado no debe verterse por el desagüe. Llévalo a un punto de recogida.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consejos de Reciclaje'),
      ),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: Text(tips[index]),
            ),
          );
        },
      ),
    );
  }
}
