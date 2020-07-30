import 'package:flutter/material.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/signout_process.dart';
import 'package:jamefood/wiget/list_food_manu_shop.dart';
import 'package:jamefood/wiget/infomation_shop.dart';
import 'package:jamefood/wiget/order_list_shop.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  //Field
  Widget currentWiget = OderListShop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Shop'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                signOutProcess(context);
              }),
        ],
      ),
      drawer: showDrawer(),
      body: currentWiget,
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          homeMenu(),
          foodMenu(),
          infomatoionMenu(),
          singoutMenu(),
        ],
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

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text('รายการอาหาร ที่สั่ง'),
        subtitle: Text('รายการอาหารที่ยังไม่ได้ทำส่ง'),
        onTap: () {
          setState(() {
            currentWiget = OderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text('รายการอาหาร'),
        subtitle: Text('รายการอาหารของร้าน'),
        onTap: () {
          setState(() {
            currentWiget = ListFoodMenuShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile infomatoionMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายละเอียดของร้าน'),
        subtitle: Text('รายละเอียดต่างๆ ของร้าน'),
        onTap: () {
          setState(() {
            currentWiget = InfomationShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile singoutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('ออกจากหน้านี้'),
        onTap: () {
          signOutProcess(context);
        },
      );
}
