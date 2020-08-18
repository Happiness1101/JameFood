import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jamefood/model/user_model.dart';
import 'package:jamefood/screens/show_shop_food_menu.dart';
import 'package:jamefood/utility/my_constant.dart';
import 'package:jamefood/utility/my_style.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  List<UserModel> userModels = List();
  List<Widget> shopCards = List();

  @override
  void initState() {
    super.initState();
    readShop();
  }

  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
        ? MyStyle().showProgrees()
        : GridView.extent(
            maxCrossAxisExtent: 150.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: shopCards,
          );
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/jamefood/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';
    await Dio().get(url).then((value) {
      print('value ==> $value');
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);

        String nameshop = model.nameShop;
        if (nameshop.isNotEmpty) {
          print('NameShop = ${model.nameShop}');
          setState(() {
            userModels.add(model);
            shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index ==> $index');
        MaterialPageRoute pageRoute = MaterialPageRoute(
            builder: (context) => ShowShopFoodMenu(
                  userModel: userModels[index],
                ));
        Navigator.push(context, pageRoute);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${MyConstant().domain}${userModel.urlPicture}'),
              ),
            ),
            MyStyle().mySizeBox(),
            MyStyle().showTitleH2(userModel.nameShop),
          ],
        ),
      ),
    );
  }
}
