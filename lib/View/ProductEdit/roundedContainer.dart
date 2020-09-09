import 'package:flutter/cupertino.dart';

class RoundedContainer extends StatelessWidget {

  bool loading = true;
  var childWidget;

  RoundedContainer({this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: childWidget,
        )
    );
  }
}
