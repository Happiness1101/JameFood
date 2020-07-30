import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jamefood/screens/signin.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String chooseType, name, user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          myLogo(),
          MyStyle().mySizeBox(),
          showAppName(),
          MyStyle().mySizeBox(),
          nameFrom(),
          MyStyle().mySizeBox(),
          userFrom(),
          MyStyle().mySizeBox(),
          passwordFrom(),
          MyStyle().mySizeBox(),
          userRadio(),
          shopRadio(),
          riderRadio(),
          MyStyle().mySizeBox(),
          registerButton(),
        ],
      ),
    );
  }

  Widget registerButton() {
    return Container(
      width: 250.0,
      child: RaisedButton(
        color: MyStyle().darkColor,
        onPressed: () {
          print('Name = $name,User = $user,Password = $password');
          if (name == null ||
              name.isEmpty ||
              user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            print('Have Space');
            nomalDialog(context, '* กรูณากรอบข้อมูลให้ครบ');
          } else if (chooseType == null) {
            nomalDialog(context, '* โปรดเลือกรายการผู้สมัค');
          } else {
            checkUser();
            print('chooseType = $chooseType');
            MaterialPageRoute pageRoute = MaterialPageRoute(
              builder: (context) => SignIn(),
            );
            Navigator.pushAndRemoveUntil(context, pageRoute, (route) => false);
          }
        },
        child: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/phpmyadmin/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        nomalDialog(context, 'ID $user ถูกใช้เเล้ว กรุณาเปลี่ยน ID ใหม่');
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        '${MyConstant().domain}/phpmyadmin/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=$chooseType';
    try {
      Response response = await Dio().get(url);
      print('res =$response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        nomalDialog(context, 'ไม่สามารถสมัคได้ กรุณาลองใหม่');
      }
    } catch (e) {
      print('url = Eror');
    }
  }

  Widget userRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'User',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้สั่งอาหาร',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      );

  Widget shopRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Shop',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'เจ้าของร้าน',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      );

  Widget riderRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Rider',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้ส่งอาหาร',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      );

  Widget nameFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) {
                name = value.trim();
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().primaryColor),
                labelText: 'Name',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
              ),
            ),
          ),
        ],
      );

  Widget userFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) {
                user = value.trim();
              },
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
          ),
        ],
      );

  Widget passwordFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) {
                password = value.trim();
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_box,
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
          ),
        ],
      );

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyStyle().showTitle('Jame Food'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showLogo(),
        ],
      );
}
