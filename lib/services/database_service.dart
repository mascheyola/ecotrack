
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
    if (uid == null) {
      throw Exception("User is not logged in");
    }

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final userRef = userCollection.doc(uid);
      final recyclingRef = recyclingCollection.doc(); // Create a new document reference

      // Get the user's current data
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) {
        throw Exception("User document does not exist!");
      }

      final currentData = userSnapshot.data() as Map<String, dynamic>;
      final currentPoints = (currentData['points'] as num?)?.toInt() ?? 0;
      final currentWeight = (currentData['weight'] as num?)?.toDouble() ?? 0.0;

      // Calculate new totals
      final pointsFromSubmission = (weight * 10).toInt();
      final newTotalPoints = currentPoints + pointsFromSubmission;
      final newTotalWeight = currentWeight + weight;

      // 1. Add new recycling record
      transaction.set(recyclingRef, {
        'userId': uid,
        'material': material,
        'weight': weight,
        'location': location,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Update user's total points and weight
      transaction.update(userRef, {
        'points': newTotalPoints,
        'weight': newTotalWeight,
      });
    });
  }
}
