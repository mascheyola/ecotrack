
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecotrack/screens/home/recycling_registration_screen.dart';
import 'package:ecotrack/screens/home/statistics_screen.dart';
import 'package:ecotrack/screens/tips_screen.dart';
import 'package:ecotrack/screens/home/recycling_points_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _userName;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RecyclingRegistrationScreen(),
    const StatisticsScreen(),
    const TipsScreen(),
    const RecyclingPointsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.data()!['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pass the user name to the DashboardScreen
    final List<Widget> screens = [
      DashboardScreen(userName: _userName),
      const RecyclingRegistrationScreen(),
      const StatisticsScreen(),
      const TipsScreen(),
      const RecyclingPointsScreen(),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Registrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Consejos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Puntos',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final String? userName;
  const DashboardScreen({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${userName ?? ''}',
              style: TextStyle(fontSize: 28, color: Colors.grey.shade800),
            ),
            Text(
              '¿Qué te gustaría hacer hoy?',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    'Registrar Reciclaje',
                    Icons.app_registration,
                    Colors.orange,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RecyclingRegistrationScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    'Mis Estadísticas',
                    Icons.bar_chart,
                    Colors.blue,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StatisticsScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    'Puntos de Reciclaje',
                    Icons.location_on,
                    Colors.red,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RecyclingPointsScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    'Consejos de Reciclaje',
                    Icons.lightbulb_outline,
                    Colors.purple,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TipsScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
