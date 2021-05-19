import 'package:flutter/material.dart';
import 'package:adminpaneltechshopp/db/user.dart';
import 'package:adminpaneltechshopp/utils/splash.dart';
import '../db/sales.dart';
import '../db/user.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class EditUser extends StatefulWidget {
  final id;
  final email;
  final nom;

  const EditUser({Key key, this.id, this.email, this.nom}) : super(key: key);
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  UserService userService = UserService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  bool isLoading = false;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
          onPressed:() => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: black,
          ),
        ),
        title: Text(
          "Modifier utilisateur",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: NameController,
                  decoration: InputDecoration(hintText: widget.nom),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Vous devez saisir le nom d'utilisateur";
                    } else if (value.length > 40) {
                      return 'le nom ne peut pas avoir plus de 40 lettres';
                    }
                  },
                ),
              ),

              Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: widget.email,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Veuillez vous assurer que votre adresse e-mail est valide';
                        else
                          return null;
                      }
                    },
                  ),
                ),
              ),

              FlatButton(
                color: red,
                textColor: white,
                child: Text('Confirmer'),
                onPressed: () {
                  validateAndUpload();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);

      userService.updateUser(name: NameController.text, email: emailController.text, uid:widget.id);
      _formKey.currentState.reset();
      setState(() => isLoading = false);
//            Fluttertoast.showToast(msg: 'Product added');
      Navigator.pop(context);
    };


//          Fluttertoast.showToast(msg: 'select atleast one size');
  }


//        Fluttertoast.showToast(msg: 'all the images must be provided');
}

