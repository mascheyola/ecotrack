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
      // 2. Update AppBar for consistency
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. Move title to body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Text(
              'Puntos de Reciclaje',
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  -34.9214,
                  -57.9544,
                ), // Centered on La Plata
                initialZoom: 13.0,
              ),
              children: [
                // 4. Add userAgentPackageName to comply with OSM policy
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.myapp',
                ),
                MarkerLayer(
                  markers: recyclingPoints.map((point) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(point.latitude, point.longitude),
                      // 3. Use 'child' instead of deprecated 'builder'
                      child: Column(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 40,
                          ),
                          Expanded(
                            child: Text(
                              point.name,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Inicio'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
