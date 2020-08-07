import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kapa_app/Models/ad.dart';

class FirestoreService
{
  final Firestore _db = Firestore.instance;
  
  getAllAds()
  {
    
  }

  addNewAdd(Ad _ad)
  async {
   await _db.collection('ads').add(_ad.toMap());
  }

  editAdd()
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