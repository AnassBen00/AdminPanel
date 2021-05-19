import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'categories';

  void createCat(String nom){
    _firestore.collection(ref).document().setData({
      "nom": nom,
    });
  }

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

  void updateCat(String id, String idc, String nom){
    _firestore.collection(ref).document(id).updateData({
      'IdCarte': id,
      "nom": nom,
    });
  }

  void deleteCat(String nom){
    _firestore.collection(ref).where("nom", isEqualTo: nom).getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }


  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('nom', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });

}