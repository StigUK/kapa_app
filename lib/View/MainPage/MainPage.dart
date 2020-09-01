import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kapa_app/Core/hexColor.dart';
import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/Widgets/CustomAppBar.dart';
import 'package:kapa_app/View/ProductEdit/ProductEditPage.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  MainPage({this.firebaseUser});
  @override
  State<StatefulWidget> createState() {
    return new MainPageState(firebaseUser: firebaseUser);
  }
}

class MainPageState extends State<MainPage> {
  final FirebaseUser firebaseUser;
  MainPageState({this.firebaseUser});
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: customAppBar(),
      backgroundColor: appThemeBackgroundHexColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(),
        sized: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/MainPage/MainBackground.png"),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      onPressed: () { authService.signOut(); },
                    ),
                    Expanded(child: Container(),),
                  ],
                ),
              ),
              /*Padding(
                padding: EdgeInsets.only(top: 0),
                child: SizedBox(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: (){
                   signOut();
                  },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Text('SignOut', style: TextStyle(color: Colors.white),),
                    padding: EdgeInsets.all(8.0),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 150, 0, 50),
                child:  Image.asset('assets/images/LoginPage/Shape-18-copy-30.png', height: 373.0,),
              ),*/
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(color:  HexColor("#505051"), width: 5),
          color:  HexColor("#505051"),
          shape: BoxShape.circle,
        ),
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductEditPage()),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            // elevation: 5.0,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        //notchMargin: 4.0,
        child: Container(
          height: 65,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.border_all, color: Colors.blue,), onPressed: () {},),
              IconButton(icon: Icon(Icons.filter_drama, color: Colors.blue,), onPressed: () {},),
              IconButton(icon: Icon(Icons.favorite, color: Colors.blue,), onPressed: () {
              },),
              IconButton(icon: Icon(Icons.settings, color: Colors.blue,), onPressed: () {},),
            ],
          ),
        ),
        color: HexColor("#505051"),
      ),
    );
  }

  signOut()
  {
    //AuthService().signOut();
  }
}
