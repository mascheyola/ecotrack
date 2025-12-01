
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

  User? get currentUser => FirebaseAuth.instance.currentUser;

  final List<String> _materials = [
    'Plástico',
    'Papel/cartón',
    'Metal',
    'Vidrio',
    'Tela',
    'Tetra brik'
  ];

  final List<String> _locations = [
    'Casco urbano',
    'Abasto',
    'City Bell',
    'Etcheverry',
    'Gonnet',
    'Gorina',
    'Hernández',
    'La Hermosura',
    'Olmos',
    'Romero',
    'San Lorenzo',
    'Sicardi',
    'Tolosa',
    'Villa Castells',
    'Villa Elisa',
    'Villa Elvira'
  ];

  String? _selectedMaterial;
  String? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Material Reciclado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedMaterial,
                decoration: const InputDecoration(labelText: 'Material'),
                items: _materials.map((String material) {
                  return DropdownMenuItem<String>(
                    value: material,
                    child: Text(material),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMaterial = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona un material';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el peso';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: const InputDecoration(labelText: 'Lugar de Reciclaje'),
                items: _locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona un lugar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final weight = double.parse(_weightController.text);

                    if (currentUser != null) {
                      FirebaseFirestore.instance.collection('recycling').add({
                        'userId': currentUser!.uid,
                        'material': _selectedMaterial,
                        'weight': weight,
                        'location': _selectedLocation,
                        'timestamp': FieldValue.serverTimestamp(),
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Material registrado con éxito')),
                        );
                        // Clear the form
                        _formKey.currentState!.reset();
                        _weightController.clear();
                        setState(() {
                          _selectedMaterial = null;
                          _selectedLocation = null;
                        });
                      });
                    }
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
