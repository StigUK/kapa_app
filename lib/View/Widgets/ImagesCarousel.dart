import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:photo_view/photo_view.dart';

Widget imagesCarousel(List<String> images, BoxFit fit, double height, bool fullScreen)
{
  List<Widget> imagesList = List<Widget>();
  images.forEach((element) {
    imagesList.add(
      fullScreen ? photoZoomView(element) : Image.network(element, fit: fit)
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

Widget photoZoomView(String link){
  return Container(
    child: PhotoView(
      minScale: 0.75,
      backgroundDecoration: BoxDecoration(
        color: appThemeBackgroundHexColor
      ),
      imageProvider: NetworkImage(link),
    ),
  );
}