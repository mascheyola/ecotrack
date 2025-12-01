
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  test('Mock user can write to and read from mock Firestore', () async {
    // 1. Create a mock user
    final auth = MockFirebaseAuth(signedIn: true);
    final user = auth.currentUser;
    expect(user, isNotNull);

    // 2. Create a mock Firestore instance
    final firestore = FakeFirebaseFirestore();

    // 3. Write data to a test collection
    final testDocRef = firestore.collection('testCollection').doc('testDoc');
    final testData = {'message': 'Hello, mock Firestore!'};
    await testDocRef.set(testData);

    // 4. Read the data back
    final snapshot = await testDocRef.get();
    final readData = snapshot.data();

    // 5. Assert that the data matches
    expect(readData, isNotNull);
    expect(readData!['message'], testData['message']);

    // 6. Clean up the test data
    await testDocRef.delete();
  });
}
