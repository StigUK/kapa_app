import 'package:flutter/material.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/boot.dart';
import 'package:kapa_app/View/Widgets/AdItem.dart';

class AllBootsListView extends StatefulWidget {
  @override
  _AllBootsListViewState createState() => _AllBootsListViewState();
}

class _AllBootsListViewState extends State<AllBootsListView> {
  @override
  Widget build(BuildContext context) {
    Boot _boot = Boot(description: "description", modelName: 'ModelName', size: 41, sizeType: 2, price: 100);
    Ad _ad = Ad(userId: "1", images: ["https://picsum.photos/200","https://picsum.photos/200"], boot: _boot);
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                IconButton(
                  alignment: Alignment.bottomLeft,
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                  ),
                ),
              ],
            ),
          ),
          AdItem(_ad, MediaQuery.of(context).size),
        ],
      ),
    );
  }
}
