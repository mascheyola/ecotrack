
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrack/firebase_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Authenticated user can write to and read from Firestore', () async {
    // 1. Sign in an anonymous user
    final auth = FirebaseAuth.instance;
    await auth.signInAnonymously();
    final user = auth.currentUser;
    expect(user, isNotNull);

    // 2. Get a reference to Firestore
    final firestore = FirebaseFirestore.instance;

    // 3. Write data to a test collection
    final testDocRef = firestore.collection('testCollection').doc('testDoc');
    final testData = {'message': 'Hello, Firestore!'};
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
