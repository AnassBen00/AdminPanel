import 'package:adminpaneltechshopp/utils/passwordGenerator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class UserService{
  Firestore _firestore = Firestore.instance;
  String ref = 'Utilisateurs';

  String password(){
    return generatePassword(true, true, true, false, 8);
  }

  void createUser({String name, String email}){

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password()).then((user){
      _firestore.collection('Utilisateurs').document(user.uid).setData({
        'name':name,
        'email':email,
        'uid':user.uid
      });
      user.sendEmailVerification();
    });
  }

  Future<List<DocumentSnapshot>> getUser() => _firestore.collection(ref).getDocuments().then((snaps){
      print(snaps.documents.length);
      return snaps.documents;
    });

  void updateUser({String name, String email, String uid}){
    _firestore.collection(ref).document(uid).updateData({
      'name': name,
      "email": email,
    });
  }

  void deleteUser(String uid){
    _firestore.collection(ref).where("uid", isEqualTo: uid).getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }


}