import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecyclingRegistrationScreen extends StatefulWidget {
  const RecyclingRegistrationScreen({super.key});

  @override
  RecyclingRegistrationScreenState createState() =>
      RecyclingRegistrationScreenState();
}

class RecyclingRegistrationScreenState
    extends State<RecyclingRegistrationScreen> {
  String? _selectedMaterial;
  String? _selectedWeight;
  String? _selectedLocation;
  String _message = '';

  final List<String> _materials = [
    'Plástico',
    'Papel o cartón',
    'Metal',
    'Vidrio',
    'Tela',
    'Tetra brick',
  ];
  final List<String> _weights = ['0-1 kg', '1-5 kg', '5-10 kg', '10+ kg'];
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
    'Villa Elvira',
  ];

  void _submitForm() {
    if (_selectedMaterial != null &&
        _selectedWeight != null &&
        _selectedLocation != null) {
      setState(() {
        _message = '¡Registro guardado exitosamente!';
      });
    } else {
      setState(() {
        _message = 'Por favor, completa todos los campos.';
      });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registrar Reciclaje',
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              label: 'Tipo de material',
              value: _selectedMaterial,
              items: _materials,
              onChanged: (value) {
                setState(() {
                  _selectedMaterial = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              label: 'Peso estimado',
              value: _selectedWeight,
              items: _weights,
              onChanged: (value) {
                setState(() {
                  _selectedWeight = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              label: 'Punto de reciclaje',
              value: _selectedLocation,
              items: _locations,
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Guardar registro'),
            ),
            const SizedBox(height: 20),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: GoogleFonts.lato(
                  color: _message.contains('exitosamente')
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
