import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:jamefood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  String namefood, price, detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพื่มรายการอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showTitle('อาหารของร้าน'),
            showTitlePicture(),
            showTitle('รายละเอียดเมนูอาหาร'),
            nameForm(),
            MyStyle().mySizeBox(),
            priceForm(),
            MyStyle().mySizeBox(),
            detailForm(),
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
        onPressed: () {
          if (file == null) {
            nomalDialog(context,
                '*ไม่มีรูปภาพ กรุณาเลือกรูปภาพ จาก Camera หรือ Gallery');
          } else if (namefood == null ||
              namefood.isEmpty ||
              price == null ||
              price.isEmpty) {
            nomalDialog(context, '*กรุณากรอกข้อมูลให้ครบ');
          } else {
            upLoadFoodAndImsertData();
          }
        },
        icon: Icon(
          Icons.save_alt,
          color: Colors.white,
        ),
        label: Text(
          'Save Food Menu',
          style: TextStyle(color: Colors.white),
        ),
        color: MyStyle().primaryColor,
      ),
    );
  }

  Future<Null> upLoadFoodAndImsertData() async {
    String urlUpload = '${MyConstant().domain}/jamefood/saveFood.php';
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'Food$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) async {
        String urlPathImage = '/jamefood/Food/$nameFile';
        print('urlPathImage ==> ${MyConstant().domain}$urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String idShop = preferences.getString('ID');

        String urlInsertData =
            '${MyConstant().domain}/jamefood/addFood.php?isAdd=true&idShop=$idShop&NameFood=$namefood&PathImage=$urlPathImage&Price=$price&Detail=$detail';
        await Dio().get(urlInsertData).then((value) => Navigator.pop(context));
      });
    } catch (e) {}
  }

  Widget nameForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) {
            namefood = value.trim();
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.fastfood),
            labelText: 'ชื้ออาหาร',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceForm() => Container(
        width: 250.0,
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            price = value.trim();
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.attach_money),
            labelText: 'ราคาอาหาร',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget detailForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) {
            detail = value.trim();
          },
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.details),
            labelText: 'รายละเอียดอาหาร',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget showTitle(String string) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showTitle(string),
        ],
      ),
    );
  }

  Row showTitlePicture() {
    return Row(
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
              ? Center(
                  child: Text(
                  'ไม่มีรูปภาพอาหาร...',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ))
              : Image.file(file),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 40.0,
          ),
          onPressed: () {
            chooseImage(ImageSource.gallery);
          },
        )
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
        file = File(object.path);
      });
    } catch (e) {}
  }
}
