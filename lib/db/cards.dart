import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CardService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Cartes';


  Future<List<DocumentSnapshot>> getCards() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

  void deleteCard(String id){
    _firestore.collection(ref).where("id", isEqualTo: id).getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }

}