import 'dart:async';

import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:image/image.dart' as image;
import '../db/ice_creame_db_provider.dart';
import '../models/address.dart';

import '../pages/order_page.dart';

class YandexMAp extends StatefulWidget {
  Address? address;
  Function? callback;
  // LatLng? latLng ;
  YandexMAp({Key? key, this.address, this.callback}) : super(key: key);

  @override
  _YandexMApState createState() => _YandexMApState();
}

class _YandexMApState extends State<YandexMAp> {
  late TextEditingController queryController;
  late TextEditingController apartmentController;
  late YandexMapController yMapController;
  late String street = '';
  Point _point = const Point(latitude: 38.576271, longitude: 68.779716);
  late List<dynamic> searchResults = [];
  final String apikey = 'd2fda3ea-f495-4d7b-aa53-84721de9ed90';
  final String props =
      'results=3&format=json&bbox=67.34296,36.671131~75.137174,41.042239&';
  bool progress = false;
  final MapObjectId placemarkId = const MapObjectId('normal_icon_placemark');
  // ApiHelper api = ApiHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryController = TextEditingController(text: '');
    apartmentController = TextEditingController(
        text: (widget.address != null) ? widget.address!.apartment : '');
  }

  @override
  Widget build(BuildContext context) {
    var getProvider = Provider.of<ProviderProduct>(context);
     void setInProviderAdress(String get)
    {
      getProvider.updateAddress(get);
    }
   
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 500,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Stack(
                children: [
                  YandexMap(
                    onMapCreated:
                        (YandexMapController yandexMapController) async {
                      yMapController = yandexMapController;
                      if (widget.address != null) {
                        _point = Point(
                            latitude: widget.address!.lat,
                            longitude: widget.address!.lon);
                        await yMapController.moveCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: _point, zoom: 17)));
                      } else {
                        await yMapController.moveCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: _point, zoom: 12)));
                      }
                    },
                    onMapTap: (Point point){
                       _point = point;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Center(
                        child: Image.asset(
                      "assets/icons/yandex_marker.png",
                      width: 50,
                      height: 50,
                    )),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        // enableInteractiveSelection: false,
                        validator: (val) =>
                            val!.isEmpty ? "Constants.INPUT_ADDRES" : null,
                        controller: queryController,
                        decoration: const InputDecoration(
                          labelText: "Ваш адресс",
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(width: double.infinity)
                              // borderRadius: BorderRadius.circular(5)
                              ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        controller: apartmentController,
                        decoration: const InputDecoration(
                          labelText: "Апартамент",
                          border: UnderlineInputBorder(
                              // borderRadius: BorderRadius.circular(5)
                              ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //
                      //
                      //
                      // Here is a buttonith style
                      //
                      //
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              _search();
                              if (queryController.text.isNotEmpty) {
                                Timer(
                                    Duration(seconds: 3),
                                    () => showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: searchResults.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    street =
                                                        searchResults[index]
                                                                ['name']
                                                            .toString();
                                                    List<String> coords =
                                                        searchResults[index]
                                                                ['Point']['pos']
                                                            .toString()
                                                            .split(' ');
                                                    setState(() {
                                                      if (widget.address !=
                                                          null) {
                                                        widget.address!.street =
                                                            searchResults[index]
                                                                ['name'];
                                                        widget.address!.lat =
                                                            double.parse(
                                                                coords[1]);
                                                        widget.address!.lon =
                                                            double.parse(
                                                                coords[0]);
                                                      } else {
                                                        widget.address = Address(
                                                            street:
                                                                searchResults[
                                                                        index]
                                                                    ['name'],
                                                            lat: double.parse(
                                                                coords[1]),
                                                            lon: double.parse(
                                                                coords[0]));
                                                      }
                                                    });
                                                    await yMapController.moveCamera(
                                                        CameraUpdate.newCameraPosition(
                                                            CameraPosition(
                                                                target: Point(
                                                                    latitude: widget
                                                                        .address!
                                                                        .lat,
                                                                    longitude: widget
                                                                        .address!
                                                                        .lon),
                                                                zoom: 12)));
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    color: Colors.grey[200],
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          searchResults[index]
                                                                  ['name']
                                                              .toString()
                                                              .toString()
                                                              .trim(),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          searchResults[index][
                                                                  'description']
                                                              .toString()
                                                              .trim(),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content:
                                            Text("Сначала добавьте адресс")));
                                return;
                              }
                            },
                            child: SizedBox(
                              child: Container(
                                height: 50,
                                width: 120,
                                decoration: BoxDecoration(
                                    // boxShadow: const [
                                    //   BoxShadow(
                                    //       offset: Offset(0, 20),
                                    //       blurRadius: 30,
                                    //       color: Colors.black),
                                    // ],
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(22.0)),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 12),
                                      width: 70,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: const Text(
                                        "Search",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      decoration: const BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            topLeft: Radius.circular(50),
                                            bottomRight: Radius.circular(200),
                                          )),
                                    ),
                                    Icon(Icons.search),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // GestureDetector(
                          //     child: Container(
                          //       height: 50,
                          //       width: 100,
                          //       color: Colors.blue,
                          //       child: const Icon(
                          //         Icons.search,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     onTap: _search),
                          ElevatedButton(
                              onPressed: () {
                                if (street.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Address is empty"),
                                    duration: Duration(seconds: 1),
                                  ));
                                  return;
                                }
                                getProvider.updateAddress(street);
                                DbIceCreamHelper.addressApi(street);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderPage()));
                              },
                              child: const Text("Add")),

                          GestureDetector(
                            onTap: () {
                              print(_point);
                              setPoint(_point);

                            },
                            child: SizedBox(
                              child: Container(
                                height: 50,
                                width: 120,
                                decoration: BoxDecoration(
                                    // boxShadow: const [
                                    //   BoxShadow(
                                    //       offset: Offset(0, 20),
                                    //       blurRadius: 30,
                                    //       color: Colors.black),
                                    // ],
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(22.0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.location_on_outlined),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      width: 70,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: const Text(
                                        "SET",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      decoration: const BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(360),
                                              // topLeft: Radius.circular(98),
                                              bottomRight: Radius.circular(50),
                                              topRight: Radius.circular(50))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //     child: Container(
                          //         height: 50,
                          //         width: 100,
                          //         padding: const EdgeInsets.only(
                          //             left: 5, right: 5),
                          //         color: Colors.green,
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //           children: const [
                          //             Icon(
                          //               Icons.location_on_outlined,
                          //               color: Colors.white,
                          //             ),
                          //             SizedBox(
                          //               width: 4,
                          //             ),
                          //             Text(
                          //               "SET",
                          //               style: TextStyle(
                          //                   color: Colors.white,
                          //                   fontSize: 16),
                          //             )
                          //           ],
                          //         )),
                          //     onTap: setPoint)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: street == ""
                            ? const Text("Адресс :")
                            : Text("Адресс : ${street}"),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    
  }
  

  void setPoint(Point pointer) async {
    
    final cameraPosition = await yMapController.getCameraPosition();
   
    if (apartmentController.text == '') {
      EasyLoading.showError('Please set apartment number first!');
      return;
    }
    EasyLoading.show(status: 'SEARCHING');
    // var point = _point;
     final resultWithSession = YandexSearch.searchByPoint(
      point: pointer,
      zoom: cameraPosition.zoom.toInt(),
      searchOptions: SearchOptions(
        searchType: SearchType.geo,
        geometry: false,
      ),
    );
    SearchSessionResult result = await resultWithSession.result;
    print("RESULT FOUND${result.found}");
    print("RESULT ITEMS${result.items!.first.name}");
    if (result.error != null) {
      EasyLoading.dismiss();
      EasyLoading.showError(result.error.toString());
      return;
    }
    EasyLoading.dismiss();
    if (result.found != null) {
      String temp =
          result.items!.first.toponymMetadata!.address.formattedAddress;
      temp = temp.replaceAll('Tajikistan,', '');
      temp = temp.replaceAll('Таджикистан,', '');
      temp = temp.replaceAll('Душанбе,', '');
      temp = temp.replaceAll('Dushanbe,', '');
      temp = temp.trim();
      if (widget.address != null) {
        widget.address!.street = temp;
        widget.address!.lat = pointer.latitude;
        widget.address!.lon = pointer.longitude;
        widget.address!.apartment = apartmentController.text;
      } else {
        widget.address = Address(
            street: temp,
            lat: pointer.latitude,
            lon: pointer.longitude,
            apartment: apartmentController.text);
      }
      // widget.callback!(widget.address);
      Provider.of<ProviderProduct>(context, listen: false).updateAddress(result.items!.first.name);
      DbIceCreamHelper.addressApi(result.items!.first.name);
      Navigator.pop(context);
    }
    print('Page ${result.page}: $result');
  }

  void _search() async {
    if (queryController.text != '') {
      //closing the keyboard while clicking a button--
      FocusManager.instance.primaryFocus?.unfocus();
      //---

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              width: 15,
            ),
            Text("Идет загрузка")
          ],
        ),
        duration: const Duration(seconds: 3),
      ));

      // EasyLoading.showProgress(3, status: 'downloading...');
      // Future.delayed(Duration(seconds: 3), () => showAlert(context));
      try {
        await Dio()
            .get(
                'https://geocode-maps.yandex.ru/1.x/?apikey=$apikey&$props&geocode=' +
                    queryController.text)
            .then((res) async {
          if (res.statusCode == 200) {
            EasyLoading.dismiss();
            var results = res.data['response']['GeoObjectCollection'];
            int len = int.parse(results['metaDataProperty']
                ['GeocoderResponseMetaData']['found']);
            if (len > 0) {
              results = results['featureMember'];
              List<dynamic> temp = [];
              for (int i = 0; i < len; i++) {
                if (results[i]['GeoObject']['metaDataProperty']
                        ['GeocoderMetaData']['Address']['country_code'] ==
                    "TJ") {
                  temp.add(results[i]['GeoObject']);
                }
              }
              setState(() {
                searchResults = temp;
              });
            } else {
              EasyLoading.showError(
                  'No results can be found for this address!');
            }
          } else {
            EasyLoading.dismiss();
            EasyLoading.showError('failed to retrieve data from yandex!');
          }
        });
      } on DioError catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("hi"),
            ));
  }
}
