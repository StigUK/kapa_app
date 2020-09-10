import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:kapa_app/View/MainPage/MainPage.dart';
import 'package:kapa_app/View/ProductEdit/roundedContainer.dart';
import 'package:kapa_app/View/Widgets/SnackBar.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class ProductEditPage extends StatefulWidget {
  final Ad ad;
  ProductEditPage({this.ad});
  @override
  _ProductEditPageState createState() {
    return _ProductEditPageState(ad: ad);
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  _ProductEditPageState({this.ad});
  var size;
  //Boots temp Data
  double bootWidth = 0;
  double bootHeight = 0;
  double bootSize = 33.5;
  int bootSizeType = 0;
  String bootDescription = "";
  String bootModelName = "Other";
  double bootPrice = 0;
  String bootMaterial = "Шкіра";
  List<String> images = [];

  FirebaseStorage _storage = FirebaseStorage.instance;

  Ad ad;
  bool initialized = false;

  var descriptionTEC;
  var sizeOfContainer;

  MySnackBar snackBar = MySnackBar();

  String error = "";

  BuildContext _context;

  String uniqueAd = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    if (!initialized) initializeFields();
    descriptionTEC = TextEditingController(text: bootDescription);
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appThemeBackgroundHexColor,
      appBar: AppBar(
        backgroundColor: appThemeBackgroundHexColor,
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (checkFields() == true) {
                  showDialog(
                      context: _context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: appThemeAdditionalHexColor,
                          title: Container(
                              padding: EdgeInsets.all(20),
                              child: Text("Зберегти зміни?",
                                  style: dialogTitleTextStyle,
                                  textAlign: TextAlign.center)),
                          content: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width * 0.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: FlatButton(
                                    child: Text('Ні', style: defaultTextStyle),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    padding: EdgeInsets.all(8.0),
                                    color: appThemeBlueMainColor,
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.2,
                                  child: FlatButton(
                                    child: Text(
                                      'Так',
                                      style: defaultTextStyle,
                                    ),
                                    onPressed: () {
                                      uploadAdd();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainPage()));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    padding: EdgeInsets.all(8.0),
                                    color: appThemeBlueMainColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                  setState(() {
                    error = "";
                  });
                }
              },
              child: Text("Зберегти",
                  style: TextStyle(color: appThemeBlueMainColor)))
        ],
      ),
      body: scaffoldBody(),
    );
  }

  setSizesArray(int sizeType) {
    switch (sizeType) {
      case 0:
        {
          return UKSizes;
        }
      case 1:
        {
          return EUSizes;
        }
      case 2:
        {
          return EUSizes;
        }
      default:
        {
          return EUSizes;
        }
    }
  }

  Widget scaffoldBody(){
    return Builder(
      builder: (BuildContext buildContext){
        _context = buildContext;
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                //Зображення
                textWithDot("Додати фото"),
                gridImages(),
                //Розміри
                textWithDot("Розміри"),
                bootSizes(),
                //Модель
                textWithDot("Модель"),
                Container(
                  width: size.width - 20,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: InkWell(
                    onTap: () {
                      universalPicker(1, ModelsNames);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bootModelName,
                          style: defaultTextStyle, textAlign: TextAlign.start),
                    ),
                  ),
                ),
                //Матераіал
                textWithDot("Матеріал"),
                Container(
                  width: size.width - 20,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: InkWell(
                    onTap: () {
                      universalPicker(2, BootMaterial);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bootMaterial,
                          style: defaultTextStyle, textAlign: TextAlign.start),
                    ),
                  ),
                ),
                //Опис
                textWithDot("Опис"),
                Container(
                  width: size.width - 20,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: descriptionTEC,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        bootDescription = value;
                      },
                      maxLength: 300,
                      maxLines: 5,
                    ),
                  ),
                ),
                //Ціна
                textWithDot("Ціна"),
                Container(
                    width: size.width - 20,
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: decorationForContainerWithBorder_bottom,
                    child: TextField(
                      //controller: priceTEC,
                      onChanged: (value) {
                        if (value != "")
                          bootPrice = double.parse(value);
                        else
                          bootPrice = 0.0;
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
                    )),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bootSizes() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appThemeAdditionalHexColor,
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Image.asset('assets/images/ProductEditPage/sneaker.png',
                width: (size.width * 0.2)),
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
                                  right: BorderSide(
                                      color:
                                          appThemeAdditionalSecondHexColor))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Розмір", style: defaultTextStyle),
                              ),
                              Container(
                                padding: EdgeInsets.all(0),
                                child: FlatButton(
                                  onPressed: () {
                                    sizePicker(_context);
                                  },
                                  child: Text(bootSize.toString(),
                                      style: defaultTextStyle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 70,
                        child: FlatButton(
                          onPressed: () {
                            universalPicker(0, SizeTypeFull);
                          },
                          child: Text(SizeType[bootSizeType],
                              style: defaultTextStyle),
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
                                  right: BorderSide(
                                      color:
                                          appThemeAdditionalSecondHexColor))),
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
                          onChanged: (String value) {
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
                                  right: BorderSide(
                                      color:
                                          appThemeAdditionalSecondHexColor))),
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
                          onChanged: (String value) {
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

  Widget gridImages() {
    try {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: appThemeAdditionalHexColor,
        ),
        child: SizedBox(
          height: images.length >= 4 ? (size.width) / 2 : (size.width) / 4,
          child: GridView.count(
            crossAxisCount: 4,
            scrollDirection: Axis.vertical,
            children: images.length == 8
                ? List.generate(images.length, (index) {
                    return stackImage(index);
                  })
                : List.generate(images.length + 1, (index) {
                    if (images.length == 8) {
                      print(images.length);
                      if (images.length > index)
                        return stackImage(index);
                      else
                        return Container();
                    } else {
                      if (index < images.length) {
                        return stackImage(index);
                      } else
                        return RoundedContainer(
                            childWidget: FlatButton(
                          onPressed: () {
                            uploadPic();
                          },
                          child: Image.asset(
                              'assets/images/ProductEditPage/Photo.png'),
                        ));
                    }
                  }),
          ),
        ),
      );
    } catch (e) {
      print(e);
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget stackImage(int index) {
    if (images[index] != null)
      return Stack(
        alignment: Alignment.center,
        children: [
          RoundedContainer(childWidget: Image.network(images[index])),
          FlatButton(
            onPressed: () {
              images.removeAt(index);
              setState(() {
                images = images;
              });
            },
            child: Image.asset("assets/images/ProductEditPage/close.png",
                width: 40),
          )
        ],
      );
    else
      return Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      );
  }

  sizePicker(BuildContext buildContext) {
    Picker(
        cancelText: "Відміна",
        confirmText: "Застосувати",
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(setSizesArray(bootSizeType)),
            isArray: true),
        hideHeader: true,
        backgroundColor: appThemePickerBackgroundColor,
        containerColor: appThemePickerBackgroundColor,
        textStyle: defaultTextStyle,
        cancelTextStyle: TextStyle(color: appThemeBlueMainColor),
        selectedTextStyle: defaultTextStyle,
        confirmTextStyle: TextStyle(color: appThemeBlueMainColor),
        onConfirm: (Picker picker, List value) {
          setState(() {
            bootSize = double.parse(picker.getSelectedValues()[0]);
          });
        }).showDialog(_context);
  }

  universalPicker(returnVarialble, pickerData) {
    Picker(
        cancelText: "Відміна",
        confirmText: "Застосувати",
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(pickerData), isArray: true),
        hideHeader: true,
        backgroundColor: appThemePickerBackgroundColor,
        containerColor: appThemePickerBackgroundColor,
        textStyle: defaultTextStyle,
        cancelTextStyle: TextStyle(color: appThemeBlueMainColor),
        selectedTextStyle: defaultTextStyle,
        confirmTextStyle: TextStyle(color: appThemeBlueMainColor),
        onConfirm: (Picker picker, List value) {
          setState(() {
            switch (returnVarialble) {
              case 0:
                {
                  bootSizeType = int.parse(value[0].toString());
                  break;
                }
              case 1:
                {
                  bootModelName = picker.getSelectedValues()[0];
                  break;
                }
              case 2:
                {
                  bootMaterial = picker.getSelectedValues()[0];
                  break;
                }
            }
          });
        }).showDialog(_context);
  }

  bool checkFields() {
    print("Height: " +
        bootHeight.toString() +
        "   " +
        "Width: " +
        bootWidth.toString() +
        "   " +
        "Desc: " +
        bootDescription.toString());
    print("Images Length: " + images.length.toString());
    if (images.length < 1) {
      setState(() {
        error = "Додайте хоча б одне фото";
      });
      showSnackBar();
      return false;
    }
    print("Elements: ");
    for (final i in images) {
      if (i == null) {
        setState(() {
          error = "Зачекайте доки зображення завантажиться";
        });
        showSnackBar();
        return false;
      }
    }
    print("____FIELDS_____");
    if ((bootHeight == 0.0) || (bootWidth == 0.0) || (bootDescription == "")) {
      setState(() {
        error = "Заповніть всі поля";
      });
      showSnackBar();
      return false;
    }
    setState(() {
      error = "";
    });
    return true;
  }

  Widget showErrorText(String error) {
    return Container(
        child: Center(
      child: Text(
        error,
        style: TextStyle(color: Colors.red),
      ),
    ));
  }

  uploadAdd() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    FirestoreService fs = FirestoreService();
    Boot bt = Boot(
      width: bootWidth,
      height: bootHeight,
      size: bootSize,
      sizeType: bootSizeType,
      price: bootPrice,
      material: bootMaterial,
      description: bootDescription,
      modelName: bootModelName,
    );
    Ad _ad = Ad(images: images, boot: bt, userId: user.uid, active: true);
    if(ad==null)
      fs.addNewAd(_ad);
    else
      {
        _ad.key = ad.key;
        fs.editAd(_ad);
      }
  }

  initializeFields() {
    ad != null
        ? setState(() {
            bootDescription = ad.boot.description;
            bootWidth = ad.boot.width;
            bootHeight = ad.boot.height;
            bootSize = ad.boot.size;
            bootSizeType = ad.boot.sizeType;
            bootPrice = ad.boot.price;
            bootMaterial = ad.boot.material;
            bootModelName = ad.boot.modelName;
            images = ad.images;
            initialized = true;
          })
        : setState(() {
            initialized = true;
          });
  }

  Future<void> uploadPic() async {
    File image;
    try {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
    if (image != null) {
      setState(() {
        images.add(null);
      });
      /*StorageReference reference =
          _storage.ref().child(image.path.split('/').last);*/
      String filePath = 'images/$uniqueAd/${DateTime.now()}.png';
      StorageUploadTask uploadTask =
          _storage.ref().child(filePath).putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        images.remove(null);
        images.add(url);
        print(url);
      });
    }
  }

  showSnackBar(){
    snackBar.showSnackBar(_context, error);
  }
}
