import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.deepOrange.shade500;

  Widget showProgrees() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  SizedBox mySizeBox() => SizedBox(
        width: 8.0,
        height: 8.0,
      );

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  TextStyle mainTitle20() => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
    );

      TextStyle mainTitle16() => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
    );
 

  Container showLogo() {
    return Container(
      child: Image.asset(
        'images/iconApp.png',
        width: 150.0,
      ),
    );
  }

  BoxDecoration myBoxdecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/shop.jpg'), fit: BoxFit.cover));
  }

  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  MyStyle();
}
