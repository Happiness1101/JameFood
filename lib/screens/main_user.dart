import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/signout_process.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  //Field
  String nameUser;
  @override
  void initState() {
    super.initState();
    findUser();
    readShop();
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/jamefood/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';
    await Dio().get(url).then((value) {
      print('value ==> $value');
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                signOutProcess(context);
              })
        ],
      ),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[],
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxdecoration('user.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text('Name Login'),
        accountEmail: Text('Login'));
  }
}
