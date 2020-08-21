import 'dart:ffi';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/Services/customWebView.dart';
import 'package:kapa_app/View/LoginPage/Login.dart';
import 'package:kapa_app/View/MainPage/MainPage.dart';

class AuthService
{
  String verificationID;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fb_your_client_id = "312374703243246";
  String fb_your_redirect_url = "https://kapa-d04ea.firebaseapp.com/__/auth/handler";
  BuildContext context;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String name;
  String email;
  String imageUrl;

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

  handleAuth() {
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
    signOutGoogle();
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
    AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: verificationID, smsCode: smsCode);
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


  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl;

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}