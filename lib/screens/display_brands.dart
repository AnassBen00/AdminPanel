import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/db/brands.dart';
import 'package:adminpaneltechshopp/get_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adminpaneltechshopp/db/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class diplay_Brands extends StatefulWidget {
  @override
  _diplay_BrandsState createState() => _diplay_BrandsState();
}

class _diplay_BrandsState extends State<diplay_Brands> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getBrands(appProvider);
    super.initState();
  }

  BrandService _brandService = BrandService();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "Marques",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: ListView.builder(
            itemCount: appProvider.Brands.length,
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
                    leading: Icon(Icons.bookmark),
                    title: Text(appProvider.Brands[index].nom),
                    //subtitle: Text(""),
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
                         _brandService.deleteBrand(appProvider.Brands[index].nom);
                        }
                        if (result == 2) {
                          ///  Pour ajouter edit
                        }
                      },
                    ),
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
           _brandAlert();
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
      getBrands(appProvider);
    });
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value){
            if(value.isEmpty){
              return 'la catégorie ne peut pas être vide';
            }
          },
          decoration: InputDecoration(
              hintText: "Ajouter une marque"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(brandController.text != null){
            _brandService.createBrand(brandController.text);
          }
//          Fluttertoast.showToast(msg: 'brand added');
          Navigator.pop(context);
         }, child: Text('Ajouter')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
         }, child: Text('Annuler')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

}
