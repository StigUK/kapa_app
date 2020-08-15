import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/boot.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/%20ProductViewing/ProductView.dart';
import 'package:kapa_app/View/Widgets/AdItem.dart';

class AllBootsListView extends StatefulWidget {
  @override
  _AllBootsListViewState createState() => _AllBootsListViewState();
}

class _AllBootsListViewState extends State<AllBootsListView> {
  bool loadData = false;
  List<Ad> listAds = List<Ad>();
  List<String> favorites = List<String>();

  @override
  Widget build(BuildContext context) {
    FirestoreService fs = FirestoreService();
    var size = MediaQuery.of(context).size;
    if(!loadData) LoadAdsAndFavorites();
    Boot _boot = Boot(description: "description", modelName: 'ModelName', size: 41, sizeType: 2, price: 100, material: "Шкіра", width: 10, height: 28.5);
    Ad _ad = Ad(userId: "1", images: ["https://picsum.photos/200","https://picsum.photos/200"], boot: _boot);
    return Container(
      height: size.height-80,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    alignment: Alignment.bottomLeft,
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                    ),
                  ),
                ],
              ),
            ),
            loadData ? Container(
              child: listAds.length>0 ? SizedBox(
                height: size.height-139,
                child:  ListView.builder(
                  itemCount: listAds.length,
                  itemBuilder: (BuildContext context, int i)
                  {
                    bool isFavorite = false;
                    favorites.forEach((element) {
                      if(element == listAds[i].key)
                        isFavorite = true;
                    });
                    return Stack(
                      children: [
                        GestureDetector(
                          child: AdItem(listAds[i], size),
                          onTap: (){
                            //print(listAds[i].key);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductView(ad: listAds[i], isFavorite: isFavorite,)));
                          },
                        ),
                        Positioned(
                          top: 20,
                          child: Container(
                            child: FlatButton(
                              onPressed: () {
                                isFavorite ? favorites.remove(listAds[i].key) : favorites.add(listAds[i].key);
                                fs.addNewFavorites(favorites);
                                setState(() {
                                  favorites = favorites;
                                });
                              },
                              child: Icon(Icons.favorite, size: 40, color: isFavorite ? Colors.red : Colors.white,),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ) : Container(
                child: SizedBox(
                  height: size.height-140,
                  child: Center(
                    child: Text("Дошка оголошень пуста :(",style: defaultTextStyle,),
                  ),
                )
              ),
            ) : Container(
              child: SizedBox(
                height: size.height-140,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ),
            //AdItem(_ad, MediaQuery.of(context).size),
          ],
        ),
      ),
    );
  }

  LoadAdsAndFavorites()
  async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _db = Firestore.instance;
    final FirebaseUser user = await _auth.currentUser();
    final List<Ad> listOfAds = List<Ad>();
    final List<String> listFavorites = List<String>();
    await _db.collection("ads").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        listOfAds.add(Ad.fromDocument(f));
      });
      setState(() {
        print("SetState?");
        loadData = true;
        listAds = listOfAds;
      });
    });
    await _db.collection("favorites").document(user.uid).get().then((value)
    {
      value.data.forEach((key, value) => listFavorites.add(value));
      setState(() {
        favorites = listFavorites;
      });
    });
  }
}
