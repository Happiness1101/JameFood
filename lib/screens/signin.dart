import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jamefood/model/user_model.dart';
import 'package:jamefood/screens/main_rider.dart';
import 'package:jamefood/screens/main_shop.dart';
import 'package:jamefood/screens/main_user.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Fiele
  String user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          colors: <Color>[Colors.white, Colors.orange.shade300],
          center: Alignment(0, -0.3),
          radius: 1.0,
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().mySizeBox(),
                MyStyle().showTitle('Jame Food'),
                MyStyle().mySizeBox(),
                userFrom(),
                MyStyle().mySizeBox(),
                passwordFrom(),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      width: 250.0,
      child: RaisedButton(
        color: MyStyle().darkColor,
        onPressed: () {
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            nomalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
            print('ID = $user');
          } else {
            checkAuthen();
          }
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}/phpmyadmin/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      print('Response = $response');
      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String chooseType = userModel.chooseType;
          if (chooseType == 'User') {
            routeToService(MainUser(), userModel);
          } else if (chooseType == 'Shop') {
            routeToService(MainShop(), userModel);
          } else if (chooseType == 'Rider') {
            routeToService(MainRider(), userModel);
          } else {
            nomalDialog(context, 'Error');
          }
        } else {
          nomalDialog(context, 'Password ไม่ถูกต้อง');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget myWiget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('ID', userModel.id);
    preferences.setString('ChooseType', userModel.chooseType);
    preferences.setString('Name', userModel.name);
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (context) => myWiget,
    );
    Navigator.pushAndRemoveUntil(context, pageRoute, (route) => false);
  }

  Widget userFrom() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().primaryColor),
            labelText: 'ID',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
          ),
        ),
      );

  Widget passwordFrom() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) {
            password = value.trim();
          },
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().primaryColor),
            labelText: 'Password',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
          ),
        ),
      );
}
