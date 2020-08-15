import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapa_app/Core/TextAreaValidator.dart';
import 'package:kapa_app/Models/userinfo.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/MainPage/MainPage.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class AccountInfoEdit extends StatefulWidget {


  String image;
  String name;
  String number;
  String city;
  AccountInfoEdit({this.name, this.image, this.number, this.city});

  @override
  _AccountInfoEditState createState()
  {
    return _AccountInfoEditState(name: name, city: city, image: image, number: number);
  }
}

class _AccountInfoEditState extends State<AccountInfoEdit> {
  _AccountInfoEditState({this.name, this.image, this.number, this.city});
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;

  TextEditingController nameTEC = TextEditingController();
  TextEditingController cityTEC = TextEditingController();
  TextEditingController numberTEC = TextEditingController();

  FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String image;
  String name;
  String number;
  String city;

  var size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    initializingData();
    return Scaffold(
      backgroundColor: appThemeBackgroundHexColor,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(5),
        child:  Column(
          children: [
            //Image and name
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: image !=null ? NetworkImage(image) : AssetImage("assets/images/MainPage/anonymous-user.png"),
                      ),
                      CircleAvatar(
                          child: FlatButton(
                            onPressed: (){
                              uploadPic();
                            },
                            child: Container(),
                          ),
                          backgroundImage: AssetImage("assets/images/ProductEditPage/Photo.png"),
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child:  Text("Змінити фото", style: defaultTextStyle),
                  ),
                ),
              ],
            ),
            dataInputForm(),
          ],
        ),
      ),
    );
  }

  Widget dataInputForm()
  {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _key,
        autovalidate: _validate,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: TextFormField(
                style: TextStyle(color: defaultTextColor, decorationColor: defaultTextColor),
                controller: nameTEC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Ім'я",
                    labelStyle: TextStyle(color: defaultTextColor)
                ),
                validator: (String value)
                {
                  return validateTextArea(value);
                },
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: TextFormField(
                style: TextStyle(color: defaultTextColor, decorationColor: defaultTextColor),
                controller: numberTEC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Номер телефону",
                    labelStyle: TextStyle(color: defaultTextColor)
                ),
                validator: (String value)
                {
                  return validateMobile(value);
                },
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: TextFormField(
                style: TextStyle(color: defaultTextColor, decorationColor: defaultTextColor),
                controller: cityTEC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Місто",
                    labelStyle: TextStyle(color: defaultTextColor)
                ),
                validator: (String value)
                {
                  return validateTextArea(value);
                },
                keyboardType: TextInputType.name,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(onPressed: (){
                  SendDataToFirestore();
                },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Text('Зберегти', style: defaultTextStyle),
                  padding: EdgeInsets.all(8.0),
                  color: appThemeBlueMainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  initializingData()
  {
    numberTEC.text = number;
    nameTEC.text = name;
    cityTEC.text = city;
  }

  SendDataToFirestore()
  {
    if(_key.currentState.validate())
    {
      FirestoreService fs = FirestoreService();
      UserData userData = UserData(name: nameTEC.text, phoneNumber: numberTEC.text, city: cityTEC.text, image: image);
      fs.setUserInfo(userData);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
    }
    else
      setState(() {
        _validate = true;
      });
  }

  Future<String> uploadPic() async {
    File image;
    final FirebaseUser user = await _auth.currentUser();
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      return null;
    }
    StorageReference reference = _storage.ref().child(image.path.split('/').last);
    String filePath = 'profileImages/${DateTime.now()}.png';
    StorageUploadTask uploadTask = _storage.ref().child(filePath).putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      this.image = url;
      print(url);
    });
  }
}
