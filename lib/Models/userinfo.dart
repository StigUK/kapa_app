
class UserInfo
{
  String userId;
  String phoneNumber;
  String name;
  String city;
  String image;

  UserInfo({this.userId, this.name, this.city, this.phoneNumber, this.image});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "phoneNumber": phoneNumber,
      "name": name,
      "city": city,
      "image": image
    };
  }
}