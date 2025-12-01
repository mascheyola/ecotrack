
import 'package:ecotrack/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ecotrack/screens/home/recycling_registration_screen.dart';
import 'package:ecotrack/screens/home/statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoTrack'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecyclingRegistrationScreen()),
                );
              },
              child: const Text('Registrar Material Reciclado'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                );
              },
              child: const Text('Ver Mis Estadísticas'),
            ),
          ],
        ),
      ),
    );
  }
}
