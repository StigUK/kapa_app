import 'package:kapa_app/Models/User.dart';
import 'package:kapa_app/Models/boot.dart';

class Ad
{
  List<String> images;
  String userId;
  Boot boot;

  Map<String, dynamic> toMap() {
    return {
      "images": images,
      "userId": userId,
      "boot": boot.toMap(),
    };
  }
}