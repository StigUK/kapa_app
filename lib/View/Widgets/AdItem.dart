import 'package:flutter/material.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';

Widget adItem(Ad _ad, size)
{
  double defaultSize = size.width*0.35;
  return Stack(
    children: [
      Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: appThemeAdditionalHexColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: defaultSize,
        width: size.width,
        child: Row(
          children: [
          //Image
            Container(
              child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(_ad.images.first, width: defaultSize, height: defaultSize, fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                    if (loadingProgress == null) return child;
                    return Container(
                      width: defaultSize,
                      height: defaultSize,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ?
                          loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  }),
              ),
            ),
            //Boot info
            Expanded(
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_ad.boot.modelName,style: defaultTextStyle,),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Розміри стопи:", style: smallTextStyle,),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(size.width*0.008),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.width*0.005),
                              child:  Column(
                                children: [
                                  Text(_ad.boot.size.toString(), style: TextStyle(color: appThemeBlueMainColor, fontSize: 21, fontWeight: FontWeight.bold),),
                                  Text(SizeType[_ad.boot.sizeType],style: smallTextStyle,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.width*0.005),
                              child:  Column(
                                children: [
                                  Text(_ad.boot.height.toString(), style: defaultTextStyle,),
                                  Text("Довжина / см", style: smallTextStyle,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.width*0.005),
                              child:  Column(
                                children: [
                                  Text(_ad.boot.width.toString(), style: defaultTextStyle,),
                                  Text("Ширина / см", style: smallTextStyle,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text("Матеріал: ${_ad.boot.material}", style: smallTextStyleGray,),
                  ],
                ),
              ),
            ),
          ],
        ),
        )
      ),
       Positioned(
          top: 20,
          right: 5,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: appThemeYellowMainColor
            ),
            child: Text("${_ad.boot.price.round()} грн",style: defaultTextStyleBlack,),
        ),
      ),
    ],
  );
}