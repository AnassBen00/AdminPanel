import 'package:adminpaneltechshopp/providers/app_provider.dart';
import 'package:adminpaneltechshopp/providers/user_provider.dart';
import 'package:adminpaneltechshopp/screens/Login_page.dart';
import 'package:adminpaneltechshopp/utils/splash.dart';
import 'package:flutter/material.dart';
import 'package:adminpaneltechshopp/screens/admin.dart';
import 'package:provider/provider.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScreensController(),
      )));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return Admin();
      default:
        return Login();
    }
  }
}