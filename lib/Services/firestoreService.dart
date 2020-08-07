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
   await _db.collection('ads').add(
       {
         'ad': '45'
       }
   );
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