import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:kapa_app/Data/PickersData.dart';
import 'package:kapa_app/Models/ad.dart';
import 'package:kapa_app/Models/boot.dart';
import 'package:kapa_app/Resources/colors.dart';
import 'package:kapa_app/Resources/styles.dart';
import 'package:kapa_app/Services/firestoreService.dart';
import 'package:kapa_app/View/%20ProductViewing/ProductView.dart';
import 'package:kapa_app/View/Widgets/AdItem.dart';
import 'package:kapa_app/View/Widgets/TextWithDot.dart';

class AllBootsListView extends StatefulWidget {
  @override
  _AllBootsListViewState createState() => _AllBootsListViewState();
}

class _AllBootsListViewState extends State<AllBootsListView> {
  bool loadData = false;
  List<Ad> fullListAds = List<Ad>();
  List<Ad> listAds = List<Ad>();
  List<String> favorites = List<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  var size;

  bool filterEnable = false;
  Map<String, dynamic> dataFilter = {
    'model': null,
    'material': null,
    'sizeF': null,
    'sizeT': null,
    'sizeType': null,
    'priceF': null,
    'priceT': null,
  };

  ///Values for filter
  bool initialized = false;
  String bootModel;
  String bootMaterial;
  int bootSizeType = 0;
  TextEditingController priceF = TextEditingController();
  TextEditingController priceT = TextEditingController();
  TextEditingController sizeF = TextEditingController();
  TextEditingController sizeT = TextEditingController();

