import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

Widget imagesCarousel(List<String> images, BoxFit fit, double height)
{
  List<Widget> imagesList = List<Widget>();
  images.forEach((element) {
    imagesList.add(
        Image.network(element, fit: fit)
    );
  });
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      height: height,
      child: Carousel(
        boxFit: BoxFit.contain,
        images: imagesList,
        autoplay: false,
        indicatorBgPadding: 15.0,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(microseconds: 1000),
        dotSize: 3.0,
        borderRadius:true,
        radius: Radius.circular(20),
      ),
    ),
  );
}