import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/boot.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/ProductEdit/ImageWidget.dart';
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
  String bootDescription="Some description";
  String bootModelName="Other";
  String bootModelName2="sdas";
  double bootPrice=0;
  String bootMaterial="Шкіра";

  List<String> images;
  FirebaseStorage _storage = FirebaseStorage.instance;
  var descriptionTEC;
  var sizeOfContainer;
  File _image;

  @override
  Widget build(BuildContext context) {
    descriptionTEC = TextEditingController(text: bootDescription);
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appThemeBackgroundHexColor,
      appBar: AppBar(
        backgroundColor: appThemeBackgroundHexColor,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              
            },
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
              ProductImages(),
              //Розміри
              TextWithDot("Розміри"),
              bootSizes(),
              //Модель
              TextWithDot("Модель"),
              Container(
                width: size.width-20,
                padding: EdgeInsets.only(right: 10, left: 10),
                decoration: decorationForContainerWithBorder_bottom,
                child: InkWell(
                  onTap: ()
                  {
                    universalPicker(1,ModelsNames);
                  },
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(bootModelName, style: defaultTextStyle, textAlign: TextAlign.start),
                  ),
                ),
              ),
              //Матераіал
              TextWithDot("Матеріал"),
              Container(
                width: size.width-20,
                padding: EdgeInsets.only(right: 10, left: 10),
                decoration: decorationForContainerWithBorder_bottom,
                child: InkWell(
                  onTap: () {
                    universalPicker(2,BootMaterial);
                    },
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(bootMaterial, style: defaultTextStyle, textAlign: TextAlign.start),
                  ),
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
                  child: TextField(
                    controller: descriptionTEC,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      ),
                    ),
                    onChanged: (value){
                      bootDescription = value;
                    },
                    maxLength: 300,
                    maxLines: 5,
                  ),
                ),
              ),
              //Ціна
              TextWithDot("Ціна"),
              Container(
                width: size.width-20,
                padding: EdgeInsets.only(right: 10, left: 10),
                decoration: decorationForContainerWithBorder_bottom,
                child: TextField(
                    //controller: priceTEC,
                    onChanged: (value){
                      if(value!="")
                      bootPrice = double.parse(value);
                      else bootPrice = 0.0;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: defaultTextStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: "",
                      hintText: bootPrice.toString(),
                    ),
                    maxLines: 1,
                  )
              ),
              FloatingActionButton(
                onPressed: (){
                  //uploadPic();
                },
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
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
                    material: "Матеріал",
                    description: 'Піздаті кроси',
                    modelName: "Nike",
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
            child: Image.asset('assets/images/ProductEditPage/sneaker.png', height: (size.width-20)/2.2),
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
                        width: 70,
                        child: FlatButton(
                          onPressed: (){
                            universalPicker(0, SizeTypeFull);
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

  Widget ProductImages()
  {
    int imLength = 3;
    //imLength==null ? imLength = 0 : imLength = images.length;
    print(imLength);
    sizeOfContainer = (size.width-50)/4;
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: appThemeAdditionalHexColor,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: (){},
                  child: imageWidget(link:'https://picsum.photos/200', sizeOfContainer: sizeOfContainer),
              ),
              imLength<1 ? Container() : GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageWidget(link:'https://picsum.photos/200', sizeOfContainer: sizeOfContainer),
                  )
              ),
              imLength<2 ? Container() : GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageWidget(link:'https://picsum.photos/200', sizeOfContainer: sizeOfContainer),
                  )
              ),
              imLength<3 ? Container() : GestureDetector(
                  onTap: (){
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              imLength<4 ? Container() : GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              imLength<5 ? Container() : GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              imLength<6 ? Container() : GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              imLength<7 ? Container() : GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
            ],
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

  universalPicker(returnVarialble, pickerData)
  {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(pickerData), isArray: true),
        hideHeader: true,
        backgroundColor: appThemeAdditionalSecondHexColor,
        cancelTextStyle: TextStyle(color: Colors.blue),
        confirmTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            switch(returnVarialble)
            {
              case 0:{
                bootSizeType = int.parse(value[0].toString());
                break;
              }
              case 1:{
                bootModelName = picker.getSelectedValues()[0];
                break;
              }
              case 2:{
                bootMaterial = picker.getSelectedValues()[0];
                break;
              }
            }
          });
        }
    ).showDialog(context);
  }

  Widget showErrorText(String error)
  {
    return Container(
    );
  }

  Future<String> uploadPic(File image) async {
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      return null;
    }
    StorageReference reference =
    _storage.ref().child(image.path.split('/').last);
    print("776tyugjhj"+image.path);
    String filePath = 'images/${DateTime.now()}.png';
    StorageUploadTask uploadTask = _storage.ref().child(filePath).putFile(image);
    /*StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    // Waits till the file is uploaded then stores the download url
    String url = await taskSnapshot.ref.getDownloadURL();*/
    //print(url);
  }
}
