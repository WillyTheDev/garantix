import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:garantix_flutter/Models/User.dart';

class UserProvider extends ChangeNotifier {
  User user;

  loadUser() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    final doc = await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
    final savedDoc = await Firestore.instance
        .collection("users/${firebaseUser.uid}/savedDocs")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    user = User.fromJson(doc.data, savedDoc);

    notifyListeners();
    return null;
  }

  refetchUserdata() async {
    final doc =
        await Firestore.instance.collection("users").document(user.uid).get();
    final savedDoc = await Firestore.instance
        .collection("users/${user.uid}/savedDocs")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    user = User.fromJson(doc.data, savedDoc);
    notifyListeners();
  }
}
