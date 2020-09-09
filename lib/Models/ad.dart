import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kapa_app/Models/boot.dart';

class Ad
{
  List<String> images;
  String userId;
  Boot boot;
  bool active;
  String key;

  Ad({this.images, this.userId, this.boot, this.active, this.key});

  Map<String, dynamic> toMap() {
    return {
      "images": images,
      "userId": userId,
      "boot": boot.toMap(),
    };
  }

  factory Ad.fromDocument(DocumentSnapshot doc) {
    Boot boot = Boot();
    boot.sizeType = 2;
    boot.size = doc['boot']['size'];
    boot.width  = doc['boot']['width'];
    boot.height  = doc['boot']['height'];
    boot.material = doc['boot']['material'];
    boot.modelName = doc['boot']['modelName'];
    boot.price = doc['boot']['price'];
    boot.description = doc['boot']['description'];
    return Ad(
        images: List.castFrom(doc['images']) ?? [''],
        userId: doc['userId'].toString() ?? '0',
        boot: boot,
        active: doc['active'],
        key: doc.documentID
    );
  }
}