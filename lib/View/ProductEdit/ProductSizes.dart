import 'package:flutter/material.dart';
import 'package:kapa_app/Core/hexColor.dart';
//import 'package:flutter_picker/flutter_picker.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';

class ProductSizes extends StatefulWidget {
  @override
  _ProductSizesState createState() => _ProductSizesState();
}

class _ProductSizesState extends State<ProductSizes> {
  int sizeType = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appThemeAdditionalHexColor,
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Image.asset('assets/images/ProductEditPage/sneaker.png', height: (size.width-20)/2,),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                //Розмір
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  //width: size.width-((size.width-20)/3)-20,
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: appThemeAdditionalSecondHexColor)
                              )
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Розмір", style: defaultTextStyle,),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Text("23", style: defaultTextStyle,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: Text("EU", style: defaultTextStyle,),
                      ),
                    ],
                  ),

                ),
                //Довжина
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  //width: size.width-((size.width-20)/3)-20,
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: appThemeAdditionalSecondHexColor)
                              )
                          ),
                          child: Text("Довжина / см", style: defaultTextStyle),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: Text("38", style: defaultTextStyle,),
                      ),

                    ],
                  ),

                ),
                //Ширина
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  //width: size.width-((size.width-20)/3)-20,
                  decoration: decorationForContainerWithBorder_bottom,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: appThemeAdditionalSecondHexColor)
                              )
                          ),
                          child: Text("Ширина / см", style: defaultTextStyle),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: Text("38", style: defaultTextStyle,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
