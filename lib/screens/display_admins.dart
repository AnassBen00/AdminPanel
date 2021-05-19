import 'package:adminpaneltechshopp/Admin/add_admin.dart';
import 'package:adminpaneltechshopp/Admin/edit_admin.dart';
import 'package:adminpaneltechshopp/Users/edit_user.dart';
import 'package:adminpaneltechshopp/db/admin.dart';
import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/get_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class diplay_Admins extends StatefulWidget {
  @override
  _diplay_AdminsState createState() => _diplay_AdminsState();
}

class _diplay_AdminsState extends State<diplay_Admins> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getAdmins(appProvider);
    super.initState();
  }
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    AdminService adminService = AdminService();
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "Administrateurs",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: ListView.builder(
            itemCount: appProvider.Admins.length,
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
                    leading: Icon(Icons.person),
                    title: Text(appProvider.Admins[index].name),
                    subtitle: Text(appProvider.Admins[index].email) ,
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
                          adminService.deleteAdmin(appProvider.Admins[index].uid);
                        }
                        if (result == 2) {
                          Navigator.push(context, MaterialPageRoute(builder:(context)=> new EditAdmin(
                            id: appProvider.Admins[index].uid,
                            nom: appProvider.Admins[index].name,
                            email : appProvider.Admins[index].email,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> new AddAdmin()));
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
      getAdmins(appProvider);
    });
  }
}
