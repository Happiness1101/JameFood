import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamefood/model/user_model.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/normal_dialog.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String nameShop, address, phone, urlPicture;
  Location location = Location();
  double lat, lng;
  File file;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();
    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        //print('lat ==> $lat , lng ==> $lng');
      });
    });
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString("ID");
    print('ID Shop ==> $idShop');

    String url =
        '${MyConstant().domain}/jamefood/getUserWhereId.php?isAdd=true&id=$idShop';
    Response response = await Dio().get(url);
    print('Respose ==> $response');

    var result = json.decode(response.data);
    print('result ==> $result');

    for (var map in result) {
      print('map => $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameShop = userModel.nameShop;
        address = userModel.address;
        phone = userModel.phone;
        urlPicture = userModel.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปรับปรุงรายละเอียดของร้าน'),
      ),
      body: userModel == null ? MyStyle().showProgrees() : showContent(),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showImage(),
            nameShopForm(),
            addressForm(),
            phoneForm(),
            lat == null ? MyStyle().showProgrees() : showMap(),
            editButton(),
          ],
        ),
      );

  Widget editButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
            color: Colors.deepOrange.shade500,
            onPressed: () {
              confirmDialog();
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            label: Text(
              'ปรับปรุงรายละเอียดร้าน',
              style: TextStyle(color: Colors.white),
            )),
      );

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ยืนยันการปรับปรุงรายละเอียดร้าน'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text('OK'),
              ),
              OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'editShop$i.jpg';
    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/jamefood/saveShop.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      urlPicture = '/jamefood/Shop/$nameFile';

      String id = userModel.id;
      String url =
          '${MyConstant().domain}/jamefood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng';
      print("urlPicture ==> $urlPicture");

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        nomalDialog(context, '*อัพเดทไม่ได้ กรุณารองอีกครั้ง');
      }
    });
  }

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('MyMarker'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'ร้านอยู่ที่นี้', snippet: 'Lat = $lat, Lng = $lng'),
      )
    ].toSet();
  }

  Container showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: currentMarker(),
      ),
    );
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  size: 40.0,
                ),
                onPressed: () {
                  chooseImage(ImageSource.camera);
                }),
            Container(
              width: 250.0,
              height: 250.0,
              child: file == null
                  ? Image.network('${MyConstant().domain}$urlPicture')
                  : Image.file(file),
            ),
            IconButton(
                icon: Icon(
                  Icons.add_photo_alternate,
                  size: 40.0,
                ),
                onPressed: () {
                  chooseImage(ImageSource.gallery);
                }),
          ],
        ),
      );

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker()
          .getImage(source: imageSource, maxWidth: 800.0, maxHeight: 800.0);
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                nameShop = value;
              },
              initialValue: nameShop,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ชื่อของร้าน'),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                address = value;
              },
              initialValue: address,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่ของร้าน'),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                phone = value;
              },
              initialValue: phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'เบอร์ติดต่อของร้าน'),
            ),
          ),
        ],
      );
}
