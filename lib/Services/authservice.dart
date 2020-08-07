import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/View/LoginPage/Login.dart';
import 'package:kapa_app/View/MainPage/MainPage.dart';

class AuthService
{
  String verificationID;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      stream: FirebaseAuth.instance.onAuthStateChanged,
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
    FirebaseAuth.instance.signOut();
  }

  signInWithCredential(AuthCredential authCredential)
  {
    FirebaseAuth.instance.signInWithCredential(authCredential);
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
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout
    );
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