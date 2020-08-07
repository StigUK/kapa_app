import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
//import 'package:flutter_picker/flutter_picker.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/boot.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/ProductEdit/ProductImages.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class ProductEditPage extends StatefulWidget {
  @override
  _ProductEditPageState createState()
  {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {

  var size;
  double bootWidth=0;
  double bootHeight=0;
  double bootSize=33.5;
  int bootSizeType=0;
  String bootDescription="";
  String bootModelName="";
  double bootPrice=0;
  int bootMaterial=0;

  var bootHeightTEC = TextEditingController();
  var bootWidthTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {

    //bootHeightTEC.value = bootHeight.toString() as TextEditingValue;
    //bootHeightTEC = TextEditingController(text: bootHeight.toString());
    //bootWidthTEC = TextEditingController(text: bootWidth.toString());

    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appThemeBackgroundHexColor,
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
              //Зображення
              TextWithDot("Додати фото"),
              ProductImagesUpdate(),
              //Розміри
              TextWithDot("Розміри"),
              bootSizes(),
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
                onPressed: (){
                  FirestoreService fs = FirestoreService();
                  Boot bt = Boot(
                    width: 10,
                    height: 10,
                    size: 11,
                    sizeType: 1,
                    price: 10,
                    material: 1,
                    description: 'Піздаті кроси',
                    modelName: 'Найки хуяйки',
                  );
                  Ad _ad = Ad();
                  _ad.boot = bt;
                  _ad.userId = '1';
                  fs.addNewAdd(_ad);
                },
                child: Text('text'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showErrorText(String error)
  {
    return Container(
    );
  }

  setSizesArray(int sizeType)
  {
    switch(sizeType)
    {
      case 0: {
        return UKSizes;
        break;
      }
      case 1: {
        return EUSizes;
        break;
      }
      case 2: {
        return EUSizes;
        break;
      }
      default: {
        return EUSizes;
      }
    }
  }

  Widget bootSizes()
  {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appThemeAdditionalHexColor,
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Image.asset('assets/images/ProductEditPage/sneaker.png', height: (size.width-20)/2,),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                //Розмір
                Container(
                  padding: EdgeInsets.only(bottom: 5, top: 5),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: appThemeAdditionalSecondHexColor)
                              )
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Розмір", style: defaultTextStyle),
                              ),
                              Container(
                                padding: EdgeInsets.all(0),
                                child: FlatButton(
                                  onPressed: (){
                                    sizePicker(context);
                                  },
                                  child: Text(bootSize.toString(), style: defaultTextStyle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: FlatButton(
                          onPressed: (){
                            sizeTypePicker();
                          },
                          child: Text(SizeType[bootSizeType], style: defaultTextStyle),
                        ),
                      ),
                    ],
                  ),

                ),
                //Довжина
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: appThemeAdditionalSecondHexColor)
                              )
                          ),
                          child: Text("Довжина / см", style: defaultTextStyle),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            hintText: bootHeight.toString(),
                          ),
                          style: defaultTextStyle,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          maxLines: 1,
                          onChanged: (String value)
                          {
                            setState(() {
                              bootHeight = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                ),
                //Ширина
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: appThemeAdditionalSecondHexColor)
                              )
                          ),
                          child: Text("Ширина / см", style: defaultTextStyle),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            hintText: bootWidth.toString(),
                          ),
                          style: defaultTextStyle,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          maxLines: 1,
                          onChanged: (String value)
                          {
                            setState(() {
                              bootWidth = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sizePicker(BuildContext context)
  {
      Picker(
          adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(setSizesArray(bootSizeType)), isArray: true),
          hideHeader: true,
          backgroundColor: appThemeAdditionalSecondHexColor,
          cancelTextStyle: TextStyle(color: Colors.blue),
          confirmTextStyle: TextStyle(color: Colors.blue),
          onConfirm: (Picker picker, List value) {
            setState(() {
              bootSize = double.parse(picker.getSelectedValues()[0]);
            });
          }
      ).showDialog(context);
  }

  sizeTypePicker()
  {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(SizeTypeFull), isArray: true),
        hideHeader: true,
        backgroundColor: appThemeAdditionalSecondHexColor,
        cancelTextStyle: TextStyle(color: Colors.blue),
        confirmTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            bootSizeType = int.parse(value[0].toString());
          });
        }
    ).showDialog(context);
  }
}
