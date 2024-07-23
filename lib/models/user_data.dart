import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String email;
  final bool isAdmin;
  final String name;

  UserData({
    required this.uid,
    required this.email,
    required this.name,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'isAdmin': isAdmin,
      'name': name,
    };
  }

  factory UserData.fromFirestore(DocumentSnapshot? doc) {
    if (doc == null || !doc.exists) {
      return UserData(uid: '', email: '', isAdmin: false, name: '');
    }

    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      return UserData(uid: '', email: '', isAdmin: false, name: '');
    }

    return UserData(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      name: data['name'] ?? '',
    );
  }
}
