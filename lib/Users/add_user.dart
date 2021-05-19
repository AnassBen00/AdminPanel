import 'package:adminpaneltechshopp/providers/user_provider.dart';
import 'package:adminpaneltechshopp/utils/passwordGenerator.dart';
import 'package:flutter/material.dart';
import 'package:adminpaneltechshopp/db/user.dart';
import 'package:adminpaneltechshopp/utils/splash.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import '../db/user.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  UserService userService = UserService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  bool isLoading = false;
  final _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
          "Ajouter utilisateur",
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
                  decoration: InputDecoration(hintText: 'Nom complet'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Vous devez saisir le nom d'utilisateur";
                    } else if (value.length > 60) {
                      return 'le nom ne peut pas avoir plus de 10 lettres';
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
                      hintText: 'Email',
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
                child: Text('Ajouter'),
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

  void sendMessage({ String password}){
    String inputEmail= emailController.text;
    String inputMessage;
    Email email;
    setState(() {
      print(emailController.text);
      inputMessage = "password: ${password} à utiliser pour s'authentifier";
      if(inputMessage.isNotEmpty && inputEmail.isNotEmpty) {
        email = Email(
          body: inputMessage,
          subject: 'Votre password pour se connecter à TechShopp',
          recipients: [inputEmail],
        );
        send(email);
      }
    });
    debugPrint('email -> $inputEmail  message -> $inputMessage');
    Navigator.pop(context);
  }
  void send(Email email) async {
    await FlutterEmailSender.send(email);
  }

  void validateAndUpload() async {
    final user = Provider.of<UserProvider>(context);
    String pass = userService.password();
    sendMessage( password: pass );

    if (_formKey.currentState.validate()) {
      if(!await user.signUpUser(NameController.text ,emailController.text, pass)){
        _key.currentState.showSnackBar(SnackBar(content: Text("le mot de passe doit contenir au moins 6 caractères")));
        return;
      }
    }
        }

      }

