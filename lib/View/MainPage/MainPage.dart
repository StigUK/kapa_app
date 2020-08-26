import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/AccountInfo/AccountInfo.dart';
import 'package:kapa_app/View/MainPage/Pages/UserAds.dart';
import 'package:kapa_app/View/MainPage/Pages/AllBootsList.dart';
import 'package:kapa_app/View/MainPage/Pages/Favorites.dart';
import 'package:kapa_app/View/UserDataInput/UserDataInput.dart';
import 'package:kapa_app/View/Widgets/CustomAppBar.dart';
import 'package:kapa_app/View/ProductEdit/ProductEditPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    _messaging.deleteInstanceID();
    _messaging.getToken().then((value) => fs.setUserNotificationToken(value));
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
              image: DecorationImage(
                image: AssetImage("assets/images/MainPage/Rhombus.png"),
              )
            ),
            width: size.width*0.2,
            height: size.width*0.2,
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductEditPage(ad: null)),
                );
              },
              child: Icon(Icons.add),
            )
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: appThemeBottomAppBarBackground,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.border_all),
                  title: Container(),
              ),
              BottomNavigationBarItem(icon: Icon(Icons.rowing),
                  title: Container(),
              ),
              BottomNavigationBarItem(icon: Icon(Icons.brightness_1),
                  title: Text(""),
              ),
              BottomNavigationBarItem(icon: Icon(Icons.favorite),
                  title: Container(),
              ),
              BottomNavigationBarItem(icon: Icon(Icons.settings),
                title: Container(),
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
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => UserDataInput(),
        ),
            (route) => false,
      );
    }
  }
}
