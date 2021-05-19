import 'package:adminpaneltechshopp/Product/add_product.dart';
import 'package:adminpaneltechshopp/Product/edit_product.dart';
import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/db/brands.dart';
import 'package:adminpaneltechshopp/get_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adminpaneltechshopp/db/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class diplay_Prods extends StatefulWidget {
  @override
  _diplay_ProdsState createState() => _diplay_ProdsState();
}

class _diplay_ProdsState extends State<diplay_Prods> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getProducts(appProvider);
    super.initState();
  }
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    ProductService productService = ProductService();
    AppProvider appProvider = Provider.of<AppProvider>(context);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "Produits",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: ListView.builder(
          itemCount: appProvider.Products.length,
          itemBuilder: (BuildContext context, index){
            return Card(
              child: ListTile(
                leading: new  Image.network(appProvider.Products[index].image, width: 80.0, height: 100.0,),
                //=========TITLE SECTION=============
                title: new Text(appProvider.Products[index].nom),
                //=======SUBTITLE SECTION============
                subtitle: new Column(
                  children: <Widget>[
                    //-----> ROW INSIDE COLUMN
                    Row(
                      children: <Widget>[
                        /*Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new Text("couleurs:"),
                        ),*/

                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: new Text(appProvider.Products[index].couleurs.toList().toString(), style: TextStyle(color: Colors.indigo),),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
                          child: new Text("${dateFormat.format(appProvider.Products[index].dateCreation.toDate())}", style: TextStyle(color: Colors.black)),
                        ),

                        /*Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: new Text(appProvider.Products[index].marque, style: TextStyle(color: Colors.black)),
                        ),*/
                      ],
                    ),

                    //===========THIS SECTION IS FOR THE PRICE=========
                    Container(
                      alignment: Alignment.topLeft,
                      child: new Text("${appProvider.Products[index].prix}\DH", style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      ),
                    )
                  ],
                ),
                trailing: PopupMenuButton<int>(
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
                      productService.deleteProduct(appProvider.Products[index].id);
                    }
                    if (result == 2) {
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> new EditProduct(
                        id: appProvider.Products[index].id,
                        nom: appProvider.Products[index].nom,
                        description : appProvider.Products[index].description,
                        prix: appProvider.Products[index].prix,
                      )));
                    }
                  },
                ),
              ),
            );
          }),
        onRefresh: refreshlist,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> new AddProduct()));
        },
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
      getProducts(appProvider);
    });
  }

}
