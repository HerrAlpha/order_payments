import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_payments/repository/auth_repository.dart';
import 'package:order_payments/ui/main_menu/home/home.dart';
import 'package:order_payments/ui/main_menu/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authRepository = new AuthRepository();

  User? user;

  @override
  void initState() {
    //
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   () async {
    //     final SharedPreferences prefs = await SharedPreferences.getInstance();
    //     dynamic user_data = jsonEncode(prefs.getString('user'));
    //     User user = User.fromJson(user_data);
    //     print('as');
    //   };
    //
    // });
    // TODO: implement initState
    () async {
      await _getDataUser();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
    super.initState();
  }

  _getDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? acces_token = prefs.getString('acces_token');
    if (acces_token != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();

    return Container(
      key: key,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Email"),
                TextField(
                  controller: emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Password",
                ),
                TextField(
                  controller: passwordController,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _submitLogin,
                  child: Text('TextButton'),
                )
              ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _submitLogin() async {
    var response = await _authRepository.login(
        emailController.text, passwordController.text);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', jsonEncode(response['data']['user']));
    prefs.setString('acces_token', response['data']['token']);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

// void submitLogin(key) {
//   key.currentState.showSnackBar(new SnackBar(
//     content: new Text("Sending Message"),
//   ));
// }
}
