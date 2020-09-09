import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kapa_app/Models/UserData.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/MainPage/Pages/AccountInfo/AccountInfo.dart';
import 'package:kapa_app/View/MainPage/Pages/UserAds.dart';
import 'package:kapa_app/View/MainPage/Pages/AllBootsList.dart';
import 'package:kapa_app/View/MainPage/Pages/Favorites.dart';
import 'package:kapa_app/View/UserDataInput/UserDataInput.dart';
import 'package:kapa_app/View/VerifyPhoneNumber/VerifyNumber.dart';
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
  UserData userData;
  bool phoneNumberVerify = false;

  FirestoreService fs = FirestoreService();
  final tabs = [
    AllBootsListView(),
    UserAdsPage(),
    Center(child: Text("SecretPage"),),
    FavoritesList(),
    AccountInfo(),
  ];

  BuildContext bodyContext;

  bool userDataExist = false;
  int _currentIndex=0;
  int _previousIndex = 0;

  BuildContext globalContext;

  @override
  void initState() {
    super.initState();
    //_messaging.deleteInstanceID();
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
    globalContext = context;
    //checkUserDataExist();
    if(!userDataExist) checkUserDataExist();
    var size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
      child: userDataExist ? Scaffold(
          appBar: customAppBar(),
          backgroundColor: appThemeBackgroundHexColor,
          body: Builder(
            builder: (_context)
            {
              bodyContext = _context;
              return SingleChildScrollView(
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
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/MainPage/Rhombus.png"),
              )
            ),
            width: size.width*0.21,
            height: size.width*0.21,
            child: GestureDetector(
              onTap: (){
                if(phoneNumberVerify)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductEditPage(ad: null)),
                );
                else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          backgroundColor: appThemeAdditionalHexColor,
                          title: Container(padding: EdgeInsets.all(20),child: Text("Спочатку потрібно підтвердити номер телефону", style: dialogTitleTextStyle, textAlign: TextAlign.center)),
                          content: Container(
                            padding: EdgeInsets.only(top:20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width*0.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: FlatButton(
                                    child: Text('Відміна',style: defaultTextStyle,),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    padding: EdgeInsets.all(8.0),
                                    color: appThemeBlueMainColor,
                                  ),
                                ),
                                Container(
                                  width: size.width*0.3,
                                  child: FlatButton(
                                    child: Text('Підтвердити',style: defaultTextStyle,),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      goToVerifyPhone();
                                      checkUserDataExist();
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    padding: EdgeInsets.all(8.0),
                                    color: appThemeBlueMainColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  );
                }
              },
              child: Icon(Icons.add),
            )
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: appThemeBottomAppBarBackground,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(const IconData(0xe901, fontFamily: 'kopa')),
                  title: Container(),
              ),
              BottomNavigationBarItem(icon: Icon(const IconData(0xe902, fontFamily: 'kopa')),
                  title: Container(),
              ),
              BottomNavigationBarItem(icon: Icon(Icons.brightness_1, size: 0),
                  title: Container(),
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
    if (this.mounted){
      FirebaseUser user = await _auth.currentUser();
      await _db.collection("userdata").document(user.uid).get().then((value){
        if(value.data!=null)
        {
          userData = UserData(
            name: value.data['name'],
            city: value.data['city'],
            phoneNumber: value.data['phoneNumber'],
            image: value.data['image'],
          );
          if(this.mounted)
          setState(() {
            if(user.phoneNumber == userData.phoneNumber)
              phoneNumberVerify = true;
            else phoneNumberVerify = false;
            userDataExist = true;
          });
        }
        else {
          Navigator.pushAndRemoveUntil(globalContext, MaterialPageRoute(
              builder: (BuildContext context) => UserDataInput()),
                  (route) => false
          );
        }
      });
    }
  }

  goToVerifyPhone(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyNumber(isLogin: false, number: userData.phoneNumber)),
    );
  }
}
