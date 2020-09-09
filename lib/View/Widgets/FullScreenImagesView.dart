import 'package:flutter/material.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/View/Widgets/ImagesCarousel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageView extends StatefulWidget {

  final List<String> images;
  FullScreenImageView({this.images});
  @override
  _FullScreenImageViewState createState(){
    return _FullScreenImageViewState(images: images);
  }
}

class _FullScreenImageViewState extends State<FullScreenImageView> {

  _FullScreenImageViewState({this.images});
  List<String> images;
  int currentImageId;
  /*
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: appThemeBackgroundHexColor,
      body: Container(
        child: Center(
          child: imagesCarousel(images, BoxFit.contain, size.height, true),
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeBackgroundHexColor,
      body: Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
              );
            },
            itemCount: images.length,

            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
            backgroundDecoration: BoxDecoration(color: appThemeBackgroundHexColor),
          )
      ),
    );
  }
}
