import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Estadísticas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recycling')
            .where('userId', isEqualTo: currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay datos de reciclaje.'));
          }

          double totalWeight = 0;
          snapshot.data!.docs.forEach((doc) {
            totalWeight += (doc['weight'] as num).toDouble();
          });

          int totalPoints = (totalWeight * 10).toInt();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Peso Total Reciclado: ${totalWeight.toStringAsFixed(2)} kg', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text('Puntos de Recompensa: $totalPoints', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                const Text('Historial de Reciclaje:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(doc['material']),
                        subtitle: Text('${doc['weight']} kg - ${doc['location']}'),
                        trailing: Text((doc['timestamp'] as Timestamp).toDate().toString()),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
