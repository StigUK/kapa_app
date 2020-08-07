import 'dart:ffi';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/Services/customWebView.dart';
import 'package:kapa_app/View/LoginPage/Login.dart';
import 'package:kapa_app/View/MainPage/MainPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService
{
  String verificationID;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fb_your_client_id = "312374703243246";
  String fb_your_redirect_url = "https://kapa-d04ea.firebaseapp.com/__/auth/handler";
  BuildContext context;

  User _userFromFirebaseUser(FirebaseUser user)
  {
    return user !=null ? User(uid: user.uid) : null;
  }

  Future resetPass(String email)
  async
  {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  handleAuth()
  {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot)
      {
        if(snapshot.hasData){
          return MainPage();
        }
        else
          {
            return LoginScreen();
          }
      },
    );
  }

  signOut()
  {
    _auth.signOut();
  }

  signInWithCredential(AuthCredential authCredential)
  {
    _auth.signInWithCredential(authCredential).then((AuthResult result){
      print(result.user);
    }).catchError((e){
      print(e);
    });
  }

  signInWithOTP(smsCode, verID)
  {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: verID, smsCode: smsCode);
    signInWithCredential(authCredential);
  }

  Future<Void> verifyPhone(number) //async method for connect with google services and send sms to user
  async
  {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential authResult)
    {
      AuthService().signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationFailed = (AuthException authException)
    {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend])
    {
      this.verificationID = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId)
    {
      this.verificationID = verId;
    };
    _auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout
    );
  }

  loginWithFacebook() async{
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
            selectedUrl:
            'https://www.facebook.com/dialog/oauth?client_id=$fb_your_client_id&redirect_uri=$fb_your_redirect_url&response_type=token&scope=email,public_profile,',
          ),
          maintainState: true),
    );
    if (result != null) {
      try {
            final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: result);
            signInWithCredential(facebookAuthCred);
          }
          catch(e)
          {

          }
    }
  }

  /*Future<void> signUpWithFacebook() async{
    try{
      var facebookLogin = FacebookLogin();
      var result = await facebookLogin.logIn(['email']);
      if(result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,

        );
        final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('signed in ' + user.displayName);
        return user;
      }
    }catch(e)
    {
      print(e.message);
    }
  }*/

  /*Future<void> _googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email'
        ],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      return user;
    }catch (e) {
      print(e.message);
    }*/
}