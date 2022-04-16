import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

// import 'package:yandex_mapkit_example/examples/widgets/control_button.dart';
// import 'package:yandex_mapkit_example/examples/widgets/map_page.dart';

import '../db/ice_creame_db_provider.dart';
import '../models/address.dart';
import '../pages/order_page.dart';
import '../provider/provider.dart';
import '../widgets/control_button.dart';
import 'map_page.dart';

class ReverseSearchPage extends MapPage {
  ReverseSearchPage() : super('Reverse search example');

  @override
  Widget build(BuildContext context) {
    return _ReverseSearchExample();
  }
}

class _ReverseSearchExample extends StatefulWidget {
  @override
  _ReverseSearchExampleState createState() => _ReverseSearchExampleState();
}

class _ReverseSearchExampleState extends State<_ReverseSearchExample> {
  late String street = '';
  final List<SearchSessionResult> results = [];
  Address? address;
  final String apikey = 'd2fda3ea-f495-4d7b-aa53-84721de9ed90';
  final String props =
      'results=3&format=json&bbox=67.34296,36.671131~75.137174,41.042239&';
  bool _progress = true;

  late List<dynamic> searchResults = [];
  late TextEditingController queryController;
  late TextEditingController apartmentController;
  late SearchResultWithSession resultWithSession;
  // final TextEditingController queryController = TextEditingController();
  late YandexMapController controller;

