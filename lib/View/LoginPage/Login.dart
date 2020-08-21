import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Core/TextAreaValidator.dart';
import 'package:kapa_app/Core/hexColor.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/View/LoginPage/Widgets/PictureWithText.dart';
import 'package:kapa_app/View/Widgets/CustomAppBar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var size;
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
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async{
        setState(() {
         phone = true;
        });
        return false;
      },
        child: Scaffold(
          resizeToAvoidBottomInset : true,
          bottomNavigationBar: Container(
            height: 0,
          ),
          body:Container(
            height: size.height,
            child: Center(
              child: SingleChildScrollView (
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, size.height*0.15, 0, size.height*0.05),
                      child:  Image.asset('assets/images/LoginPage/Shape-18-copy-30.png', height: size.height*0.3),
                    ),
                    Container(
                      width: size.width*0.45,
                      height: size.height*0.2,
                      child: PictureWithText(),
                    ),
                    Container(
                      child: phone ? all_LoginMethods() : LoginWithPhone(),
                    ),
                    //Text(AppLoc.of(context).Login),
                  ],
                ),
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
    return Container(
      padding: EdgeInsets.only(bottom: 1),
      child: Form(
        key: _key,
        autovalidate: _validate,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Column(
            children: <Widget>[
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
                keyboardType: TextInputType.number,
              ) :
              TextFormField(
                style: TextStyle(color: defaultTextColor, decorationColor: defaultTextColor),
                controller: phoneTEC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Номер телефону',
                    labelStyle: TextStyle(color: defaultTextColor)
                ),
                validator: (String value) {
                  return validateMobile(value);
                },
                keyboardType: TextInputType.phone,
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: SizedBox(
                    height: size.height * 0.05,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(onPressed: (){
                      // ignore: unnecessary_statements
                      print("CODE SEND? "+codeSend.toString());
                      codeSend ? loginWithOTP() : sendSMScode();
                    }, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Text('Верифікувати', style: TextStyle(color: Colors.white)),
                    padding: EdgeInsets.all(8.0),
                    color: appThemeBlueMainColor,
                  ),
                ),
              ),
            ],
          ),
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
      codeSend = false;
      phone = false;
    });
  }

  loginWithOTP(){
    print("Send code: "+codeTEC.text);
    authService.signInWithOTP(codeTEC.text, verificationID);
  }

  sendSMScode() //Send SMS code on press button verify
  {
    if(_key.currentState.validate())
    {
      authService.verifyPhone(phoneTEC.text);
      setState(() {
        codeSend  = true;
      });
    }
    else
      setState(() {
        _validate = true;
      });
  }
}
