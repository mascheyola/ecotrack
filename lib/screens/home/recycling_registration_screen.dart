
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecotrack/services/database_service.dart';
import 'package:google_fonts/google_fonts.dart';

class RecyclingRegistrationScreen extends StatefulWidget {
  const RecyclingRegistrationScreen({super.key});

  @override
  State<RecyclingRegistrationScreen> createState() => _RecyclingRegistrationScreenState();
}

class _RecyclingRegistrationScreenState extends State<RecyclingRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMaterial;
  String? _selectedLocation;
  final _weightController = TextEditingController();

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

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  // --- The Fix: Reset form after submission --- //
  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _selectedMaterial = null;
      _selectedLocation = null;
      _weightController.clear();
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no autenticado.')),
        );
        return;
      }

      final material = _selectedMaterial!;
      final weight = double.parse(_weightController.text);
      final location = _selectedLocation!;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await DatabaseService(uid: user.uid).addRecyclingRecord(material, weight, location);

        Navigator.pop(context); // Hide loading indicator

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Registro añadido con éxito!',
              textAlign: TextAlign.center,
            ),
          ),
        );
        
        // --- The Fix: Don't pop, just reset the form --- //
        _resetForm(); 

      } catch (e) {
        Navigator.pop(context); // Hide loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir el registro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Material Reciclado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Completa los detalles de tu reciclaje',
                  style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),

                DropdownButtonFormField<String>(
                  value: _selectedMaterial,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Material',
                    border: OutlineInputBorder(),
                  ),
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
                  validator: (value) => value == null ? 'Por favor, selecciona un material' : null,
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    border: OutlineInputBorder(),
                    suffixText: 'kg',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce el peso';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Por favor, introduce un peso válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  decoration: const InputDecoration(
                    labelText: 'Lugar de Reciclaje',
                    border: OutlineInputBorder(),
                  ),
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
                  validator: (value) => value == null ? 'Por favor, selecciona un lugar' : null,
                ),
                const SizedBox(height: 32.0),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: GoogleFonts.lato(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  child: const Text('Añadir Registro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
