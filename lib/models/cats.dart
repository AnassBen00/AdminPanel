import 'package:cloud_firestore/cloud_firestore.dart';

class categories{

  String nom;

  categories();

  categories.fromMap(Map<String, dynamic> data) {
    nom = data['nom'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
    };
  }
}