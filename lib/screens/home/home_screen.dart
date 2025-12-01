
import 'package:ecotrack/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotrack/screens/home/recycling_registration_screen.dart';
import 'package:ecotrack/screens/home/statistics_screen.dart';
import 'package:ecotrack/screens/home/recycling_tips_screen.dart';
import 'package:ecotrack/screens/home/recycling_points_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService _auth = AuthService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> _getUserData() async {
    return FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos.'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No se encontraron datos de usuario.'));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'Usuario';

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      Text(
                        'Hola, $userName',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '¿Qué te gustaría hacer hoy?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0, 
                    children: <Widget>[
                      _MenuButton(
                        icon: Icons.recycling,
                        label: 'Registrar\nMaterial',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RecyclingRegistrationScreen()),
                          );
                        },
                      ),
                      _MenuButton(
                        icon: Icons.bar_chart,
                        label: 'Mis\nEstadísticas',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                          );
                        },
                      ),
                       _MenuButton(
                        icon: Icons.location_on_outlined,
                        label: 'Puntos de\nReciclaje',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RecyclingPointsScreen()),
                          );
                        },
                      ),
                      _MenuButton(
                        icon: Icons.lightbulb_outline,
                        label: 'Consejos de\nReciclaje',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RecyclingTipsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? buttonStyle = Theme.of(context).elevatedButtonTheme.style;
    // Resolving for default state
    final Color? backgroundColor = buttonStyle?.backgroundColor?.resolve({});
    final Color? foregroundColor = buttonStyle?.foregroundColor?.resolve({});

    return Card(
      color: backgroundColor,
      elevation: 5.0,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 48, color: foregroundColor),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
