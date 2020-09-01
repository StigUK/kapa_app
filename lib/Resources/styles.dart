import 'package:flutter/material.dart';
import 'package:kapa_app/Core/hexColor.dart';

import 'colors.dart';

const defaultTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 18,
);

const defaultTextStyleBlack = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
);

const bigTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 28.0,
);

const smallTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 11.0,
);

const smallTextStyleGray = TextStyle(
  color: defaultGrayTextColor,
  fontSize: 11.0,
);

const dialogTitleTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 23.0,
);

// ignore: non_constant_identifier_names
final decorationForContainerWithBorder_bottom = BoxDecoration(
  border: Border(
    bottom: BorderSide(
      color: appThemeAdditionalSecondHexColor,
    ),
  ),
);
const decorationForContainerWithBorder_left = BoxDecoration(
);