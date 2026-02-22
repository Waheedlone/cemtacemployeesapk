import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserFace(String username, String? password, List<double> embeddings) async {
    final Map<String, dynamic> data = {
      'username': username,
      'embeddings': embeddings,
      'registered_at': FieldValue.serverTimestamp(),
    };
    if (password != null) {
      data['password'] = password;
    }
    await _db.collection('users_face').doc(username).set(data, SetOptions(merge: true));
  }

  Future<void> saveCredentials(String username, String password) async {
    await _db.collection('users_face').doc(username).set({
      'username': username,
      'password': password,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserFace(String username) async {
    try {
      print("DEBUG: Firestore: Fetching face for $username");
      DocumentSnapshot doc = await _db.collection('users_face').doc(username).get();
      if (doc.exists) {
        print("DEBUG: Firestore: Document found");
        return doc.data() as Map<String, dynamic>?;
      }
      print("DEBUG: Firestore: Document NOT found");
      return null;
    } catch (e) {
      print("DEBUG: Firestore Error: $e");
      rethrow;
    }
  }

  Future<bool> hasRegisteredFace(String username) async {
    try {
      DocumentSnapshot doc = await _db.collection('users_face').doc(username).get();
      return doc.exists && (doc.data() as Map<String, dynamic>?)?.containsKey('embeddings') == true;
    } catch (e) {
      print("DEBUG: Firestore Error in hasRegisteredFace: $e");
      return false;
    }
  }
}
