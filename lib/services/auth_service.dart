import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 LOGIN
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 📝 REGISTER
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
