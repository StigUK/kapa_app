import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kapa_app/Resources/strings.dart';

class MessagingService{
  static Future<bool> sendFcmMessage(String title, String message, String userKey)
  async{
    try{
      var url = "https://fcm.googleapis.com/fcm/send";
      var header = {
        "Content-Type": "application/json",
        "Authorization":
        "key=$serverKey",
      };
      var request = {
        'notification': {'title': title, 'body': message},
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'COMMENT'
        },
        'to': userKey
      };
      var client = new http.Client();
      var response = await client.post(url, headers: header, body: json.encode(request));
      print("Response Body: "+response.body);
      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }
  }
}