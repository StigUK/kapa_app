import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/userinfo.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/MainPage/MainPage.dart';
import 'package:kapa_app/View/ProductEdit/ProductEditPage.dart';
import 'package:kapa_app/View/Widgets/FullScreenImagesView.dart';
import 'package:kapa_app/View/Widgets/ImagesCarousel.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductView extends StatefulWidget {

  Ad ad;
  bool isFavorite;
  List<String> favorites;
  ProductView({this.ad, this.isFavorite, this.favorites});
  @override
  _ProductViewState createState()
  {
   return _ProductViewState(ad:ad, isFavorite: isFavorite, favorites: favorites);
  }
}

class _ProductViewState extends State<ProductView> {

  Ad ad;
  bool isFavorite;
  List<String> favorites;
  _ProductViewState({this.ad, this.isFavorite, this.favorites});
  var size;
  UserData _userData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool userDataLoad = false;
  bool isUserAd = false;
  bool isArchive = false;
  FirestoreService fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print(ad.key);
    if(!userDataLoad) getUserData();
    if(!isUserAd) checkIsUserAd();
    if(isUserAd && isFavorite) isArchive = true;
    return WillPopScope(
      onWillPop: (){
        print(Navigator.of(context));
        return Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: appThemeAdditionalHexColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImageView(images: ad.images)));
                      },
                      child:  imagesCarousel(ad.images, BoxFit.cover, size.width),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: appThemeAdditionalHexColor,
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: appThemeYellowMainColor
                              ),
                              child: Text("${ad.boot.price.round()} грн",style: defaultTextStyleBlack,),
                            ),
                            Expanded(child: Container()),
                            if(!isArchive) Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: !isUserAd ? IconButton(
                                icon: Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.white, size: 40,),
                                onPressed: () {
                                  isFavorite ? deleteFavorite() : addFavorite();
                                  setState(() {
                                    isFavorite=!isFavorite;
                                  });
                                },
                              ) :
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditPage(ad: ad)));
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:10),
                          child: Text(ad.boot.modelName,style: bigTextStyle,),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child:  Column(
                                  children: [
                                    Text(ad.boot.size.toString(), style: TextStyle(color: appThemeBlueMainColor, fontSize: 25, fontWeight: FontWeight.bold),),
                                    Text(SizeType[ad.boot.sizeType],style: smallTextStyle,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child:  Column(
                                  children: [
                                    Text(ad.boot.height.toString(), style: defaultTextStyle,),
                                    Text("Довжина / см", style: smallTextStyle,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child:  Column(
                                  children: [
                                    Text(ad.boot.width.toString(), style: defaultTextStyle,),
                                    Text("Ширина / см", style: smallTextStyle,),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              )
                            ],
                          ),
                        ),
                        Text("Матеріал: ${ad.boot.material}", style: smallTextStyleGray,),
                        Padding(
                          padding: EdgeInsets.only(top:10),
                          child: Text(
                            ad.boot.description, style: smallTextStyleGray,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(10),
          height: size.height*0.12,
          child: !isUserAd ? Center(
            child: userDataLoad ? Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    height: size.height*0.12-20,
                    width: size.height*0.12-20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _userData.image!=null ? NetworkImage(_userData.image) : AssetImage("assets/images/MainPage/anonymous-user.png"),
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(_userData.name, style: defaultTextStyle),
                      ),
                      Text(_userData.city, style: smallTextStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  onPressed: (){
                    launch("tel:${_userData.phoneNumber}");
                  },
                )
              ],
            ) : Container(
              child: CircularProgressIndicator()
            ),
          ) : Center(
            child: SizedBox(
              height: 45.0,
              width: MediaQuery.of(context).size.width-40,
              child: !isArchive ? FlatButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        backgroundColor: appThemeAdditionalHexColor,
                        title: Container(padding: EdgeInsets.all(20),child: Text("Ви впевнені, що хочете видалити?", style: dialogTitleTextStyle, textAlign: TextAlign.center)),
                        content: Container(
                          padding: EdgeInsets.only(top:20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width*0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: FlatButton(
                                  child: Text('Ні',style: defaultTextStyle,),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.all(8.0),
                                  color: appThemeBlueMainColor,
                                ),
                              ),
                              Container(
                                width: size.width*0.3,
                                child: FlatButton(
                                  child: Text('Так',style: defaultTextStyle,),
                                  onPressed: () {
                                    fs.addAdToArchive(ad);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.all(8.0),
                                  color: appThemeBlueMainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Text('Видалити оголошення', style: defaultTextStyle),
                padding: EdgeInsets.all(8.0),
                color: appThemeBlueMainColor,
              ) : Container(),
            ),
          ),
        ),
        backgroundColor: appThemeBackgroundHexColor,
      ),
    );
  }

  addFavorite()
  {
    fs.sendNotification(ad);
    favorites.add(ad.key);
    fs.addNewFavorites(favorites);
  }

  deleteFavorite()
  {
    favorites.remove(ad.key);
    fs.addNewFavorites(favorites);
  }

  getUserData()
  async{
    final Firestore _db = Firestore.instance;
    await _db.collection("userdata").document(ad.userId).get().then((value)
    {
      setState(() {
        _userData = UserData(name: value.data['name'], city: value.data['city'],phoneNumber: value.data['phoneNumber'], image: value.data['image'],);
        userDataLoad = true;
      });
    });
  }

  checkIsUserAd()
  async {
    final FirebaseUser user = await _auth.currentUser();
    if(ad.userId == user.uid)
      {
        setState(() {
          print("RELOAD");
          isUserAd = true;
        });
      }
  }
}