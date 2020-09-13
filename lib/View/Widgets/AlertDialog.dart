import 'package:flutter/material.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';

Widget myAlertDialog({String title, String subtitle, String confirmButtonText, String cancelButtonText, var onConfirm, var onCancel, BuildContext context}){
  return AlertDialog(
    backgroundColor: appThemeAdditionalHexColor,
    title: Container(
      child: Column(
        children: [
          if(title!=null) Text(title, style: defaultTextStyle, textAlign: TextAlign.center,),
          Container(padding: EdgeInsets.symmetric(vertical: 5)),
          if(subtitle!=null) Text(subtitle, style: middleTextStyle, textAlign: TextAlign.left,)
        ],
      ),
    ),
    content: Row(
      mainAxisAlignment: cancelButtonText==null || confirmButtonText==null ? MainAxisAlignment.end : MainAxisAlignment.spaceEvenly,
      children: [
        if(cancelButtonText!=null)
          actionButton(actionFunction: onCancel, text: cancelButtonText),
        if(confirmButtonText!=null)
         actionButton(actionFunction: onConfirm, text: confirmButtonText),
      ],
    ),
  );
}

Widget actionButton({var actionFunction, String text}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50)
    ),
    child: FlatButton(
      onPressed: actionFunction,
      child: Text(text, style: middleTextStyle,),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(7.0),
      color: appThemeBlueMainColor
    ),
  );
}