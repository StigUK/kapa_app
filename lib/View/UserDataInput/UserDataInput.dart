///
///   If user login and don't have userData (Name, phone number, city)
///   He will be redirected on this page.
///

import 'package:flutter/material.dart';
import 'package:kapa_app/Core/TextAreaValidator.dart';
import 'package:kapa_app/Models/UserData.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/LoginPage/Widgets/PictureWithText.dart';
import 'package:kapa_app/View/MainPage/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataInput extends StatefulWidget {
  @override
  _UserDataInputState createState() => _UserDataInputState();
}

class _UserDataInputState extends State<UserDataInput> {

  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  bool dataLoaded = false;

  TextEditingController nameTEC = TextEditingController();
  TextEditingController cityTEC = TextEditingController();
  TextEditingController numberTEC = TextEditingController();
  String photoURL;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    if(!dataLoaded) getDataFromFirestore();
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child:  Scaffold(
        body: dataLoaded ? SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 100),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 250.0,
                    height: 200.0,
                    child: PictureWithText(),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: dataInputForm(),
                  ),
                ],
              ),
            ),
          ),
        ) : Center(child: CircularProgressIndicator(),),
        backgroundColor: appThemeBackgroundHexColor,
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(onPressed: (){
              sendDataToFirestore();
            },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Text('Готово', style: defaultTextStyle,),
              padding: EdgeInsets.all(8.0),
              color: appThemeBlueMainColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget dataInputForm()
  {
    return Form(
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
        ],
      ),
    );
  }

  getDataFromFirestore() async{
    print("AGAIN");
    print(dataLoaded);
    final FirebaseUser user = await _auth.currentUser();
    print("Number:");
    print(user.phoneNumber);
    print("Name:");
    print(user.displayName);
    print("Number:");
    print(user.isEmailVerified);
    setState(() {
      print("SET STATE");
      numberTEC.text = user.phoneNumber;
      if(user.phoneNumber=="") numberTEC.text = '+380';
      nameTEC.text = user.displayName;
      photoURL = user.photoUrl;
      dataLoaded = true;
      print(dataLoaded);
    });
  }

  sendDataToFirestore()
  {
    if(_key.currentState.validate())
    {
      FirestoreService fs = FirestoreService();
      UserData userData = UserData(name: nameTEC.text, phoneNumber: numberTEC.text, city: cityTEC.text, image: photoURL);
      fs.setUserInfo(userData);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
    }
    else
      setState(() {
        _validate = true;
      });
  }
}