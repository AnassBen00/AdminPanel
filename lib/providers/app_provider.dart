import 'dart:collection';
import 'package:adminpaneltechshopp/models/admin.dart';
import 'package:adminpaneltechshopp/models/brands.dart';
import 'package:adminpaneltechshopp/models/buyedProds.dart';
import 'package:adminpaneltechshopp/models/cards.dart';
import 'package:adminpaneltechshopp/models/cats.dart';
import 'package:adminpaneltechshopp/models/products.dart';
import 'package:adminpaneltechshopp/models/purchase.dart';
import 'package:adminpaneltechshopp/models/user.dart';
import 'package:flutter/material.dart';


class AppProvider with ChangeNotifier {
  List<products> _Products = [];
  List<PurchaseModel> _Purchases = [];
  List<CardModel> _Cards = [];
  List<UserModel> _Users = [];
  List<brands> _Brands = [];
  List<categories> _Cats = [];
  List<AdminModel> _Admins = [];

  UnmodifiableListView<products> get Products => UnmodifiableListView(_Products);
  UnmodifiableListView<PurchaseModel> get Purchases => UnmodifiableListView(_Purchases);
  UnmodifiableListView<CardModel> get Cards => UnmodifiableListView(_Cards);
  UnmodifiableListView<UserModel> get Users => UnmodifiableListView(_Users);
  UnmodifiableListView<brands> get Brands => UnmodifiableListView(_Brands);
  UnmodifiableListView<categories> get Cats => UnmodifiableListView(_Cats);
  UnmodifiableListView<AdminModel> get Admins => UnmodifiableListView(_Admins);

  set Products(List<products> Products) {
    _Products = Products;
    notifyListeners();
  }

  set Brands(List<brands> Brands) {
    _Brands = Brands;
    notifyListeners();
  }

  set Cats(List<categories> Cats) {
    _Cats = Cats;
    notifyListeners();
  }

  set Users(List<UserModel> Users) {
    _Users = Users;
    notifyListeners();
  }

  set Admins(List<AdminModel> Admins) {
    _Admins = Admins;
    notifyListeners();
  }

  set Cards(List<CardModel> Cards) {
    _Cards = Cards;
    notifyListeners();
  }

  set Purchases(List<PurchaseModel> Products) {
    _Purchases = Products;
    notifyListeners();
  }

}

