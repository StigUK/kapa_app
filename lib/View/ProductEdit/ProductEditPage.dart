import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_picker/flutter_picker.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/View/ProductEdit/ProductImages.dart';
import 'package:kapa_app/View/ProductEdit/ProductSizes.dart';
import 'package:kapa_app/View/Widgets/CustomAppBar.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class ProductEditPage extends StatefulWidget {
  @override
  _ProductEditPageState createState()
  {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appThemeBackgroundHexColor,
      //appBar: customAppBar(),
      appBar: AppBar(
        backgroundColor: appThemeBackgroundHexColor,
        actions: <Widget>[
          FlatButton(
            onPressed: (){},
            child: Text("Зберегти",style: TextStyle(color: Colors.blue),),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              /*Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {  },
                    ),
                    Expanded(child: Container(),),
                    FlatButton(
                      onPressed: (){},
                      child: Text("Зберегти",style: TextStyle(color: Colors.blue),),
                    )
                  ],
                ),
              ),*/
              //Зображення
              TextWithDot("Додати фото"),
              ProductImagesUpdate(),
              //Розміри
              TextWithDot("Розміри"),
              ProductSizes(),
              //Модель
              TextWithDot("Модель"),
              Container(
                width: size.width-20,
                padding: EdgeInsets.only(right: 10, left: 10),
                decoration: decorationForContainerWithBorder_bottom,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Nike 2100", style: defaultTextStyle,),
                ),
              ),
              //Матераіал
              TextWithDot("Матеріал"),
              Container(
                width: size.width-20,
                padding: EdgeInsets.only(right: 10, left: 10),
                decoration: decorationForContainerWithBorder_bottom,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Nike 2100", style: defaultTextStyle,),
                ),
              ),
              //Опис
              TextWithDot("Опис"),
              Container(
                width: size.width-20,
                padding: EdgeInsets.only(right: 10, left: 10),
                decoration: decorationForContainerWithBorder_bottom,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Nike 2100", style: defaultTextStyle,),
                ),
              ),
              //Ціна
              TextWithDot("Ціна"),
              Container(
                width: size.width-20,
                padding: EdgeInsets.only(right: 10, left: 10),
                decoration: decorationForContainerWithBorder_bottom,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Nike 2100", style: defaultTextStyle,),
                ),
              ),
              FlatButton(
                onPressed: (){/*showPickerArray(context);*/},
                child: Text('text'),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*showPickerArray(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(SizeSystem), isArray: true),
        hideHeader: true,
        cancelTextStyle: TextStyle(color: Colors.blue),
        confirmTextStyle: TextStyle(color: Colors.blue),
        //title: new Text("Оберіть систему розміру"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    ).showDialog(context);
  }*/

}
