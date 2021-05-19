import 'package:adminpaneltechshopp/Sales/edit_sale.dart';
import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/custom_text.dart';
import 'package:adminpaneltechshopp/db/brands.dart';
import 'package:adminpaneltechshopp/db/sales.dart';
import 'package:adminpaneltechshopp/get_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class diplay_Sales extends StatefulWidget {
  @override
  _diplay_SalesState createState() => _diplay_SalesState();
}

class _diplay_SalesState extends State<diplay_Sales> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    loadPurchases(appProvider);
    super.initState();
  }
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    AppProvider appProvider = Provider.of<AppProvider>(context);
    SaleService saleService = SaleService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "Commandes",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: ListView.builder(
            itemCount: appProvider.Purchases.length,
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
                    leading: CustomText(msg: appProvider.Purchases[index].montant.toString() +"DH"),
                    title: Text(appProvider.Purchases[index].NomProduit),
                    subtitle: Text("${appProvider.Purchases[index].IdUtilisateur.substring(0,9)},  ${dateFormat.format(DateTime.parse(appProvider.Purchases[index].date))}"),
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
                        PopupMenuItem(
                          value: 2,
                          child: Text(
                            "modifier",
                          ),
                        ),
                      ],
                      elevation: 4,
                      onSelected: (result) {
                        if (result == 1) {
                          saleService.deleteSale(appProvider.Purchases[index].id);
                        }
                        if (result == 2) {
                         Navigator.push(context, MaterialPageRoute(builder:(context)=> new EditSale(
                           uid: appProvider.Purchases[index].IdUtilisateur,
                           id: appProvider.Purchases[index].id,
                           nomProd:appProvider.Purchases[index].NomProduit,
                           montant:appProvider.Purchases[index].montant,
                           quantite: appProvider.Purchases[index].quantite,
                           couleur: appProvider.Purchases[index].couleur,
                         )));
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
        true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      loadPurchases(appProvider);
    });
  }

}
