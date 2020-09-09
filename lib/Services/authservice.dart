import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kapa_app/Services/customWebView.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/LoginPage/Login.dart';
import 'package:kapa_app/View/MainPage/MainPage.dart';
import 'package:kapa_app/View/Widgets/SnackBar.dart';

class AuthService {
  String verificationID;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreService fs = FirestoreService();
  String fbYourClientId = "312374703243246";
  String fbYourRedirectUrl = "https://kapa-d04ea.firebaseapp.com/__/auth/handler";
  BuildContext context;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String name;
  String email;
  String imageUrl;
  MySnackBar snackBar = MySnackBar();

  handleAuth() {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        print("AUTH DATA HAS BEEN CHANGED");
        if (snapshot.hasData) {
          return MainPage();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  onUserDataChanged() {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      print("USER DATA HAS BEEN CHANGED!");
    });
  }

  signOut() {
    signOutGoogle();
    _auth.signOut();
  }

  signInWithCredential(AuthCredential authCredential, _context) async {
    final verificationErrorMsg = () {
      snackBar.showSnackBar(_context, "Не вірний код верифікації!");
    };
    final verificationSuccessMsg = () async {
      await fs.onUserPhoneNumberVerify();
      snackBar.showSnackBar(_context, "Номер успішно верифіковано!");
    };

    final goToPopPage = () {
      print("GO TO MAIN PAGE");
      Navigator.pop(_context);
    };
    print("SIGN IN WITH CREDENTIAL");
    final FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      print("USER NOT NULL");
      if (user.phoneNumber != null) {
        user.updatePhoneNumberCredential(authCredential).whenComplete(() {
          verificationSuccessMsg();
          goToPopPage();
        }).catchError((e) {
          verificationErrorMsg();
          print("Error:");
          print(e);
        });
      } else {
        user.linkWithCredential(authCredential).then((AuthResult result) {
          verificationSuccessMsg();
          goToPopPage();
        }).catchError((e) {
          verificationErrorMsg();
          print(e);
        });
      }
    } else {
      print("USER NULL");
      _auth.signInWithCredential(authCredential).then((AuthResult result) {
        print(result.user);
      }).catchError((e) {
        verificationErrorMsg();
        print(e);
      });
    }
  }

  signInWithOTP(smsCode, verID, _context) {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationID, smsCode: smsCode);
    signInWithCredential(authCredential, _context);
  }

  Future<Void> verifyPhone(number,
      _context, isLogin) //async method for connect with google services and send sms to user
  async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) async {
      signInWithCredential(authResult, _context);
      print("Verification Completed");
      if(isLogin)
      await Future.delayed(const Duration(seconds : 1)).then((value){
        Navigator.of(_context).pop();
      });
      return true;
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
      snackBar.showSnackBar(_context, "Сталась помилка при підтвердженні коду");
      return false;
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      print("SMS sent");
      snackBar.showSnackBar(_context, "Код верифікації відправлено!");
      this.verificationID = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationID = verId;
    };
    _auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  loginWithFacebook() async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=$fbYourClientId&redirect_uri=$fbYourRedirectUrl&response_type=token&scope=email,public_profile,',
              ),
          maintainState: true),
    );
    if (result != null) {
      try {
        final facebookAuthCred =
            FacebookAuthProvider.getCredential(accessToken: result);
        signInWithCredential(facebookAuthCred, context);
      } catch (e) {}
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
