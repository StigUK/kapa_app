import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kapa_app/Core/hexColor.dart';
import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/AccountInfo/AccountInfo.dart';
import 'package:kapa_app/View/MainPage/AllBootsList.dart';
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

  final tabs = [
    AllBootsListView(),
    Center(child: Text("My boots"),),
    Center(child: Text("my boobs"),),
    Center(child: Text("fauvorites"),),
    AccountInfo(),
  ];

  int _currentIndex=0;
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
          child: tabs[_currentIndex],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(color:  appThemeBottomAppBarBackground, width: 5),
          shape: BoxShape.circle,
        ),
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: appThemeBlueMainColor,
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appThemeBottomAppBarBackground,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.border_all),
              title: Text("")
          ),
          BottomNavigationBarItem(icon: Icon(Icons.rowing),
              title: Text("")
          ),
          BottomNavigationBarItem(icon: Icon(Icons.brightness_1),
              title: Text("")
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),
              title: Text("")
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings),
              title: Text(""),
          ),
        ],
        onTap: (index){
          if(index!=2)
          setState(() {
            _currentIndex = index;
          });
        },
      )
    );
  }

  signOut()
  {
    //AuthService().signOut();
  }
}
