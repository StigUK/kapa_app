import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/UserData.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/LoginPage/Login.dart';
import 'package:kapa_app/View/MainPage/Pages/AccountInfo/AccountInfoEdit.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class AccountInfo extends StatefulWidget {

  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  UserData _userData = UserData();
  var size;
  bool isLoad = false;
  bool numberVerified = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if(!isLoad)getUserData();
    return isLoad
        ? Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                //Image and name
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: CircleAvatar(
                        radius: size.width * 0.11,
                        backgroundImage: _userData.image != null
                            ? NetworkImage(_userData.image)
                            : AssetImage(
                                "assets/images/MainPage/anonymous-user.png"),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            _userData.name,
                            style: bigTextStyle,
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountInfoEdit(
                                    name: _userData.name,
                                    city: _userData.city,
                                    number: _userData.phoneNumber,
                                    image: _userData.image,
                                  )),
                        );
                      },
                      child: Icon(Icons.edit),
                    )
                  ],
                ),
                //Phone number
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: textWithDot("Контактний номер телефону"),
                ),
                Container(
                  width: size.width - 20,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      _userData.phoneNumber,
                      style: defaultTextStyle,
                    ),
                  ),
                ),
                !numberVerified ? Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    children: [
                      Text("Номер не підтверджено!", style: TextStyle(color: defaultTextColor, fontSize: 11.0)),
                      FlatButton(
                        onPressed:(){

                        },
                        child: Text("Підтвердити", style: TextStyle(color: appThemeBlueMainColor, fontSize: 11.0)),
                      )
                    ],
                  ),
                ):Container(),
                //City
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: textWithDot("Місто"),
                ),
                Container(
                  width: size.width - 20,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      _userData.city,
                      style: defaultTextStyle,
                    ),
                  ),
                ),
                //SignOut
                Container(
                  padding:
                      EdgeInsets.only(top: 40, bottom: 5, left: 20, right: 20),
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () async {
                        //FirestoreService fs = FirestoreService();
                        //final FirebaseMessaging _messaging = FirebaseMessaging();
                        //await fs.deleteNotificationToken(_messaging.getToken());
                        AuthService authService = AuthService();
                        await authService.signOut();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text('Вийти', style: defaultTextStyle),
                      padding: EdgeInsets.all(8.0),
                      color: appThemeBlueMainColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: size.height,
            child: Center(child: CircularProgressIndicator()));
  }

  getUserData() async {
    final Firestore _db = Firestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    try{
      await _db.collection("userdata").document(user.uid).get().then((value) {
        if (this.mounted)
          setState(() {
            _userData = UserData(
              name: value.data['name'],
              city: value.data['city'],
              phoneNumber: value.data['phoneNumber'],
              image: value.data['image'],
            );
            if(user.phoneNumber == _userData.phoneNumber) {
              numberVerified = true;
            }
            isLoad = true;
          });
      });
    }
    catch(e){
      print(e);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen()),
              (route) => false
      );
    }
  }
}
