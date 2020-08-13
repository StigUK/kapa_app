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
              child: Image.network(_ad.images.first, width: size.width/3.5,),
              ),
            ),
            //Boot info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_ad.boot.modelName,style: defaultTextStyle,),
                          Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text("Розміри стопи:", style: smallTextStyle,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        )
      ),
      Padding(
        padding: EdgeInsets.only(left: 13),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: appThemeYellowMainColor
          ),
          child: Text("100 грн",style: defaultTextStyleBlack,),
        ),
      ),
    ],
  );
}