import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  static const NAME = 'name';
  static const EMAIL = "email";
  static const ID = 'uid';
  static const STRIPE_ID = 'stripeId';
  static const ACTIVE_CARD = 'activeCard';


  String _name;
  String _email;
  String _id;
  String _stripeId;
  String _activeCard;
//  GETTERS
  String get name => _name;
  String get email => _email;
  String get uid => _id;
  String get stripeId => _stripeId;
  String get activeCard => _activeCard;


  UserModel.fromMap(Map<String, dynamic> data) {
    _id = data['uid'];
    _name = data['name'];
    _email = data['email'];
    _stripeId = data['stripeId'];
    _activeCard = data['activeCard'];
  }


  UserModel.fromSnapshot(DocumentSnapshot snap){
    _email = snap.data[EMAIL];
    _name = snap.data[NAME];
    _id = snap.data[ID];
    _stripeId = snap[STRIPE_ID] ?? null;
    _activeCard = snap[ACTIVE_CARD] ?? null;

  }
}


