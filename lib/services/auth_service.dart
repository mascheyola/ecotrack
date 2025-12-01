import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrack/models/user.dart';
import 'package:ecotrack/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        // create a new document for the user with the uid
        await DatabaseService(uid: user.uid).updateUserData(name, 0, 0);
        return _userFromFirebaseUser(user);
      } else {
        return 'Could not create user. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
