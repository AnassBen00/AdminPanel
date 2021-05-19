import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Produits';

  void uploadProduct(Map<String, dynamic> data) {
    var id = Uuid();
    String productId = id.v1();
    data["id"] = productId;
    _firestore.collection(ref).document(productId).setData(data);
  }

  void updateProduct(Map<String, dynamic> data, String productId) {

    _firestore.collection(ref).document(productId).updateData(data);
  }

  Future<List<DocumentSnapshot>> getProduct() => _firestore.collection(ref).getDocuments().then((snaps){
    print(snaps.documents.length);
    return snaps.documents;
  });


  void deleteProduct(String id){
    _firestore.collection(ref).where("id", isEqualTo: id).getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }

  int getNProd(){
    _firestore.collection(ref).getDocuments().then((snapshot){
      int n = snapshot.documents.length;
      print(n);
      return n;
    });

  }
}