
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

// 1. Create a dedicated data class for type safety
class RecyclingPoint {
  final String name;
  final double latitude;
  final double longitude;

  const RecyclingPoint({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class RecyclingPointsScreen extends StatelessWidget {
  const RecyclingPointsScreen({super.key});

  // Use the new data class
  final List<RecyclingPoint> recyclingPoints = const [
    RecyclingPoint(name: 'Casco urbano: 12 y 53', latitude: -34.9210, longitude: -57.9545),
    RecyclingPoint(name: 'Sicardi: 10 y 662', latitude: -35.0075, longitude: -57.9409),
    RecyclingPoint(name: 'La Hermosura: 131 y 641', latitude: -34.9978, longitude: -57.8863),
    RecyclingPoint(name: 'Villa Elvira: 7 y 90', latitude: -34.9547, longitude: -57.9204),
    RecyclingPoint(name: 'San Lorenzo: 72 y 28', latitude: -34.9398, longitude: -57.9839),
    RecyclingPoint(name: 'Abasto: 210 y 516 bis', latitude: -34.9554, longitude: -58.1122),
    RecyclingPoint(name: 'Romero: 521 y 171', latitude: -34.9453, longitude: -58.0795),
    RecyclingPoint(name: 'Tolosa: 115 y 530', latitude: -34.898, longitude: -57.985),
    RecyclingPoint(name: 'Gonnet: 15 bis y 495', latitude: -34.8726, longitude: -58.0195),
    RecyclingPoint(name: 'Villa Castells: 13 y 493', latitude: -34.8824, longitude: -58.0125),
    RecyclingPoint(name: 'City Bell: Cantilo y 14b', latitude: -34.8726, longitude: -58.0553),
    RecyclingPoint(name: 'Villa Elisa: Camino Centenario y 49', latitude: -34.8569, longitude: -58.0822),
    RecyclingPoint(name: 'Hernández: 510 y 29', latitude: -34.8932, longitude: -58.0496),
    RecyclingPoint(name: 'Gorina: 140 bis y 489', latitude: -34.8698, longitude: -58.0019),
    RecyclingPoint(name: 'Olmos: 171 y 46', latitude: -34.9723, longitude: -58.0469),
    RecyclingPoint(name: 'Etcheverry: 52 y 235', latitude: -34.948, longitude: -58.1583),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Puntos de Reciclaje',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(recyclingPoints[0].latitude, recyclingPoints[0].longitude),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.ecotrack', // Comply with OSM policy
          ),
          MarkerLayer(
            markers: recyclingPoints.map((point) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(point.latitude, point.longitude),
                child: Tooltip(
                  message: point.name,
                  child: const Icon(
                    Icons.recycling,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
