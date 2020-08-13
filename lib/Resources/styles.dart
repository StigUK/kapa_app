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

const smallTextStyle = TextStyle(
  color: defaultTextColor,
  fontSize: 12,
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