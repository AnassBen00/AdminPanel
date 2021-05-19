import 'package:cloud_firestore/cloud_firestore.dart';

class brands{

  String nom;

  brands();

  brands.fromMap(Map<String, dynamic> data) {
    nom = data['nom'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
    };
  }
}