  FirestoreService fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (!loadData) LoadAdsAndFavorites();
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    alignment: Alignment.bottomLeft,
                    icon: Icon(const IconData(0xe900, fontFamily: 'kopa')),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setFilterState) {
                                if (!initialized) {
                                  setFilterState(() {
                                    initializeFilterFields();
                                  });
                                }
                                return Container(
                                  height: 450,
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      TextWithDot("Модель"),
                                      Container(
                                        width: size.width - 20,
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10),
                                        decoration:
                                            decorationForContainerWithBorder_bottom,
                                        child: InkWell(
                                          onTap: () {
                                            Picker(
                                                cancelText: "Відміна",
                                                confirmText: "Застосувати",
                                                adapter: PickerDataAdapter<
                                                        String>(
                                                    pickerdata:
                                                        new JsonDecoder()
                                                            .convert(
                                                                ModelsNames),
                                                    isArray: true),
                                                hideHeader: true,
                                                backgroundColor:
                                                    appThemePickerBackgroundColor,
                                                containerColor:
                                                    appThemePickerBackgroundColor,
                                                textStyle: defaultTextStyle,
                                                cancelTextStyle: TextStyle(
                                                    color:
                                                        appThemeBlueMainColor),
                                                selectedTextStyle:
                                                    defaultTextStyle,
                                                confirmTextStyle: TextStyle(
                                                    color:
                                                        appThemeBlueMainColor),
                                                onConfirm: (Picker picker,
                                                    List value) {
                                                  setFilterState(() {
                                                    bootModel = picker
                                                        .getSelectedValues()
                                                        .first;
                                                  });
                                                }).showDialog(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                bootModel != null
                                                    ? bootModel
                                                    : "",
                                                style: defaultTextStyle,
                                                textAlign: TextAlign.start),
                                          ),
                                        ),
                                      ),
                                      TextWithDot("Матеріал"),
                                      Container(
                                        width: size.width - 20,
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10),
                                        decoration:
                                            decorationForContainerWithBorder_bottom,
                                        child: InkWell(
                                          onTap: () {
                                            Picker(
                                                cancelText: "Відміна",
                                                confirmText: "Застосувати",
                                                adapter: PickerDataAdapter<
                                                        String>(
                                                    pickerdata:
                                                        new JsonDecoder()
                                                            .convert(
                                                                BootMaterial),
                                                    isArray: true),
                                                hideHeader: true,
                                                backgroundColor:
                                                    appThemePickerBackgroundColor,
                                                containerColor:
                                                    appThemePickerBackgroundColor,
                                                textStyle: defaultTextStyle,
                                                cancelTextStyle: TextStyle(
                                                    color:
                                                        appThemeBlueMainColor),
                                                selectedTextStyle:
                                                    defaultTextStyle,
                                                confirmTextStyle: TextStyle(
                                                    color:
                                                        appThemeBlueMainColor),
                                                onConfirm: (Picker picker,
                                                    List value) {
                                                  setFilterState(() {
                                                    bootMaterial = picker
                                                        .getSelectedValues()
                                                        .first;
                                                  });
                                                }).showDialog(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                bootMaterial != null
                                                    ? bootMaterial
                                                    : "",
                                                style: defaultTextStyle,
                                                textAlign: TextAlign.start),
                                          ),
                                        ),
                                      ),
                                      TextWithDot("Розмір"),
                                      Row(
                                        children: [
                                          Container(
                                              width: size.width * 0.3,
                                              padding: EdgeInsets.only(
                                                  right: 20, left: 10),
                                              decoration:
                                                  decorationForContainerWithBorder_bottom,
                                              child: TextField(
                                                controller: sizeF,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 10,
                                                style: defaultTextStyle,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                ),
                                                maxLines: 1,
                                              )),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Container(
                                              width: size.width * 0.3,
                                              padding: EdgeInsets.only(
                                                  right: 20, left: 20),
                                              decoration:
                                                  decorationForContainerWithBorder_bottom,
                                              child: TextField(
                                                controller: sizeT,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 10,
                                                style: defaultTextStyle,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                ),
                                                maxLines: 1,
                                              )),
                                          Container(
                                            width: size.width * 0.15,
                                            child: FlatButton(
                                              onPressed: () {
                                                Picker(
                                                    cancelText: "Відміна",
                                                    confirmText: "Застосувати",
                                                    adapter: PickerDataAdapter<
                                                            String>(
                                                        pickerdata: new JsonDecoder()
                                                            .convert(
                                                                SizeTypeFull),
                                                        isArray: true),
                                                    hideHeader: true,
                                                    backgroundColor:
                                                        appThemePickerBackgroundColor,
                                                    containerColor:
                                                        appThemePickerBackgroundColor,
                                                    textStyle: defaultTextStyle,
                                                    cancelTextStyle: TextStyle(
                                                        color:
                                                            appThemeBlueMainColor),
                                                    selectedTextStyle:
                                                        defaultTextStyle,
                                                    confirmTextStyle: TextStyle(
                                                        color:
                                                            appThemeBlueMainColor),
                                                    onConfirm: (Picker picker,
                                                        List value) {
                                                      setFilterState(() {
                                                        bootSizeType =
                                                            int.parse(value[0]
                                                                .toString());
                                                      });
                                                    }).showDialog(context);
                                              },
                                              child: Text(
                                                  SizeType[bootSizeType],
                                                  style: defaultTextStyle),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextWithDot("Ціна"),
                                      Row(
                                        children: [
                                          Container(
                                              width: size.width * 0.3,
                                              padding: EdgeInsets.only(
                                                  right: 20, left: 10),
                                              decoration:
                                                  decorationForContainerWithBorder_bottom,
                                              child: TextField(
                                                controller: priceF,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 10,
                                                style: defaultTextStyle,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                ),
                                                maxLines: 1,
                                              )),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Container(
                                              width: size.width * 0.3,
                                              padding: EdgeInsets.only(
                                                  right: 20, left: 20),
                                              decoration:
                                                  decorationForContainerWithBorder_bottom,
                                              child: TextField(
                                                controller: priceT,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 10,
                                                style: defaultTextStyle,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                ),
                                                maxLines: 1,
                                              )),
                                        ],
                                      ),

                                      ///Buttons
                                      Padding(
                                        padding: EdgeInsets.only(top: 40),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            FlatButton(
                                              onPressed: () {
                                                setFilterState(() {
                                                  bootModel = null;
                                                  bootMaterial = null;
                                                  bootSizeType = 0;
                                                  priceF =
                                                      TextEditingController();
                                                  priceT =
                                                      TextEditingController();
                                                  sizeF =
                                                      TextEditingController();
                                                  sizeT =
                                                      TextEditingController();
                                                });
                                              },
                                              child: Text("СКИНУТИ",
                                                  style: TextStyle(
                                                      color:
                                                          appThemeBlueMainColor)),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                checkFilterFields();
                                                initialized = false;
                                                setState(() {
                                                  filterEnable = false;
                                                });
                                                enableFilter();
                                                Navigator.pop(context);
                                              },
                                              child: Text("ЗАСТОСУВАТИ",
                                                  style: TextStyle(
                                                      color:
                                                          appThemeBlueMainColor)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          });
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
            loadData
                ? Container(
                    child: listAds.length > 0
                        ? SizedBox(
                            height: size.height,
                            child: ListView.builder(
                              itemCount: listAds.length + 1,
                              itemBuilder: (BuildContext context, int i) {
                                if (i != listAds.length) {
                                  bool isFavorite = false;
                                  favorites.forEach((element) {
                                    if (element == listAds[i].key)
                                      isFavorite = true;
                                  });
                                  return Container(
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          child: AdItem(listAds[i], size),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductView(
                                                          ad: listAds[i],
                                                          isFavorite:
                                                              isFavorite,
                                                          favorites: favorites,
                                                        )));
                                          },
                                        ),
                                        if (listAds[i].userId != user.uid)
                                          Positioned(
                                            top: 20,
                                            child: Container(
                                              child: FlatButton(
                                                onPressed: () {
                                                  if (isFavorite)
                                                    deleteFavorite(listAds[i]);
                                                  else
                                                    addFavorite(listAds[i]);
                                                },
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 40,
                                                  color: isFavorite
                                                      ? Colors.red
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                } else
                                  return Container(
                                    height: 150,
                                  );
                              },
                            ),
                          )
                        : Container(
                            child: SizedBox(
                            height: size.height - 140,
                            child: Center(
                              child: Text(
                                "Дошка оголошень пуста :(",
                                style: defaultTextStyle,
                              ),
                            ),
                          )),
                  )
                : Container(
                    child: SizedBox(
                    height: size.height - 140,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )),
            //AdItem(_ad, MediaQuery.of(context).size),
          ],
        ),
      ),
    );
  }

  LoadAdsAndFavorites() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _db = Firestore.instance;
    user = await _auth.currentUser();
    final List<String> listFavorites = List<String>();
    await _db.collection("ads").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        listAds.add(Ad.fromDocument(f));
        fullListAds.add(Ad.fromDocument(f));
      });
      print("LOADING DATA _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _");
      print("Loaded " + fullListAds.length.toString() + " documents");
      if (this.mounted)
        setState(() {
          user = user;
          loadData = true;
        });
    });
    await _db.collection("favorites").document(user.uid).get().then((value) {
      if (value.data != null) {
        value.data.forEach((key, value) => listFavorites.add(value));
        if (this.mounted)
          setState(() {
            favorites = listFavorites;
          });
      }
    });
  }

  enableFilter() {
    listAds.clear();
    fullListAds.forEach((element) {
      if (filterModel(element) &&
          filterMaterial(element) &&
          filterSize(element) &&
          filterPrice(element)) listAds.add(element);
    });
  }

  bool filterModel(Ad ad) {
    if (dataFilter['model'] != null) {
      if (dataFilter['model'] == ad.boot.modelName)
        return true;
      else
        return false;
    }
    return true;
  }

  bool filterMaterial(Ad ad) {
    if (dataFilter['material'] != null) {
      if (dataFilter['material'] == ad.boot.material)
        return true;
      else
        return false;
    }
    return true;
  }

  bool filterSize(Ad ad) {
    if (dataFilter['sizeF'] != null || dataFilter['sizeT'] != null) {
      double from = dataFilter['sizeF'] == null ? 0.0 : dataFilter['sizeF'];
      if (dataFilter['sizeT'] != null) {
        if (ad.boot.size >= from &&
            ad.boot.size <= dataFilter['sizeT'] &&
            ad.boot.sizeType == dataFilter['sizeType'])
          return true;
        else
          return false;
      } else if (ad.boot.size >= from &&
          ad.boot.sizeType == dataFilter['sizeType'])
        return true;
      else
        return false;
    }
    return true;
  }

  bool filterPrice(Ad ad) {
    if (dataFilter['priceF'] != null || dataFilter['priceT'] != null) {
      double from = dataFilter['priceF'] == null ? 0.0 : dataFilter['priceF'];
      if (dataFilter['priceT'] != null) {
        if (ad.boot.price >= from && ad.boot.price <= dataFilter['priceT'])
          return true;
        else
          return false;
      } else if (ad.boot.price >= from)
        return true;
      else
        return false;
    }
    return true;
  }

  checkFilterFields() {
    try {
      dataFilter['priceF'] = double.parse(priceF.text);
    } catch (e) {
      dataFilter['priceF'] = null;
      print(e);
    }
    try {
      dataFilter['priceT'] = double.parse(priceT.text);
    } catch (e) {
      dataFilter['priceT'] = null;
      print(e);
    }
    try {
      dataFilter['sizeF'] = double.parse(sizeF.text);
    } catch (e) {
      dataFilter['sizeF'] = null;
      print(e);
    }
    try {
      dataFilter['sizeT'] = double.parse(sizeT.text);
    } catch (e) {
      dataFilter['sizeT'] = null;
      print(e);
    }

    ///If price From < price To we switch it
    if ((dataFilter['priceT'] != null) && (dataFilter['priceF'] != null)) {
      if (dataFilter['priceF'] > dataFilter['priceT']) {
        var temp = dataFilter['priceF'];
        dataFilter['priceF'] = dataFilter['priceT'];
        dataFilter['priceT'] = temp;
      }
    }

    ///If size From < size To we switch it
    if ((dataFilter['sizeT'] != null) && (dataFilter['sizeF'] != null)) {
      if (dataFilter['sizeF'] > dataFilter['sizeT']) {
        var temp = dataFilter['priceF'];
        dataFilter['sizeF'] = dataFilter['sizeT'];
        dataFilter['sizeT'] = temp;
      }
    }

    if (bootModel != "")
      dataFilter['model'] = bootModel;
    else
      dataFilter['model'] = null;
    if (bootMaterial != "")
      dataFilter['material'] = bootMaterial;
    else
      dataFilter['material'] = null;
    dataFilter['sizeType'] = bootSizeType;
    initializeFilterFields();
  }

  initializeFilterFields() {
    bootModel = dataFilter['model'];
    bootMaterial = dataFilter['material'];
    bootSizeType = dataFilter['sizeType'] ?? 0;
    sizeF = TextEditingController(
        text:
            dataFilter['sizeF'] != null ? dataFilter['sizeF'].toString() : "");
    sizeT = TextEditingController(
        text:
            dataFilter['sizeT'] != null ? dataFilter['sizeT'].toString() : "");
    priceF = TextEditingController(
        text: dataFilter['priceF'] != null
            ? dataFilter['priceF'].toString()
            : "");
    priceT = TextEditingController(
        text: dataFilter['priceT'] != null
            ? dataFilter['priceT'].toString()
            : "");
    initialized = true;
  }

  addFavorite(Ad ad) {
    fs.sendNotification(ad);
    favorites.add(ad.key);
    fs.addNewFavorites(favorites);
    setState(() {
      favorites = favorites;
    });
  }

  deleteFavorite(Ad ad) {
    favorites.remove(ad.key);
    fs.addNewFavorites(favorites);
    setState(() {
      favorites = favorites;
    });
  }
}
