import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/%20ProductViewing/ProductView.dart';
import 'package:kapa_app/View/Widgets/AdItem.dart';

class FavoritesList extends StatefulWidget {
  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  bool loadData = false;
  List<Ad> listAds = List<Ad>();
  List<String> favorites = List<String>();
  FirestoreService fs = FirestoreService();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (!loadData) loadAdsAndFavorites();
    return Container(
      height: size.height,
      child: SingleChildScrollView(
        child: loadData
            ? Container(
                child: listAds.length > 0
                    ? SizedBox(
                        height: size.height - 84,
                        child: ListView.builder(
                          itemCount: listAds.length + 1,
                          itemBuilder: (BuildContext context, int i) {
                            if (i != listAds.length) {
                              bool isFavorite = false;
                              favorites.forEach((element) {
                                if (element == listAds[i].key)
                                  isFavorite = true;
                              });
                              return Stack(
                                children: [
                                  GestureDetector(
                                    child: adItem(listAds[i], size),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductView(
                                                ad: listAds[i],
                                                isFavorite: isFavorite),
                                          ));
                                    },
                                  ),
                                  Positioned(
                                    top: 20,
                                    child: Container(
                                      child: FlatButton(
                                        onPressed: () {
                                          favorites.remove(listAds[i].key);
                                          listAds.removeAt(i);
                                          fs.addNewFavorites(favorites);
                                          setState(() {
                                            listAds = listAds;
                                            favorites = favorites;
                                          });
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          size: 40,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else
                              return Container(
                                height: 150,
                              );
                          },
                        ),
                      )
                    : Container(
                        child: SizedBox(
                        height: size.height - 100,
                        child: Center(
                          child: Text(
                            "Список улюблених товарів пустий :(",
                            style: defaultTextStyle,
                          ),
                        ),
                      )),
              )
            : Container(
                child: SizedBox(
                height: size.height - 140,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )),
      ),
    );
  }

  loadAdsAndFavorites() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _db = Firestore.instance;
    final FirebaseUser user = await _auth.currentUser();
    final List<Ad> listOfAds = List<Ad>();
    final List<String> listFavorites = List<String>();
    await _db.collection("favorites").document(user.uid).get().then((value) {
      if (this.mounted) {
        if (value.data != null) {
          value.data.forEach((key, value) => listFavorites.add(value));
          setState(() {
            favorites = listFavorites;
          });
        } else
          setState(() {
            loadData = true;
          });
      }
    });
    await _db.collection("ads").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        listFavorites.forEach((element) {
          if (element == Ad.fromDocument(f).key)
            listOfAds.add(Ad.fromDocument(f));
        });
      });
      if (this.mounted)
        setState(() {
          loadData = true;
          listAds = listOfAds;
        });
    });
  }
}
