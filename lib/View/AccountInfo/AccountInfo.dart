
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/userinfo.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {

  UserData _userData = UserData(image: "https://picsum.photos/200", name: "Підор", phoneNumber: "+380970606449", city: "Венеция");
  var size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child:  Column(
        children: [
          //Image and name
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: NetworkImage(_userData.image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child:  Text(_userData.name, style: defaultTextStyle,),
                    ),
                    Text(_userData.city, style: TextStyle(color: Colors.white54),),
                  ],
                ),
              ),
              Expanded(child: Container(),),
              FlatButton(
                onPressed: (){

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
          //SignOut
        ],
      ),
    );
  }
}
