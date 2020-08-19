import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/userinfo.dart';
import 'package:kapa_app/Services/authservice.dart';
import 'package:kapa_app/Services/messagingService.dart';

class FirestoreService
{
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreService();

  List<String> favorites = List<String>();

  addNewAd(Ad _ad)
  async {
    await _db.collection('ads').add(_ad.toMap());
  }

  editAd(Ad _ad)
  async{
    await _db.collection('ads').document(_ad.key).setData(_ad.toMap());
  }

  addAdToArchive(Ad _ad)
  async{
    final FirebaseUser user = await _auth.currentUser();
    if(user.uid == _ad.userId)
    {
      await _db.collection('adsArchive').add(_ad.toMap());
      await _db.collection('ads').document(_ad.key).delete();
    }
    else print("This ad does not belong to the current user");
  }

  addNewFavorites(List<String> adsList)
  async {
    final FirebaseUser user = await _auth.currentUser();
    await _db.collection('favorites').document(user.uid).setData(Map.fromIterable(adsList));
  }

  addNewFavoriteProduct(Ad ad, List<String> favoritesList)
  async{
    sendNotification(ad);
    if(favoritesList!=null){
      favoritesList.add(ad.key);
      addNewFavorites(favoritesList);
    }
    else{
      final FirebaseUser user = await _auth.currentUser();
      await _db.collection("favorites").document(user.uid).get().then((value)
      {
        value.data.forEach((key, value) => favorites.add(value));
        favorites.add(ad.key);
        addNewFavorites(favorites);
      });
    }
  }

  removeFavoriteProduct(String productID)
  async{
      getFavoritesList();
      favorites.remove(productID);
      addNewFavorites(favorites);
  }

  getFavoritesList() async{

  }

  getData() async {
    final Map<String, Ad> someMap = Map<String, Ad>();
    await _db.collection("ads").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        someMap[f.documentID] = Ad.fromDocument(f);
      });
      return(someMap);
    });
  }

  setUserInfo(UserData userData)
  async {
    final FirebaseUser user = await _auth.currentUser();
    await _db.collection('userdata').document(user.uid).setData(userData.toMap());
  }

  getUserData(String uid) async{
    await _db.collection("userdata").document(uid).get().then((value)
    {
      UserData _userData = UserData(name: value.data['name'], city: value.data['city'],phoneNumber: value.data['phoneNumber'], image: value.data['image'],);
    });
  }

  Future<bool> checkUserDataExist()
  async {
    final FirebaseUser user = await _auth.currentUser();
    var document = await _db.collection('userdata').document(user.uid).get().then((value)
    {

    }
    );

    if(document.data!=null)
      return true;
    else return false;
  }

  sendNotification(Ad ad) async{
    final FirebaseUser user = await _auth.currentUser();
    String message;
    await _db.collection("userdata").document(user.uid).get().then((currentUserInfo)
    {
      UserData userData = UserData.fromDocument(currentUserInfo);
      _db.collection("userToken").document(ad.userId).get().then((userTokens) {
        if (userTokens.data != null)
        {
          message = "Користувачу ${userData.name} сподобалось ваше оголошення";
          userTokens.data.forEach((key, token) {
            MessagingService.sendFcmMessage(ad.boot.modelName,message,token);
          });
        }
      });
    });
  }
  
  setUserNotificationToken(String token)
  async {
    final FirebaseUser user = await _auth.currentUser();
    List<String> currentUserTokens = List<String>();
    currentUserTokens.add(token);
    await _db.collection('userToken').document(user.uid).get().then((value) {
      if(value.data!=null)
        value.data.forEach((key, value){
          if(value!=token) currentUserTokens.add(value);
        });
      _db.collection('userToken').document(user.uid).setData(Map.fromIterable(currentUserTokens));
    }
    );
  }

  getUserNotificationTokens(String uid)
  async{
    List<String> tokens = List<String>();
    await _db.collection('userToken').document(uid).get().then((value){
      if(value.data!=null)
        value.data.forEach((key, value) {
          tokens.add(value);
        });
      print("Tokens: ");
      print(tokens);
      return tokens;
    });
  }
}