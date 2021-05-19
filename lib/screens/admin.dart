import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/db/brands.dart';
import 'package:adminpaneltechshopp/db/categories.dart';
import 'package:adminpaneltechshopp/db/product.dart';
import 'package:adminpaneltechshopp/get_functions.dart';
import 'package:adminpaneltechshopp/providers/user_provider.dart';
import 'package:adminpaneltechshopp/screens/Login_page.dart';
import 'package:adminpaneltechshopp/screens/dispaly_categories.dart';
import 'package:adminpaneltechshopp/screens/display_admins.dart';
import 'package:adminpaneltechshopp/screens/display_brands.dart';
import 'package:adminpaneltechshopp/screens/display_cards.dart';
import 'package:adminpaneltechshopp/screens/display_prods.dart';
import 'package:adminpaneltechshopp/screens/display_sales.dart';
import 'package:adminpaneltechshopp/screens/display_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:adminpaneltechshopp/Product/add_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../db/sales.dart';
import '../db/user.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  ProductService productService = ProductService();

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getProducts(appProvider);
    getUsers(appProvider);
    loadCards(appProvider);
    loadCards(appProvider);
    getAdmins(appProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Panneau'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Gérer'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(FontAwesomeIcons.powerOff),
          onPressed: (){
            user.signOut();
              Navigator.maybePop(context, MaterialPageRoute(builder: (BuildContext context) => new Login()));
        },
    ),
    );
  }

  Widget _loadScreen() {

    switch (_selectedPage) {
      case Page.dashboard:
        AppProvider appProvider = Provider.of<AppProvider>(context);
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton(
                onPressed: null,
                child: Text('12,000 MAD',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenu',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Expanded(child: Text("Utilisateurs"))),
                          subtitle: Text(
                            appProvider.Users.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Expanded(child: Text("Adms"))),
                          subtitle: Text(
                            appProvider.Admins.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.credit_card),
                              label: Text("Cartes")),
                          subtitle: Text(
                            appProvider.Cards.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Produits")),
                          subtitle: Text(
                            appProvider.Products.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Ventes")),
                          subtitle: Text(
                            appProvider.Purchases.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_basket, size: 20),
                              label: Expanded(child: Text("Commandes"))),
                          subtitle: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text("Liste des produits"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new diplay_Prods()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Liste des utilisateurs"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new diplay_Users()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Liste des administrateurs"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new diplay_Admins()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Liste des cartes"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new diplay_Cards()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Liste des commandes"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new diplay_Sales()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Liste des catégories"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new diplay_Cats()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.branding_watermark),
              title: Text("Liste des marques"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new diplay_Brands()));
              },
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }
}
