import 'package:ev_bunk/Authentication/Register.dart';
import 'package:ev_bunk/main.dart';
import 'package:ev_bunk/pages/homePage.dart';
import 'package:flutter/material.dart';

class Auth_Wrapper extends StatelessWidget {
  const Auth_Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isin == true) {
      return HomePage();
    } else {
      return Register();
    }
  }
}