  Point _point = const Point(latitude: 38.576271, longitude: 68.779716);
  late final List<MapObject> mapObjects = [
    Placemark(
      mapId: cameraMapObjectId,
      point: const Point(latitude: 38.576271, longitude: 68.779716),
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image:
              BitmapDescriptor.fromAssetImage('assets/icons/yandex_marker.png'),
          scale: 0.30)),
      opacity: 1,
    )
  ];
  @override
  void initState() {
    // TODO: implement initState
    queryController = TextEditingController(text: '');
    apartmentController = TextEditingController(
        text: (address != null) ? address!.apartment : '');
  }

  final MapObjectId cameraMapObjectId = const MapObjectId('camera_placemark');

  @override
  Widget build(BuildContext context) {
    final mapHeight = 300.0;
    var getProvider = Provider.of<ProviderProduct>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          if (apartmentController.text.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            _setPoint();
            print(_point);
          } else {
            FocusManager.instance.primaryFocus?.unfocus();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Добавьте номер квартиры")));
          }
        },
        child: const Icon(
          Icons.location_on_outlined,
          color: Colors.black,
        ),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (street.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Введите свой адресс"),
                    duration: Duration(seconds: 1),
                  ));
                  return;
                }
                if (street.isNotEmpty && apartmentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Введите номер квартиры"),
                    duration: Duration(seconds: 1),
                  ));
                  return;
                }
                getProvider
                    .updateAddress("${street}/${apartmentController.text}");
                DbIceCreamHelper.addressApi(
                    "${street}/${apartmentController.text}");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const OrderPage()));
              },
              child: Text(
                "Добавить адресс",
                style: TextStyle(color: Colors.white),
              ))
        ],
        elevation: 0,
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    width: 170,
                    child: TextFormField(
                      // enableInteractiveSelection: false,
                      validator: (val) =>
                          val!.isEmpty ? "Constants.INPUT_ADDRES" : null,
                      controller: queryController,
                      decoration: const InputDecoration(
                        labelText: "Ваш адресс",
                        border: UnderlineInputBorder(
                            // borderSide: BorderSide(width: double.infinity)
                            // borderRadius: BorderRadius.circular(5)
                            ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () async {
                            _search();
                            if (queryController.text.isNotEmpty) {
                              Timer(
                                  const Duration(seconds: 3),
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
                                                  street = searchResults[index]
                                                          ['name']
                                                      .toString();
                                                  List<String> coords =
                                                      searchResults[index]
                                                              ['Point']['pos']
                                                          .toString()
                                                          .split(' ');
                                                  setState(() {
                                                    if (address != null) {
                                                      address!.street =
                                                          searchResults[index]
                                                              ['name'];
                                                      address!.lat =
                                                          double.parse(
                                                              coords[1]);
                                                      address!.lon =
                                                          double.parse(
                                                              coords[0]);
                                                    } else {
                                                      address = Address(
                                                          street: searchResults[
                                                              index]['name'],
                                                          lat: double.parse(
                                                              coords[1]),
                                                          lon: double.parse(
                                                              coords[0]));
                                                    }
                                                  });
                                                  await controller.moveCamera(
                                                      CameraUpdate.newCameraPosition(
                                                          CameraPosition(
                                                              target: Point(
                                                                  latitude:
                                                                      address!
                                                                          .lat,
                                                                  longitude:
                                                                      address!
                                                                          .lon),
                                                              zoom: 12)));
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                        searchResults[index]
                                                                ['description']
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
                          icon: Icon(Icons.search_rounded)))
                ],
              ),
              Container(
                width: 170,
                child: TextFormField(
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
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                YandexMap(
                  mapObjects: mapObjects,
                  onCameraPositionChanged: (CameraPosition cameraPosition,
                      CameraUpdateReason _, bool __) async {
                    final placemark = mapObjects.firstWhere(
                        (el) => el.mapId == cameraMapObjectId) as Placemark;

                    setState(() {
                      mapObjects[mapObjects.indexOf(placemark)] =
                          placemark.copyWith(point: cameraPosition.target);
                    });
                  },
                  onMapCreated:
                      (YandexMapController yandexMapController) async {
                    final placemark = mapObjects.firstWhere(
                        (el) => el.mapId == cameraMapObjectId) as Placemark;

                    controller = yandexMapController;

                    await controller.moveCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: placemark.point, zoom: 12)));
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: street == ""
                ? const Text("Адресс :")
                : Expanded(
                    child: Text(
                        "Адресс : $street квартира ${apartmentController.text}")),
          ),
          // const SizedBox(height: 20),
          // Expanded(
          //     child: SingleChildScrollView(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       TextFormField(
          //         // enableInteractiveSelection: false,
          //         validator: (val) =>
          //             val!.isEmpty ? "Constants.INPUT_ADDRES" : null,
          //         controller: queryController,
          //         decoration: const InputDecoration(
          //           labelText: "Ваш адресс",
          //           border: UnderlineInputBorder(
          //               borderSide: BorderSide(width: double.infinity)
          //               // borderRadius: BorderRadius.circular(5)
          //               ),
          //           contentPadding:
          //               EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       TextFormField(
          //         style: const TextStyle(color: Colors.black),
          //         keyboardType: TextInputType.number,
          //         controller: apartmentController,
          //         decoration: const InputDecoration(
          //           labelText: "Апартамент",
          //           border: UnderlineInputBorder(
          //               // borderRadius: BorderRadius.circular(5)
          //               ),
          //           contentPadding:
          //               EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 15,
          //       ),
          //       //
          //       //
          //       //
          //       // Here is a buttonith style
          //       //
          //       //
          //       //
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           GestureDetector(
          //             onTap: () async {
          //               _search();
          //               if (queryController.text.isNotEmpty) {
          //                 Timer(
          //                     const Duration(seconds: 3),
          //                     () => showModalBottomSheet(
          //                         context: context,
          //                         builder: (context) {
          //                           return ListView.builder(
          //                               shrinkWrap: true,
          //                               physics:
          //                                   const NeverScrollableScrollPhysics(),
          //                               itemCount: searchResults.length,
          //                               itemBuilder: (context, index) {
          //                                 return GestureDetector(
          //                                   onTap: () async {
          //                                     street = searchResults[index]
          //                                             ['name']
          //                                         .toString();
          //                                     List<String> coords =
          //                                         searchResults[index]
          //                                                 ['Point']['pos']
          //                                             .toString()
          //                                             .split(' ');
          //                                     setState(() {
          //                                       if (address != null) {
          //                                         address!.street =
          //                                             searchResults[index]
          //                                                 ['name'];
          //                                         address!.lat =
          //                                             double.parse(coords[1]);
          //                                         address!.lon =
          //                                             double.parse(coords[0]);
          //                                       } else {
          //                                         address = Address(
          //                                             street:
          //                                                 searchResults[index]
          //                                                     ['name'],
          //                                             lat: double.parse(
          //                                                 coords[1]),
          //                                             lon: double.parse(
          //                                                 coords[0]));
          //                                       }
          //                                     });
          //                                     await controller.moveCamera(
          //                                         CameraUpdate.newCameraPosition(
          //                                             CameraPosition(
          //                                                 target: Point(
          //                                                     latitude:
          //                                                         address!
          //                                                             .lat,
          //                                                     longitude:
          //                                                         address!
          //                                                             .lon),
          //                                                 zoom: 12)));
          //                                     Navigator.pop(context);
          //                                   },
          //                                   child: Container(
          //                                     color: Colors.grey[200],
          //                                     padding:
          //                                         const EdgeInsets.all(8),
          //                                     margin: const EdgeInsets.only(
          //                                         bottom: 5),
          //                                     child: Column(
          //                                       mainAxisSize:
          //                                           MainAxisSize.max,
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.start,
          //                                       crossAxisAlignment:
          //                                           CrossAxisAlignment.start,
          //                                       children: [
          //                                         Text(
          //                                           searchResults[index]
          //                                                   ['name']
          //                                               .toString()
          //                                               .toString()
          //                                               .trim(),
          //                                           overflow:
          //                                               TextOverflow.clip,
          //                                           style: const TextStyle(
          //                                               fontSize: 16,
          //                                               fontWeight:
          //                                                   FontWeight.w500),
          //                                         ),
          //                                         Text(
          //                                           searchResults[index]
          //                                                   ['description']
          //                                               .toString()
          //                                               .trim(),
          //                                           overflow:
          //                                               TextOverflow.clip,
          //                                           style: TextStyle(
          //                                               color:
          //                                                   Colors.grey[600],
          //                                               fontSize: 14,
          //                                               fontWeight:
          //                                                   FontWeight.w500),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 );
          //                               });
          //                         }));
          //               } else {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                     const SnackBar(
          //                         duration: Duration(seconds: 1),
          //                         content: Text("Сначала добавьте адресс")));
          //                 return;
          //               }
          //             },
          //             child: SizedBox(
          //               child: Container(
          //                 height: 50,
          //                 width: 120,
          //                 decoration: BoxDecoration(
          //                     // boxShadow: const [
          //                     //   BoxShadow(
          //                     //       offset: Offset(0, 20),
          //                     //       blurRadius: 30,
          //                     //       color: Colors.black),
          //                     // ],
          //                     color: Colors.amber,
          //                     borderRadius: BorderRadius.circular(22.0)),
          //                 child: Row(
          //                   children: [
          //                     Container(
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 4, vertical: 12),
          //                       width: 70,
          //                       height: MediaQuery.of(context).size.height,
          //                       child: const Text(
          //                         "Search",
          //                         style: TextStyle(
          //                             color: Colors.white, fontSize: 15),
          //                       ),
          //                       decoration: const BoxDecoration(
          //                           color: Colors.greenAccent,
          //                           borderRadius: BorderRadius.only(
          //                             bottomLeft: Radius.circular(50),
          //                             topLeft: Radius.circular(50),
          //                             bottomRight: Radius.circular(200),
          //                           )),
          //                     ),
          //                     const Icon(Icons.search),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),

          //           // GestureDetector(
          //           //     child: Container(
          //           //       height: 50,
          //           //       width: 100,
          //           //       color: Colors.blue,
          //           //       child: const Icon(
          //           //         Icons.search,
          //           //         color: Colors.white,
          //           //       ),
          //           //     ),
          //           //     onTap: _search),
          //           ElevatedButton(
          //               onPressed: () {
          //                 if (street.isEmpty) {
          //                   ScaffoldMessenger.of(context)
          //                       .showSnackBar(const SnackBar(
          //                     content: Text("Address is empty"),
          //                     duration: Duration(seconds: 1),
          //                   ));
          //                   return;
          //                 }
          //                 getProvider.updateAddress(
          //                     "${street}/${apartmentController.text}");
          //                 DbIceCreamHelper.addressApi(
          //                     "${street}/${apartmentController.text}");
          //                 Navigator.pushReplacement(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => const OrderPage()));
          //               },
          //               child: const Text("Add")),

          //           GestureDetector(
          //             onTap: () {
          //               if (apartmentController.text.isNotEmpty) {
          //                 FocusManager.instance.primaryFocus?.unfocus();
          //                 _setPoint();
          //                 print(_point);
          //               } else {
          //                 FocusManager.instance.primaryFocus?.unfocus();
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                     const SnackBar(
          //                         content: Text("Добавьте номер квартиры")));
          //               }
          //               // setPoint(_point);
          //             },
          //             child: SizedBox(
          //               child: Container(
          //                 height: 50,
          //                 width: 120,
          //                 decoration: BoxDecoration(
          //                     // boxShadow: const [
          //                     //   BoxShadow(
          //                     //       offset: Offset(0, 20),
          //                     //       blurRadius: 30,
          //                     //       color: Colors.black),
          //                     // ],
          //                     color: Colors.amber,
          //                     borderRadius: BorderRadius.circular(22.0)),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     const Icon(Icons.location_on_outlined),
          //                     Container(
          //                       padding: const EdgeInsets.symmetric(
          //                           horizontal: 20, vertical: 12),
          //                       width: 70,
          //                       height: MediaQuery.of(context).size.height,
          //                       child: const Text(
          //                         "SET",
          //                         style: TextStyle(
          //                             color: Colors.white, fontSize: 15),
          //                       ),
          //                       decoration: const BoxDecoration(
          //                           color: Colors.greenAccent,
          //                           borderRadius: BorderRadius.only(
          //                               bottomLeft: Radius.circular(360),
          //                               // topLeft: Radius.circular(98),
          //                               bottomRight: Radius.circular(50),
          //                               topRight: Radius.circular(50))),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //           // GestureDetector(
          //           //     child: Container(
          //           //         height: 50,
          //           //         width: 100,
          //           //         padding: const EdgeInsets.only(
          //           //             left: 5, right: 5),
          //           //         color: Colors.green,
          //           //         child: Row(
          //           //           mainAxisAlignment:
          //           //               MainAxisAlignment.center,
          //           //           children: const [
          //           //             Icon(
          //           //               Icons.location_on_outlined,
          //           //               color: Colors.white,
          //           //             ),
          //           //             SizedBox(
          //           //               width: 4,
          //           //             ),
          //           //             Text(
          //           //               "SET",
          //           //               style: TextStyle(
          //           //                   color: Colors.white,
          //           //                   fontSize: 16),
          //           //             )
          //           //           ],
          //           //         )),
          //           //     onTap: setPoint)
          //         ],
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(top: 30),
          //         child: street == ""
          //             ? const Text("Адресс :")
          //             : Expanded(
          //                 child: Text(
          //                     "Адресс : $street квартира ${apartmentController.text}")),
          //       ),
          //     ],
          //   ),

          //   // Column(
          //   //   children: <Widget>[
          //   //     Row(
          //   //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   //       children: <Widget>[
          //   //         ControlButton(
          //   //           onPressed: _search,
          //   //           title: 'What is here?'
          //   //         ),
          //   //       ],
          //   //     ),
          //   //   ]
          //   // )
          // )),
        ]),
      ),
    );
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

  void _setPoint() async {
    final cameraPosition = await controller.getCameraPosition();

    print('Point: ${cameraPosition.target}, Zoom: ${cameraPosition.zoom}');

    var resultWithSession = YandexSearch.searchByPoint(
      point: cameraPosition.target,
      zoom: cameraPosition.zoom.toInt(),
      searchOptions: const SearchOptions(
        searchType: SearchType.geo,
        geometry: false,
      ),
    );

    SearchSessionResult result = await resultWithSession.result;
    if (result.error != null) {
      EasyLoading.dismiss();
      EasyLoading.showError("SOMETHING_WENT_WRONG");
      return;
    }
    setState(() {
      street = result.items![0].name.toString();
    });

    print('Page ${result.page}: ${result.items}');
    print('STREET ${street}');
  }
}
