import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Core/TextAreaValidator.dart';
import 'package:kapa_app/Core/hexColor.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/LoginPage/Widgets/PictureWithText.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool phone = true;
  bool codeSend = false;
  bool _validate = false;
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController codeTEC = TextEditingController();
  String verificationID;
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body:SingleChildScrollView (
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 150, 0, 50),
                  child:  Image.asset('assets/images/LoginPage/Shape-18-copy-30.png', height: 373.0,),
                ),
                Container(
                  width: 250.0,
                  height: 200.0,
                  child: PictureWithText(),
                ),
                phone ? all_LoginMethods() : LoginWithPhone(),
                //Text(AppLoc.of(context).Login),
              ],
            ),
          ),
        ),
        backgroundColor: HexColor("#232326"),
      ),
    );
  }

  Widget all_LoginMethods()
  {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: (){pressLoginWithPhone();},
            child: CircleAvatar(
                radius: 30,
                child: ClipOval(child: Image.asset('assets/images/LoginPage/phone.png'),)
            ),
          ),
          GestureDetector(
            onTap: (){pressLoginWithFacebook();},
            child: CircleAvatar(
              radius: 30,
              child: Image.asset('assets/images/LoginPage/facebook.png'),
            ),
          ),
          GestureDetector(
            onTap: (){pressLoginWithGoogle();},
            child: CircleAvatar(
              radius: 30,
              child: Image.asset('assets/images/LoginPage/google.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget LoginWithPhone()
  {
    return Form(
      key: _key,
      autovalidate: _validate,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Colors.white, decorationColor: Colors.white),
              controller: phoneTEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Номер телефону',
                  labelStyle: TextStyle(
                      color: Colors.white)
              ),
              validator: (String value)
              {
                return validateMobile(value);
              },
              onSaved: (String val)
              {

              },
              keyboardType: TextInputType.phone,
            ),
            codeSend ? TextFormField(
              style: TextStyle(color: Colors.white, decorationColor: Colors.white),
              controller: codeTEC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Код підтвердження',
                  labelStyle: TextStyle(
                      color: Colors.white)
              ),
              validator: (String value)
              {
                return validateTextArea(codeTEC.text);
              },
              onSaved: (String val)
              {

              },
              keyboardType: TextInputType.phone,
            ) : Container(),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(onPressed: (){
                  // ignore: unnecessary_statements
                  codeSend ? () {
                    AuthService().signInWithOTP(codeTEC.text, verificationID);
                    setState(() {
                      codeSend = true;
                    });
                  }  : sendSMScode();
                },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Text('Верифікувати', style: TextStyle(color: Colors.white),),
                  padding: EdgeInsets.all(8.0),
                  color: appThemeBlueMainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  pressLoginWithGoogle()
  {
    authService.signInWithGoogle();
  }

  pressLoginWithFacebook()
  {
    authService.context = context;
    authService.loginWithFacebook();
  }

  pressLoginWithPhone() //If user choice phone login method
  {
    print("Login with phone");
    setState(() {
      phone = false;
    });
  }

  sendSMScode() //Send SMS code on press button verify
  {
    if(_key.currentState.validate())
    {
      authService.verifyPhone(phoneTEC.text);
    }
    else
      setState(() {
        _validate = true;
      });
  }
}
