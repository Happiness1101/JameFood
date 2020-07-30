import 'package:flutter/material.dart';
import 'package:jamefood/model/user_model.dart';


class OderListShop extends StatefulWidget {
  @override
  _OderListShopState createState() => _OderListShopState();
}

class _OderListShopState extends State<OderListShop> {
  //Fild
  UserModel userModel;

  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Text('แสดงรายการอาหารที่ลูกค้าสั่ง');
  }
}
