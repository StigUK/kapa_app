import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/Widgets/CustomAppBar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductView extends StatefulWidget {

  Ad ad;
  bool isFavorite;
  ProductView({this.ad, this.isFavorite});
  @override
  _ProductViewState createState()
  {
   return _ProductViewState(ad:ad, isFavorite: isFavorite);
  }
}

class _ProductViewState extends State<ProductView> {

  Ad ad;
  bool isFavorite;
  _ProductViewState({this.ad, this.isFavorite});
  var size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print(ad.key);
    FirestoreService fs = FirestoreService();
    return Scaffold(
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
                /*Stack(
                children: [
                  imagesCarousel(),
                  Positioned(
                    child: FlatButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),*/
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: imagesCarousel(),
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
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: IconButton(
                              icon: Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.white, size: 40,),
                              onPressed: () {
                                isFavorite ? fs.removeFavoriteProduct(ad.key) : fs.addNewFavoriteProduct(ad.key);
                                setState(() {
                                  isFavorite=!isFavorite;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text(ad.boot.modelName,style: bigTextStyle,),
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
        height: 100,
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(),
              ),
              Column(
                children: [
                  Text("Вася"),
                  Text("Минск")
                ],
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(Icons.call),
                onPressed: (){

                },
              )
            ],
          ),
        )
      ),
      backgroundColor: appThemeBackgroundHexColor,
    );
  }

  Widget imagesCarousel()
  {
    List<Widget> imagesList = List<Widget>();
    ad.images.forEach((element) {
      imagesList.add(
          Image.network(element, fit: BoxFit.cover)
      );
    });
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: 500,
        child: Carousel(
          boxFit: BoxFit.contain,
          images: imagesList,
          autoplay: false,
          indicatorBgPadding: 15.0,
          //dotBgColor: Colors.transparent,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(microseconds: 1000),
          dotSize: 3.0,
          borderRadius:true,
          radius: Radius.circular(20),
        ),
      ),
    );
  }
}
