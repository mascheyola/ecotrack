import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecyclingRegistrationScreen extends StatefulWidget {
  const RecyclingRegistrationScreen({super.key});

  @override
  State<RecyclingRegistrationScreen> createState() => _RecyclingRegistrationScreenState();
}

class _RecyclingRegistrationScreenState extends State<RecyclingRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _materialController = TextEditingController();
  final _weightController = TextEditingController();
  final _locationController = TextEditingController();

  User? get currentUser => FirebaseAuth.instance.currentUser;

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
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(labelText: 'Material'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el material';
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
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Lugar de Reciclaje'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el lugar de reciclaje';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final material = _materialController.text;
                    final weight = double.parse(_weightController.text);
                    final location = _locationController.text;

                    if (currentUser != null) {
                      FirebaseFirestore.instance.collection('recycling').add({
                        'userId': currentUser!.uid,
                        'material': material,
                        'weight': weight,
                        'location': location,
                        'timestamp': FieldValue.serverTimestamp(),
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Material registrado con éxito')),
                        );
                        Navigator.pop(context);
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
