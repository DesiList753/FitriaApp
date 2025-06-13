import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error signing in: $e");
      rethrow;
    }
  }

  // Registrar con email y contraseña
  Future<UserCredential> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Crear un nuevo documento para el usuario con el uid
      await _firestore.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return result;
    } catch (e) {
      print("Error registering user: $e");
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }

  // Obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Verificar si el usuario está autenticado
  bool isUserAuthenticated() {
    return _auth.currentUser != null;
  }
  
  // Obtener los datos del usuario actual desde Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      if (_auth.currentUser != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
            
        return doc.exists ? doc.data() as Map<String, dynamic> : null;
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}
