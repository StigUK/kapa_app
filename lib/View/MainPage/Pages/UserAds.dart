import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:kapa_app/View/%20ProductViewing/ProductView.dart';
import 'package:kapa_app/View/Widgets/AdItem.dart';
import 'package:kapa_app/View/Widgets/CustomDialog.dart';

class UserAdsPage extends StatefulWidget {
  @override
  _UserAdsPageState createState() => _UserAdsPageState();
}

class _UserAdsPageState extends State<UserAdsPage> {

  bool loadData = false;
  List<Ad> listActiveAds = List<Ad>();
  List<Ad> listArchiveAds = List<Ad>();
  FirestoreService fs = FirestoreService();
  var size;

  @override
  Widget build(BuildContext context) {
      if(!loadData) loadAds();
      size = MediaQuery.of(context).size;
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(color: defaultTextColor),
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TabBar(
                    indicator: BubbleTabIndicator(
                        indicatorColor: appThemeBlueMainColor,
                        indicatorHeight: 40
                    ),
                    tabs: [
                      Tab(child: Container(child: Text("Активні", style: defaultTextStyle))),
                      Tab(child: Container(child: Text("Архів", style: defaultTextStyle))),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height-175,
              child:  TabBarView(children: [activeAds(),archiveAds()]),
            )
          ],
        ),
      );
  }

  Widget activeAds()
  {
    return loadData ? Container(
      child: listActiveAds.length>0 ? Container(
        child: SizedBox(
          height: size.height-84,
          child:  ListView.builder(
            itemCount: listActiveAds.length,
            itemBuilder: (BuildContext context, int i)
            {
              return GestureDetector(
                child: AdItem(listActiveAds[i], size),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductView(ad: listActiveAds[i],isFavorite: false),));
                },
              );
            },
          ),
        ),
      ) : Center(child: Text("У вас поки немає активних оголошень", style: defaultTextStyle, textAlign: TextAlign.center,))
    ) : Center(child: CircularProgressIndicator());
  }

  Widget archiveAds()
  {
    return loadData ? Container(
      child: listArchiveAds.length>0 ? Container(
        child: SizedBox(
          height: size.height-84,
          child:  ListView.builder(
            itemCount: listArchiveAds.length,
            itemBuilder: (BuildContext context, int i)
            {
              return Stack(
                children: [
                GestureDetector(
                  child: AdItem(listArchiveAds[i], size),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductView(ad: listArchiveAds[i],isFavorite: true),));
                  },
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: appThemeAdditionalHexColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      width: size.width*0.35-20,
                      height: size.width*0.05,
                      child: Center(
                        child: Text(
                            "Продано",
                            style: defaultTextStyle
                        ),
                      )
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ) : Center(child: Text("У вас поки немає архівованих оголошень", style: defaultTextStyle, textAlign: TextAlign.center,))
    ) : Center(child: CircularProgressIndicator());
  }

  loadAds()
  async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _db = Firestore.instance;
    final FirebaseUser user = await _auth.currentUser();
    await _db.collection("adsArchive").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Ad tempAd = Ad.fromDocument(f);
        if(user.uid == tempAd.userId)
          listArchiveAds.add(tempAd);
      });
    });
    await _db.collection("ads").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        Ad tempAd = Ad.fromDocument(f);
        if(user.uid == tempAd.userId)
          listActiveAds.add(tempAd);
      });
      setState(() {
        listArchiveAds = listArchiveAds;
        listActiveAds = listActiveAds;
        loadData = true;
      });
    });
  }
}
