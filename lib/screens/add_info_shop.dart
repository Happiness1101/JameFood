import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/normal_dialog.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  //Field
  double lat, lng;
  File imageFile;
  String nameShop, address, phone, urlImage;

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.altitude;
      lng = locationData.longitude;
    });
    print('lat = $lat');
    print('lng = $lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('Location'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'ร้านของคุณ', snippet: 'ละติจูด = $lat, ลองติจูด = $lng'),
      )
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Infomation Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizeBox(),
            nameForm(),
            MyStyle().mySizeBox(),
            addressForm(),
            MyStyle().mySizeBox(),
            phoneForm(),
            MyStyle().mySizeBox(),
            groupImage(),
            MyStyle().mySizeBox(),
            lat == null ? MyStyle().showProgrees() : showMap(),
            MyStyle().mySizeBox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
          color: MyStyle().darkColor,
          onPressed: () {
            if ((nameShop == null || nameShop.isEmpty) ||
                (address == null || address.isEmpty) ||
                (phone == null || phone.isEmpty)) {
              nomalDialog(context, '*กรุณากรอกข้อมูลให้ครบถ้วน');
            } else if (imageFile == null) {
              nomalDialog(context, '*กรุณาเลือกรูปภาพ');
            } else {
              uploadImage();
            }
          },
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: Text(
            'Save Infomation',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'Shop$i.jpg';
    String url = '${MyConstant().domain}/jamefood/saveShop.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: nameImage,
      );

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('Response =>$value');
        urlImage = '/jamefood/Shop/$nameImage';
        print('urlImage = $urlImage');

        editUserShop();
      });
    } catch (e) {}
  }

  Future<Null> editUserShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('ID');
    String url =
        '${MyConstant().domain}/jamefood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlImage&Lat=$lat&Lng=$lng';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        print('ID ==> $id');
        Navigator.pop(context);
      } else {
        nomalDialog(context, '*ไม่สามารถบันทึกได้ กรุณาลองอีกครั้ง');
      }
    });
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16.0);
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 40.0,
              color: Colors.green.shade400,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera);
            }),
        Container(
          width: 250.0,
          child: imageFile == null
              ? Image.asset('images/shop1.jpg')
              : Image.file(imageFile),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 40.0,
              color: Colors.purple.shade400,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery);
            }),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        imageFile = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) {
                nameShop = value.trim();
              },
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) {
                address = value.trim();
              },
              decoration: InputDecoration(
                labelText: 'ที่อยู่ร้านค้า',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) {
                phone = value.trim();
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'เบอร์ติดต่อร้านค้า',
                prefixIcon: Icon(Icons.phone_in_talk),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
