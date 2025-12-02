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

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'user-disabled':
        return 'Este usuario ha sido deshabilitado.';
      case 'user-not-found':
        return 'No se encontró un usuario con este correo electrónico.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está en uso por otra cuenta.';
      case 'operation-not-allowed':
        return 'El inicio de sesión con correo electrónico y contraseña no está habilitado.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      default:
        return 'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.';
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return 'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.';
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
        return 'No se pudo crear el usuario. Por favor, inténtalo de nuevo.';
      }
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return 'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.';
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
