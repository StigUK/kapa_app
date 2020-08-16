import 'package:flutter/material.dart';
import 'package:kapa_app/Core/hexColor.dart';

import 'colors.dart';

const defaultTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 20,
);

const defaultTextStyleBlack = TextStyle(
  color: Colors.black,
  fontSize: 20,
);

const bigTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 30,
);

const smallTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 13,
);

const smallTextStyleGray = TextStyle(
  color: defaultGrayTextColor,
  fontSize: 13,
);

const dialogTitleTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 25,
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