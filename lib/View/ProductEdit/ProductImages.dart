
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kapa_app/Core/Responsive.dart';
import 'package:kapa_app/Core/hexColor.dart';

class ProductImagesUpdate extends StatefulWidget {
  @override
  _ProductImagesUpdateState createState() => _ProductImagesUpdateState();
}

class _ProductImagesUpdateState extends State<ProductImagesUpdate> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeOfContainer = (size.width-50)/4;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: HexColor('#343434'),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: (){},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://picsum.photos/200',
                    height: sizeOfContainer,
                    width: sizeOfContainer,
                  ),
                )
              ),
              GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
              GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://picsum.photos/200',
                      height: sizeOfContainer,
                      width: sizeOfContainer,
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}