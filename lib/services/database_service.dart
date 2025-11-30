import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference recyclingCollection = FirebaseFirestore.instance.collection('recycling');

  Future<void> updateUserData(String name, int points, double weight) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'points': points,
      'weight': weight,
    });
  }

  Future<void> addRecyclingRecord(String material, double weight, String location) async {
    await recyclingCollection.add({
      'userId': uid,
      'material': material,
      'weight': weight,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
