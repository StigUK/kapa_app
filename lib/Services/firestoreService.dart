import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/UserData.dart';
import 'package:kapa_app/Services/messagingService.dart';

class FirestoreService {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreService();

  List<String> favorites = List<String>();

  addNewAd(Ad _ad) async {
    await _db.collection('ads').add(_ad.toMap());
    print("Added new document");
  }

  editAd(Ad _ad) async {
    print("EDIT document, id: ");
    print(_ad.key);
    await _db.collection('ads').document(_ad.key).setData(_ad.toMap());
  }

  addAdToArchive(Ad _ad) async {
    final FirebaseUser user = await _auth.currentUser();
    if (user.uid == _ad.userId) {
      await _db.collection('adsArchive').add(_ad.toMap());
      await _db.collection('ads').document(_ad.key).delete();
    } else
      print("This ad does not belong to the current user");
  }

  addNewFavorites(List<String> adsList) async {
    final FirebaseUser user = await _auth.currentUser();
    await _db
        .collection('favorites')
        .document(user.uid)
        .setData(Map.fromIterable(adsList));
  }

  getData() async {
    final Map<String, Ad> someMap = Map<String, Ad>();
    await _db.collection("ads").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        someMap[f.documentID] = Ad.fromDocument(f);
      });
      return (someMap);
    });
  }

  setUserInfo(UserData userData) async {
    final FirebaseUser user = await _auth.currentUser();
    await _db
        .collection('userdata')
        .document(user.uid)
        .setData(userData.toMap());
  }

  getUserData(String uid) async {
    await _db.collection("userdata").document(uid).get().then((value) {
      /*UserData _userData = UserData(
        name: value.data['name'],
        city: value.data['city'],
        phoneNumber: value.data['phoneNumber'],
        image: value.data['image'],
      );*/
    });
  }

  sendNotification(Ad ad) async {
    final FirebaseUser user = await _auth.currentUser();
    String message;
    String userName;
    await _db
        .collection("userdata")
        .document(user.uid)
        .get()
        .then((currentUserInfo) {
      userName = currentUserInfo.data['name'];
      _db.collection("userToken").document(ad.userId).get().then((userTokens) {
        if (userTokens.data != null) {
          message = "Користувачу " +userName+" сподобалось ваше оголошення";
          userTokens.data.forEach((key, token) {
            print("Send Message to:");
            print(token);
            print(message);
            MessagingService.sendFcmMessage(ad.boot.modelName, message, token);
          });
        }
      });
    });
  }

  setUserNotificationToken(String token) async {
    final FirebaseUser user = await _auth.currentUser();
    List<String> currentUserTokens = List<String>();
    currentUserTokens.add(token);
    await _db.collection('userToken').document(user.uid).get().then((value) {
      if (value.data != null)
        value.data.forEach((key, value) {
          if (value != token) currentUserTokens.add(value);
        });
      _db
          .collection('userToken')
          .document(user.uid)
          .setData(Map.fromIterable(currentUserTokens));
    });
  }

  deleteNotificationToken(thisDeviceToken) async {
    final FirebaseUser user = await _auth.currentUser();
    await _db.collection("userToken").document(user.uid).get().then((userTokens) {
      if (userTokens.data != null) {
          userTokens.data.remove(thisDeviceToken);
          _db.collection('userToken').document(user.uid).setData(userTokens.data);
      }
    });
  }

  getUserNotificationTokens(String uid) async {
    List<String> tokens = List<String>();
    await _db.collection('userToken').document(uid).get().then((value) {
      if (value.data != null)
        value.data.forEach((key, value) {
          tokens.add(value);
        });
      print("Tokens: ");
      print(tokens);
      return tokens;
    });
  }

  onUserPhoneNumberVerify() async {
    final FirebaseUser user = await _auth.currentUser();
    await _db.collection("userdata").document(user.uid).get().then((value) {
      print("Change user number. New: " + user.phoneNumber);
      UserData _userData = UserData(
          name: value.data['name'],
          city: value.data['city'],
          image: value.data['image']);
      _userData.phoneNumber = user.phoneNumber;
      _db.collection("userdata").document(user.uid).setData(_userData.toMap());
    });
  }
}
