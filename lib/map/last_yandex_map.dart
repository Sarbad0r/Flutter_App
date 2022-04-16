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

class LastYandexMap extends MapPage {
  LastYandexMap() : super('Reverse search example');

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
      point: Point(latitude: 38.576271, longitude: 68.779716),
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

  final MapObjectId cameraMapObjectId = MapObjectId('camera_placemark');

  @override
  Widget build(BuildContext context) {
    var styleTextColor = TextStyle(color: Colors.black);

    final mapHeight = 300.0;
    var getProvider = Provider.of<ProviderProduct>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          child: Icon(
            Icons.location_on_outlined,
            color: Colors.black,
          )),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          // title: Icon,
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: YandexMap(
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
      
                    await controller.moveCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: placemark.point, zoom: 12)));
                  },
                ),
              ),
              const SizedBox(height: 20),
            ]),
      ),
    );
  }

  GestureDetector setButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (apartmentController.text.isNotEmpty) {
          FocusManager.instance.primaryFocus?.unfocus();
          _setPoint();
          print(_point);
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Добавьте номер квартиры")));
        }
        // setPoint(_point);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.location_on_outlined),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                width: 70,
                height: MediaQuery.of(context).size.height,
                child: const Text(
                  "SET",
                  style: TextStyle(color: Colors.white, fontSize: 15),
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
