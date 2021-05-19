import 'package:adminpaneltechshopp/Product/add_product.dart';
import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/db/brands.dart';
import 'package:adminpaneltechshopp/db/cards.dart';
import 'package:adminpaneltechshopp/get_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adminpaneltechshopp/db/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class diplay_Cards extends StatefulWidget {
  @override
  _diplay_CardsState createState() => _diplay_CardsState();
}

class _diplay_CardsState extends State<diplay_Cards> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    loadCards(appProvider);
    super.initState();
  }
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    CardService cardService = CardService();
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "Cartes",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: ListView.builder(
            itemCount: appProvider.Cards.length,
            itemBuilder: (BuildContext context, index){
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 1),
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text("**** **** **** ${appProvider.Cards[index].num_carte.replaceAll(RegExp(r"\s+\b|\b\s"), "").toString().substring(11)}"),
                    subtitle: Text("${appProvider.Cards[index].mois_exp} / ${appProvider.Cards[index].an_exp}"),
                    trailing:
                      PopupMenuButton<int>(
                        icon: Icon(Icons.more_horiz),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "supprimer",
                            ),
                          ),
                        ],
                        elevation: 4,
                        onSelected: (result) {
                          if (result == 1) {
                            cardService.deleteCard(appProvider.Cards[index].id);
                          }
                        },
                      ),
                  ),
                ),
              );
            }),
        onRefresh: refreshlist,
      ),
    );
  }
  Future<Null> refreshlist() async {
    refreshkey.currentState?.show(
        atTop:
        true); // change atTop to false to show progress indicator at bottom
    await Future.delayed(Duration(seconds: 2)); //wait here for 2 second
    setState(() {
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      loadCards(appProvider);
    });
  }
}
