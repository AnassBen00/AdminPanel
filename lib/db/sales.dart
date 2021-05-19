import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SaleService {
  Firestore _firestore = Firestore.instance;
  String ref = 'achats';


  Future<List<DocumentSnapshot>> getSale() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });


  void updateSale({String id, String uid, String nomP, String date, int montant, String color, int quantity}){
    _firestore.collection(ref).document(id).updateData({
      "IdUtilisateur": uid,
      "NomProduit": nomP,
      "couleur": color,
      "date": date.toString(),
      "montant": montant,
      "quantité": quantity,
    });
  }

  void deleteSale(String id){
    _firestore.collection(ref).where("id", isEqualTo: id).getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('category', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });

}