import 'package:flutter/material.dart';
import 'package:jamefood/screens/show_shop_food_menu.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/signout_process.dart';
import 'package:jamefood/wiget/show_list_shop_all.dart';
import 'package:jamefood/wiget/show_status_food_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  //Field
  String nameUser;
  Widget currenWidget;

  @override
  void initState() {
    super.initState();
    currenWidget = ShowListShopAll();
    findUser();
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
        body: currenWidget);
  }

  Drawer showDrawer() {
    return Drawer(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showHead(),
              menuListShop(),
              menuList(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              signOut(),
            ],
          ),
        ],
      ),
    );
  }

  ListTile menuListShop() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currenWidget = ShowListShopAll();
        });
      },
      leading: Icon(
        Icons.home,
      ),
      title: Text('แสดงร้านค้า'),
      subtitle: Text('แสดงร้านค้าที่สามารถสั่งอาหาร'),
    );
  }

  ListTile menuList() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currenWidget = ShowStatusFoodOrder();
        });
      },
      leading: Icon(
        Icons.restaurant,
      ),
      title: Text('รายการอาหารที่สั่ง'),
      subtitle: Text('แสดงรายการอาหารที่สั่ง'),
    );
  }

  Widget signOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.deepOrange),
      child: ListTile(
        onTap: () {
          signOutProcess(context);
        },
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'SignOut',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'ออกจากระบบ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxdecoration('user.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          nameUser == null ? 'Name Login' : nameUser,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        accountEmail: Text('Login'));
  }
}
