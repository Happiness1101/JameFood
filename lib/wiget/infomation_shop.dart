import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jamefood/model/user_model.dart';
import 'package:jamefood/screens/add_info_shop.dart';
import 'package:jamefood/screens/edit_info_shop.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfomationShop extends StatefulWidget {
  @override
  _InfomationShopState createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('ID');
    String url =
        '${MyConstant().domain}/jamefood/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      print('value = $value');
      var result = json.decode(value.data);
      print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('nameShop = ${userModel.nameShop}');
        if (userModel.nameShop.isEmpty) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgrees()
            : userModel.nameShop.isEmpty
                ? showNoData(context)
                : showListInfoShop(),
        addAndeditButton(),
      ],
    );
  }

  Widget showListInfoShop() => Column(
        children: <Widget>[
          MyStyle().showTitle('รายละเอียดร้าน ${userModel.nameShop}'),
          showImage(),
          MyStyle().showTitle('ที่อยู่ของร้าน'),
          Text(userModel.address),
          showMap(),
        ],
      );

  Container showImage() {
    return Container(
      width: 250.0,
      height: 250.0,
      child: Image.network('${MyConstant().domain}${userModel.urlPicture}'),
    );
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('ShopID'),
        position: LatLng(
          double.parse(userModel.lat),
          double.parse(userModel.lng),
        ),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งร้าน',
            snippet: 'ละติจูด = ${userModel.lat}, ลองติจูด = ${userModel.lng}'),
      ),
    ].toSet();
  }

  Widget showMap() {
    double lat = double.parse(userModel.lat);
    double lng = double.parse(userModel.lng);
    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      //padding: EdgeInsets.all(10.0),
      //height: 300.0,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }

  Widget showNoData(BuildContext context) =>
      MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพื่มข้อมูล');

  Row addAndeditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  routeToAddInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void routeToAddInfo() {
    Widget widget = userModel.nameShop.isEmpty ? AddInfoShop() : EditInfoShop();
    MaterialPageRoute pageRoute =
        MaterialPageRoute(builder: (context) => widget);
    Navigator.push(context, pageRoute).then((value) => readDataUser());
  }
}
