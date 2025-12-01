
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecyclingRegistrationScreen extends StatefulWidget {
  const RecyclingRegistrationScreen({super.key});

  @override
  State<RecyclingRegistrationScreen> createState() =>
      _RecyclingRegistrationScreenState();
}

class _RecyclingRegistrationScreenState
    extends State<RecyclingRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  String? _selectedMaterial;
  String? _selectedLocation;

  final List<String> _materials = [
    'Plástico',
    'Papel/cartón',
    'Metal',
    'Vidrio',
    'Tela',
    'Tetra brik'
  ];
  final List<String> _locations = ['Casa', 'Trabajo', 'Punto de reciclaje'];

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && currentUser != null) {
      final weight = double.tryParse(_weightController.text);
      if (weight == null || weight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingrese un peso válido.')),
        );
        return;
      }

      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
        final recyclingRef = FirebaseFirestore.instance.collection('recycling').doc();

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userSnapshot = await transaction.get(userRef);

          if (!userSnapshot.exists) {
            throw Exception("User document does not exist!");
          }

          final currentData = userSnapshot.data() as Map<String, dynamic>;
          final currentPoints = (currentData['points'] as num?)?.toInt() ?? 0;
          final currentWeight = (currentData['weight'] as num?)?.toDouble() ?? 0.0;
          
          final pointsFromSubmission = (weight * 10).toInt();
          final newTotalPoints = currentPoints + pointsFromSubmission;
          final newTotalWeight = currentWeight + weight;

          // 1. Add new recycling record
          transaction.set(recyclingRef, {
            'userId': currentUser!.uid,
            'material': _selectedMaterial,
            'weight': weight,
            'location': _selectedLocation,
            'timestamp': FieldValue.serverTimestamp(),
          });

          // 2. Update user's total points and weight
          transaction.update(userRef, {
            'points': newTotalPoints,
            'weight': newTotalWeight,
          });
        });

        // Hide loading indicator
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Material registrado con éxito. ¡Has ganado puntos!')),
        );

        // Clear the form
        _formKey.currentState!.reset();
        _weightController.clear();
        setState(() {
          _selectedMaterial = null;
          _selectedLocation = null;
        });

      } catch (e) {
        // Hide loading indicator
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Material'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMaterial,
                decoration: const InputDecoration(
                  labelText: 'Material',
                  border: OutlineInputBorder(),
                ),
                items: _materials.map((material) {
                  return DropdownMenuItem(
                    value: material,
                    child: Text(material),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMaterial = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Por favor, seleccione un material' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el peso';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Por favor, ingrese un número positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(),
                ),
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Por favor, seleccione una ubicación' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
