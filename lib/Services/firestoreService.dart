import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Services/authservice.dart';

class FirestoreService
{
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreService();

  addNewAd(Ad _ad)
  async {
   await _db.collection('ads').add(_ad.toMap());
  }

  addNewFavorites(List<String> adsList)
  async {
    final FirebaseUser user = await _auth.currentUser();
    await _db.collection('favorites').document(user.uid).setData(Map.fromIterable(adsList));
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

  convertToMap()
  {

  }

  Stream<List<Ad>> fetchAds() {
    var snaps = _db.collection('ads').snapshots();
    return snaps.map((list) => list.documents.map((doc) => Ad.fromDocument(doc)).toList());
  }



  updateAd()
  {

  }

  getMyActiveBoots()
  {

  }

  getMyArchiveBoots()
  {

  }
  
  getUserInfo()
  {

  }
}