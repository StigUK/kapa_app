import 'package:cloud_firestore/cloud_firestore.dart';

class UserData
{
  String userId;
  String phoneNumber;
  String name;
  String city;
  String image;

  UserData({this.name, this.city, this.phoneNumber, this.image});

  Map<String, dynamic> toMap() {
    return {
      "phoneNumber": phoneNumber,
      "name": name,
      "city": city,
      "image": image
    };
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
        image: doc['image'] ?? [''],
        name: doc['name'] ?? [''],
        city: doc['city'] ?? [''],
        phoneNumber: doc['phoneNumber'] ?? [''],
    );
  }
}