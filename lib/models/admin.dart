import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel{
  static const NAME = 'name';
  static const EMAIL = "email";
  static const ID = 'uid';
  static const TYPE = 'type';

  String _name;
  String _email;
  String _id;
  String _type;

//  GETTERS
  String get name => _name;
  String get email => _email;
  String get uid => _id;
  String get type => _type;


  AdminModel.fromMap(Map<String, dynamic> data) {
    _id = data['uid'];
    _name = data['name'];
    _email = data['email'];
    _type = data['type'];
  }


  AdminModel.fromSnapshot(DocumentSnapshot snap){
    _email = snap.data[EMAIL];
    _name = snap.data[NAME];
    _id = snap.data[ID];
    _type = snap.data[TYPE];
  }
}


