import 'package:adminpaneltechshopp/Users/add_user.dart';
import 'package:adminpaneltechshopp/Users/edit_user.dart';
import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/db/user.dart';
import 'package:adminpaneltechshopp/get_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class diplay_Users extends StatefulWidget {
  @override
  _diplay_UsersState createState() => _diplay_UsersState();
}

class _diplay_UsersState extends State<diplay_Users> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getUsers(appProvider);
    super.initState();
  }
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "Utilisateurs",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: ListView.builder(
            itemCount: appProvider.Users.length,
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
                    title: Text(appProvider.Users[index].name),
                    subtitle: Text(appProvider.Users[index].email) ,
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
                          userService.deleteUser(appProvider.Users[index].uid);
                        }
                        if (result == 2) {
                          Navigator.push(context, MaterialPageRoute(builder:(context)=> new EditUser(
                            id: appProvider.Users[index].uid,
                            nom: appProvider.Users[index].name,
                            email : appProvider.Users[index].email,
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
          Navigator.push(context, MaterialPageRoute(builder:(context)=> new AddUser()));
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
      getUsers(appProvider);
    });
  }
}
