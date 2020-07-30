import 'dart:convert';
//import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jamefood/model/food_model.dart';
import 'package:jamefood/screens/add_food_menu.dart';
import 'package:jamefood/screens/edit_food_menu.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenuShop extends StatefulWidget {
  @override
  _ListFoodMenuShopState createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  bool loadStatus = true; //Prosess Load JSON
  bool status = true;
  List<FoodModel> foodModels = List();

  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('ID');
    print('idShop = $idShop');

    String url =
        '${MyConstant().domain}/jamefood/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        //print('value ==> $value');
        var result = json.decode(value.data);
        // print('result ==> $result');
        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? MyStyle().showProgrees() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget showListFood() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                '${MyConstant().domain}${foodModels[index].pathImage}',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      foodModels[index].nameFood,
                      style: MyStyle().mainTitle20(),
                    ),
                    Text('ราคา ${foodModels[index].price} บาท',
                        style: MyStyle().mainTitle16()),
                    Text(foodModels[index].detail),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            MaterialPageRoute pageRoute = MaterialPageRoute(
                              builder: (context) => EditFoodMenu(
                                foodModel: foodModels[index],
                              ),
                            );
                            Navigator.push(context, pageRoute)
                                .then((value) => readFoodMenu());
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteFood(foodModels[index]);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<Null> deleteFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showTitle('คุณต้องการลบ เมนู ${foodModel.nameFood} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${MyConstant().domain}/jamefood/deleteFoodWhereId.php?isAdd=true&id=${foodModel.id}';
                  await Dio().get(url).then((value) => readFoodMenu());
                },
                child: Text('ยืนยัน'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ยกเลิก'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      MaterialPageRoute pageRoute = MaterialPageRoute(
                        builder: (context) => AddFoodMenu(),
                      );
                      Navigator.push(context, pageRoute)
                          .then((value) => readFoodMenu());
                    }),
              ),
            ],
          ),
        ],
      );
}
