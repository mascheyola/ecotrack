import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecyclingPoint {
  final String id;
  final String name;
  final String address;
  final String hours;
  final List<String> materials;
  final LatLng position;

  RecyclingPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.hours,
    required this.materials,
    required this.position,
  });
}

class RecyclingPointsScreen extends StatefulWidget {
  const RecyclingPointsScreen({super.key});

  @override
  State<RecyclingPointsScreen> createState() => _RecyclingPointsScreenState();
}

class _RecyclingPointsScreenState extends State<RecyclingPointsScreen> {
  late GoogleMapController _mapController;
  RecyclingPoint? _selectedPoint;
  final TextEditingController _searchController = TextEditingController();

  final LatLng _initialCenter = const LatLng(-34.9213, -57.9545); // La Plata

  final List<RecyclingPoint> _recyclingPoints = [
    RecyclingPoint(
      id: '1',
      name: 'Cooperativa de Reciclaje La Plata',
      address: 'Calle 526 y 25, La Plata',
      hours: 'Lunes a Viernes: 8:00 - 16:00',
      materials: ['Papel', 'Cartón', 'Plástico', 'Vidrio'],
      position: const LatLng(-34.908, -57.99),
    ),
    RecyclingPoint(
      id: '2',
      name: 'Punto Verde City Bell',
      address: 'Cantilo y Cno. Centenario, City Bell',
      hours: 'Sábados: 9:00 - 13:00',
      materials: ['Plástico', 'Latas'],
      position: const LatLng(-34.87, -58.05),
    ),
    RecyclingPoint(
      id: '3',
      name: 'Centro de Acopio Gonnet',
      address: 'Calle 501 y 133, Gonnet',
      hours: 'Lunes a Sábados: 9:00 - 17:00',
      materials: ['Todos los materiales reciclables'],
      position: const LatLng(-34.88, -58.02),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMarkerTapped(RecyclingPoint point) {
    setState(() {
      _selectedPoint = point;
    });
  }

  Set<Marker> _createMarkers() {
    return _recyclingPoints
        .map(
          (point) => Marker(
            markerId: MarkerId(point.id),
            position: point.position,
            infoWindow: InfoWindow(title: point.name),
            onTap: () => _onMarkerTapped(point),
          ),
        )
        .toSet();
  }

  void _searchAndNavigate() {
    final searchTerm = _searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      return;
    }

    RecyclingPoint? foundPoint;
    for (final point in _recyclingPoints) {
      if (point.name.toLowerCase().contains(searchTerm)) {
        foundPoint = point;
        break;
      }
    }

    if (foundPoint != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(foundPoint.position, 15.0),
      );
      setState(() {
        _selectedPoint = foundPoint;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Punto de reciclaje no encontrado.')),
      );
    }
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchAndNavigate,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onSubmitted: (_) => _searchAndNavigate(),
            ),
          ),
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _initialCenter,
                zoom: 12.0,
              ),
              markers: _createMarkers(),
              onTap: (_) {
                setState(() {
                  _selectedPoint = null;
                });
              },
            ),
          ),
          _selectedPoint == null
              ? Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Selecciona un punto de reciclaje o busca uno.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  flex: 2,
                  child: _buildPointDetails(_selectedPoint!),
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

  Widget _buildPointDetails(RecyclingPoint point) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                point.name,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Dirección: ${point.address}'),
              const SizedBox(height: 5),
              Text('Horario: ${point.hours}'),
              const SizedBox(height: 10),
              const Text(
                'Materiales Aceptados:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: point.materials
                    .map((material) => Chip(label: Text(material)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
