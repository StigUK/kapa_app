import 'package:flutter/material.dart';

class PictureWithText extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
   return DecoratedBox(
     child: Center(child: Text("Вхід", style: Theme.of(context).textTheme.headline4,),),
     position: DecorationPosition.background,
     decoration: BoxDecoration(
       shape: BoxShape.rectangle,
       image: DecorationImage(image: AssetImage("assets/images/LoginPage/Ellipse.png")),
     ),
   );
  }
}