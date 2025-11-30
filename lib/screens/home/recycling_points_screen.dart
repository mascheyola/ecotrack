import 'package:flutter/material.dart';

class RecyclingPointsScreen extends StatelessWidget {
  const RecyclingPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de Reciclaje'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán los puntos de reciclaje cercanos.'),
      ),
    );
  }
}
