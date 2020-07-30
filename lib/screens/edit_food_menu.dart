import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamefood/model/food_model.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/normal_dialog.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodModel;
  EditFoodMenu({Key key, this.foodModel}) : super(key: key);
  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodModel foodModel;
  File file;
  String name, price, detail, pathImage;
  @override
  void initState() {
    super.initState();
    foodModel = widget.foodModel;
    name = foodModel.nameFood;
    price = foodModel.price;
    detail = foodModel.detail;
    pathImage = foodModel.pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text('แก้ไขรายละเอียด ${foodModel.nameFood}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameFood(),
            groupImage(),
            priceFood(),
            detailFood(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      onPressed: () {
        if (name.isEmpty || price.isEmpty || detail.isEmpty) {
          nomalDialog(context, '*กรุณากรอกข้อมูลให้ครบทุกช่อง');
        } else {
          confirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ยืนยันการเเก้ไขการเปลี่ยนแปลง เมูนอาหาร'),
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('ยืนยัน'),
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ยกเลิก'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editValueOnMySQL() async {
    String id = foodModel.id;
    String url =
        '${MyConstant().domain}/jamefood/editDetailFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&PathImage=$pathImage&Price=$price&Detail=$detail';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        nomalDialog(context, 'กรุณาลองใหม่');
      }
    });
  }

  Widget groupImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () {
              chooseImage(ImageSource.camera);
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.network(
                    '${MyConstant().domain}${foodModel.pathImage}',
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
              chooseImage(ImageSource.gallery);
            },
          )
        ],
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

  Widget nameFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                name = value.trim();
              },
              initialValue: name,
              decoration: InputDecoration(
                labelText: 'ชื่อเมนูอาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget priceFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                price = value.trim();
              },
              keyboardType: TextInputType.number,
              initialValue: price,
              decoration: InputDecoration(
                labelText: 'ราคาเมนูอาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                detail = value.trim();
              },
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              initialValue: detail,
              decoration: InputDecoration(
                labelText: 'รายละเอียดเมนูอาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
