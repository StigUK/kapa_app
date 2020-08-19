import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/AccountInfo/AccountInfo.dart';
import 'package:kapa_app/View/MainPage/Pages/UserAds.dart';
import 'file:///C:/Users/Administrator/Documents/AndroidStudioPojects/kapa_app/lib/View/MainPage/Pages/AllBootsList.dart';  //WTF?
import 'file:///C:/Users/Administrator/Documents/AndroidStudioPojects/kapa_app/lib/View/MainPage/Pages/Favorites.dart';
import 'package:kapa_app/View/UserDataInput/UserDataInput.dart';
import 'package:kapa_app/View/Widgets/CustomAppBar.dart';
import 'package:kapa_app/View/ProductEdit/ProductEditPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  final Firestore _db = Firestore.instance;
  AuthService authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  FirestoreService fs = FirestoreService();
  final tabs = [
    AllBootsListView(),
    UserAdsPage(),
    Center(child: Text("SecretPage"),),
    FavoritesList(),
    AccountInfo(),
  ];

  bool userDataExis = false;
  int _currentIndex=0;
  int _previousIndex = 0;



  @override
  void initState() {
    super.initState();
    _messaging.getToken().then((value) => fs.setUserNotificationToken(value));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    if (!userDataExis) checkUserDataExist();
    return WillPopScope(
      onWillPop: () async{
        int temp;
        temp = _currentIndex;
        setState(() {
          _currentIndex = _previousIndex;
          _previousIndex = temp;
        });
        return false;
      },
      child: userDataExis ? Scaffold(
          appBar: customAppBar(),
          backgroundColor: appThemeBackgroundHexColor,
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
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
              )
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
                    MaterialPageRoute(builder: (context) => ProductEditPage(ad: null)),
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
                  title: Text(""),
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
                  _previousIndex = _currentIndex;
                  _currentIndex = index;
                });
            },
          )
      ) : Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  checkUserDataExist()
  async {
    final FirebaseUser user = await _auth.currentUser();
    var document = await _db.collection('userdata').document(user.uid).get();
    if(document.data!=null)
      setState(() {
        userDataExis = true;
      });
    else Navigator.push(context, MaterialPageRoute(builder: (context) => UserDataInput()),);
  }
}
