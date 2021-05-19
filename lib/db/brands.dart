import 'package:adminpaneltechshopp/models/brands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandService {
  Firestore _firestore = Firestore.instance;
  String ref = 'marques';

  void createBrand(String nom){
    _firestore.collection(ref).document().setData({
      "nom": nom,
    });
  }

  void updateBrand(String id, String nom){
    _firestore.collection(ref).document(id).updateData({
      'id': id,
      "nom": nom,
    });
  }

  void deleteBrand(String nom){
    _firestore.collection(ref).where("nom", isEqualTo: nom).getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }

  Future<List<DocumentSnapshot>> getbrand() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('nom', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });

}