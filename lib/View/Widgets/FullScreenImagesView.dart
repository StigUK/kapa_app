import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kapa_app/View/Widgets/ImagesCarousel.dart';

class FullScreenImageView extends StatefulWidget {

  List<String> images;
  FullScreenImageView({this.images});
  @override
  _FullScreenImageViewState createState(){
    return _FullScreenImageViewState(images: images);
  }
}

class _FullScreenImageViewState extends State<FullScreenImageView> {

  _FullScreenImageViewState({this.images});
  List<String> images;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: imagesCarousel(images, BoxFit.contain, size.height),
        ),
      ),
    );
  }
}
