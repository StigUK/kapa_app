import 'package:flutter/material.dart';
import 'package:kapa_app/Resources/colors.dart';

class MySnackBar{
  showSnackBar(context, text)
  {
    SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(text, style: TextStyle(color: defaultTextColor),),
          ),
          FlatButton(
            onPressed: (){
              Scaffold.of(context).hideCurrentSnackBar();
            },
            child: Text("OK", style: TextStyle(color: appThemeBlueMainColor),),
          ),
        ],
      ),
      backgroundColor: appThemeAdditionalHexColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  showPhoneVerifySnackBar(context, onPressFunction()){
    SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text("Спочатку потрібно підтвердити номер телефону", style: TextStyle(color: defaultTextColor)),
          ),
          FlatButton(
            onPressed: (){
              Scaffold.of(context).hideCurrentSnackBar();
              onPressFunction();
            },
            child: Text("Підтвердити", style: TextStyle(color: appThemeBlueMainColor)),
          ),
        ],
      ),
      backgroundColor: appThemeAdditionalHexColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
