import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/userinfo.dart';
import 'package:kapa_app/Services/authservice.dart';

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

  addNewFavorites(List<String> adsList)
  async {
    final FirebaseUser user = await _auth.currentUser();
    await _db.collection('favorites').document(user.uid).setData(Map.fromIterable(adsList));
  }

  addNewFavoriteProduct(String productID)
  async{
     getFavoritesList();
     favorites.add(productID);
     addNewFavorites(favorites);
  }

  removeFavoriteProduct(String productID)
  async{
    getFavoritesList();
    favorites.remove(productID);
    addNewFavorites(favorites);
  }

  getFavoritesList() async{
      final FirebaseUser user = await _auth.currentUser();
      await _db.collection("favorites").document(user.uid).get().then((value)
      {
        value.data.forEach((key, value) => favorites.add(value));
      });
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
}