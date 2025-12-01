
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedFilter = 'Todo';

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Estadísticas'),
        actions: [
          _buildFilterButton(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getFilteredStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay datos para el período seleccionado.'));
          }

          Map<String, double> materialData = {};
          double totalWeight = 0;

          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final material = data['material'] as String;
            final weight = (data['weight'] as num).toDouble();

            materialData.update(material, (value) => value + weight, ifAbsent: () => weight);
            totalWeight += weight;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildChart(materialData),
                const SizedBox(height: 24),
                _buildSummary(totalWeight),
                const SizedBox(height: 24),
                _buildHistory(snapshot.data!.docs),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    String message = 'Ocurrió un error inesperado.';
    String? url;

    if (error is FirebaseException && error.message != null) {
      message = 'Error de Firestore: Necesita crear un índice. Por favor, haga clic en el siguiente enlace para crearlo en la consola de Firebase.\n\n${error.message}';
      final urlRegex = RegExp(r'(https?://[^\s]+)');
      final match = urlRegex.firstMatch(error.message!);
      if (match != null) {
        url = match.group(0);
        // Log the URL to the terminal.
        developer.log(' Firestore Index Creation URL: $url', name: 'ecotrack.firestore');
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(message, textAlign: TextAlign.center),
            if (url != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () => _launchURL(url!),
                  child: const Text('Crear Índice'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la URL: $url')),
      );
    }
  }


  Widget _buildFilterButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _selectedFilter = value;
        });
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Semanal', child: Text('Semanal')),
        const PopupMenuItem(value: 'Mensual', child: Text('Mensual')),
        const PopupMenuItem(value: 'Anual', child: Text('Anual')),
        const PopupMenuItem(value: 'Todo', child: Text('Todo')),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text(_selectedFilter, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (_selectedFilter) {
      case 'Semanal':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Mensual':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Anual':
        startDate = DateTime(now.year, 1, 1);
        break;
      default: // Todo
        return FirebaseFirestore.instance
            .collection('recycling')
            .where('userId', isEqualTo: currentUser!.uid)
            .orderBy('timestamp', descending: true)
            .snapshots();
    }

    return FirebaseFirestore.instance
        .collection('recycling')
        .where('userId', isEqualTo: currentUser!.uid)
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Widget _buildChart(Map<String, double> data) {
    List<PieChartSectionData> sections = data.entries.map((entry) {
      final isTouched = entry.key == 'touched'; // Placeholder for interactivity
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: _getColor(entry.key),
        value: entry.value,
        title: '${(entry.value / data.values.reduce((a, b) => a + b) * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Add interactivity logic if needed
          }),
          borderData: FlBorderData(show: false),
          sectionsSpace: 4,
          centerSpaceRadius: 60,
          sections: sections,
        ),
      ),
    );
  }

  Widget _buildSummary(double totalWeight) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total Reciclado: ${totalWeight.toStringAsFixed(2)} kg', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Puntos Ganados: ${(totalWeight * 10).toInt()}', style: const TextStyle(fontSize: 16, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(List<QueryDocumentSnapshot> docs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Historial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var doc = docs[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(_getMaterialIcon(doc['material']), color: _getColor(doc['material'])),
                title: Text(doc['material'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${doc['weight']} kg - ${doc['location']}'),
                trailing: Text((doc['timestamp'] as Timestamp).toDate().toLocaleDateString()),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getColor(String material) {
    switch (material) {
      case 'Plástico':
        return Colors.blue;
      case 'Papel/cartón':
        return Colors.orange;
      case 'Metal':
        return Colors.grey;
      case 'Vidrio':
        return Colors.green;
      case 'Tela':
        return Colors.purple;
      case 'Tetra brik':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  IconData _getMaterialIcon(String material) {
    switch (material) {
      case 'Plástico':
        return Icons.local_drink;
      case 'Papel/cartón':
        return Icons.description;
      case 'Metal':
        return Icons.build;
      case 'Vidrio':
        return Icons.wine_bar;
      case 'Tela':
        return Icons.style;
      case 'Tetra brik':
        return Icons.check_box_outline_blank;
      default:
        return Icons.eco;
    }
  }
}

extension on DateTime {
  String toLocaleDateString() {
    return '$day/$month/$year';
  }
}
