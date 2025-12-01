
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
    RecyclingPoint(
      name: 'Punto Verde Plaza Alsina',
      latitude: -34.9188,
      longitude: -57.9515,
    ),
    RecyclingPoint(
      name: 'Punto Verde Parque Saavedra',
      latitude: -34.8986,
      longitude: -57.9712,
    ),
    RecyclingPoint(
      name: 'Punto Verde Plaza San Martín',
      latitude: -34.9213,
      longitude: -57.9545,
    ),
    // Add more points as needed
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
