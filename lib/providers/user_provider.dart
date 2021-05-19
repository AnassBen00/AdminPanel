import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  Firestore _firestore = Firestore.instance;

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> check_Admin(String email) async {
    var query = await Firestore.instance.collection("Admines").where('email', isEqualTo: email);
    query.getDocuments().then((data) {
      if (data.documents.isNotEmpty){
        return true;
      }
      return false;
    });
  }

  Future<bool> signIn(String email, String password) async {
      try {
          _status = Status.Authenticating;
          notifyListeners();
          await _auth.signInWithEmailAndPassword(email: email, password: password);
          return true;
      } catch (e) {
        _status = Status.Unauthenticated;
        notifyListeners();
        print(e.toString());
        return false;
      }
  }


  Future<bool> signUpAdmin(String name,String email, String password)async{
    try{
      print(password);
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user){
        _firestore.collection('Admines').document(user.uid).setData({
          'name':name,
          'email':email,
          'uid':user.uid,
          "type": "admin"
        });
        user.sendEmailVerification();
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUpUser(String name,String email, String password)async{
    try{
      print(password);
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user){
        _firestore.collection('Utilisateurs').document(user.uid).setData({
          'name':name,
          'email':email,
          'uid':user.uid,
        });
        user.sendEmailVerification();
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _status = Status.Authenticated;
  }
    notifyListeners();
}
}