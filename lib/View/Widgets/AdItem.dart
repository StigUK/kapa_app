import 'package:flutter/material.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';

Widget AdItem(Ad _ad, size)
{
  return Stack(
    children: [
      Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: appThemeAdditionalHexColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        width: size.width,
        child: Row(
          children: [
          //Image
            Container(
              child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(_ad.images.first, width: size.width/3.5, height: size.width/3.5, fit: BoxFit.cover,),
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
                                Text(_ad.boot.size.toString(), style: TextStyle(color: appThemeBlueMainColor, fontSize: 25, fontWeight: FontWeight.bold),),
                                Text(SizeType[_ad.boot.sizeType],style: smallTextStyle,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child:  Column(
                              children: [
                                Text(_ad.boot.height.toString(), style: defaultTextStyle,),
                                Text("Довжина / см", style: smallTextStyle,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
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