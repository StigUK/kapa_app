import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/LoginPage/Widgets/PictureWithText.dart';
import 'package:kapa_app/View/VerifyPhoneNumber/VerifyNumber.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var size;
  bool phone = true;
  bool codeSend = false;
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          phone = true;
        });
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          height: 0,
        ),
        body: Container(
          height: size.height,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0, size.height * 0.15, 0, size.height * 0.05),
                    child: Image.asset(
                        'assets/images/LoginPage/Shape-18-copy-30.png',
                        height: size.height * 0.3),
                  ),
                  Container(
                    width: size.width * 0.45,
                    height: size.height * 0.2,
                    child: PictureWithText(),
                  ),
                  Container(
                    child: allLoginMethods(),
                  ),
                  //Text(AppLoc.of(context).Login),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: appThemeBackgroundHexColor,
      ),
    );
  }

  Widget allLoginMethods() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              pressLoginWithPhone();
            },
            child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: Image.asset('assets/images/LoginPage/phone.png'),
                )),
          ),
          GestureDetector(
            onTap: () {
              pressLoginWithFacebook();
            },
            child: CircleAvatar(
              radius: 30,
              child: Image.asset('assets/images/LoginPage/facebook.png'),
            ),
          ),
          GestureDetector(
            onTap: () {
              pressLoginWithGoogle();
            },
            child: CircleAvatar(
              radius: 30,
              child: Image.asset('assets/images/LoginPage/google.png'),
            ),
          ),
        ],
      ),
    );
  }

  pressLoginWithGoogle() {
    authService.signInWithGoogle();
  }

  pressLoginWithFacebook() {
    authService.context = context;
    authService.loginWithFacebook();
  }

  pressLoginWithPhone() //If user choice phone login method
  {
    print("Login with phone");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyNumber(isLogin: true)),
    );
  }
}
