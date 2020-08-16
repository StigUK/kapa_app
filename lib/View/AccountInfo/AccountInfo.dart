
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/userinfo.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/AccountInfo/AccountInfoEdit.dart';
import 'package:kapa_app/View/LoginPage/Login.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {

  UserData _userData = UserData();
  var size;
  bool isLoad = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    getUserData();
    return isLoad ? Container(
      padding: EdgeInsets.all(5),
      child:  Column(
        children: [
          //Image and name
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _userData.image!=null ? NetworkImage(_userData.image) : AssetImage("assets/images/MainPage/anonymous-user.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child:  Text(_userData.name, style: bigTextStyle,),
                ),
              ),
              Expanded(child: Container(),),
              FlatButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountInfoEdit(name: _userData.name, city: _userData.city, number: _userData.phoneNumber, image: _userData.image,)),
                  );
                },
                child: Icon(Icons.edit),
              )
            ],
          ),
          //Phone number
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextWithDot("Контактний номер телефону"),
          ),
          Container(
            width: size.width-20,
            padding: EdgeInsets.only(right: 10, left: 10),
            decoration: decorationForContainerWithBorder_bottom,
            child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(_userData.phoneNumber, style: defaultTextStyle,),
            ),
          ),
          //City
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextWithDot("Місто"),
          ),
          Container(
            width: size.width-20,
            padding: EdgeInsets.only(right: 10, left: 10),
            decoration: decorationForContainerWithBorder_bottom,
            child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(_userData.city, style: defaultTextStyle,),
            ),
          ),
          //SignOut
          Container(
            padding: EdgeInsets.only(top: 40, bottom: 5, left: 20, right: 20),
            child: SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(onPressed: (){
                AuthService authService = AuthService();
                authService.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Text('Вийти', style: defaultTextStyle),
                padding: EdgeInsets.all(8.0),
                color: appThemeBlueMainColor,
              ),
            ),
          ),
        ],
      ),
    ) : Container(height: size.height, child: Center(child: CircularProgressIndicator()));
  }
  getUserData()
  async{
    final Firestore _db = Firestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    FirestoreService fs = FirestoreService();
    await _db.collection("userdata").document(user.uid).get().then((value)
    {
      setState(() {
        _userData = UserData(name: value.data['name'], city: value.data['city'],phoneNumber: value.data['phoneNumber'], image: value.data['image'],);
        isLoad = true;
      });
    });
  }
}
