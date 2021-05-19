import 'package:adminpaneltechshopp/models/admin.dart';
import 'package:adminpaneltechshopp/models/brands.dart';
import 'package:adminpaneltechshopp/models/cards.dart';
import 'package:adminpaneltechshopp/models/cats.dart';
import 'package:adminpaneltechshopp/models/products.dart';
import 'package:adminpaneltechshopp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adminpaneltechshopp/models/purchase.dart';
import 'package:adminpaneltechshopp/providers/app_provider.dart';


getProducts(AppProvider appProvider) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('Produits').getDocuments();

  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });

  appProvider.Products = _Products;
}

getUsers(AppProvider appProvider) async {
  QuerySnapshot snapshot =
  await Firestore.instance.collection('Utilisateurs').getDocuments();

  List<UserModel> _Users = [];

  snapshot.documents.forEach((document) {
    UserModel user = UserModel.fromMap(document.data);
    _Users.add(user);
  });

  appProvider.Users = _Users;
}

getAdmins(AppProvider appProvider) async {
  QuerySnapshot snapshot =
  await Firestore.instance.collection('Admines').getDocuments();

  List<AdminModel> _Admins = [];

  snapshot.documents.forEach((document) {
    AdminModel admin = AdminModel.fromMap(document.data);
    _Admins.add(admin);
  });

  appProvider.Admins = _Admins;
}

getBrands(AppProvider appProvider) async {
  QuerySnapshot snapshot =
  await Firestore.instance.collection('marques').getDocuments();

  List<brands> _Brands = [];

  snapshot.documents.forEach((document) {
    brands brand = brands.fromMap(document.data);
    _Brands.add(brand);
  });

  appProvider.Brands = _Brands;
}

getCats(AppProvider appProvider) async {
  QuerySnapshot snapshot =
  await Firestore.instance.collection('categories').getDocuments();

  List<categories> _Cats = [];

  snapshot.documents.forEach((document) {
    categories cat = categories.fromMap(document.data);
    _Cats.add(cat);
  });

  appProvider.Cats = _Cats;
}

loadPurchases(AppProvider appProvider) async {
  Firestore.instance.collection('achats').getDocuments().then((result){
    List<PurchaseModel> purchaseHistory = [];
    for(DocumentSnapshot item in result.documents){
      purchaseHistory.add(PurchaseModel.fromSnapshot(item));
    }
    appProvider.Purchases = purchaseHistory;
    //print(_Cards.length);
  });
}

loadCards(AppProvider appProvider) async {
  Firestore.instance.collection('Cartes').getDocuments().then((result){
    List<CardModel> _Cards = [];
    for(DocumentSnapshot item in result.documents){
      _Cards.add(CardModel.fromSnapshot(item));
    }
    appProvider.Cards = _Cards;
    //print(_Cards.length);
  });
}





