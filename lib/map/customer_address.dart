import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sqlfllite/db/ice_creame_db_provider.dart';
import 'package:sqlfllite/pages/order_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../models/address.dart';
import '../provider/provider.dart';

class CustomerAddress extends StatefulWidget {
  Address? address;
  Function? callback;
  CustomerAddress({Key? key, this.address, this.callback}) : super(key: key);
  @override
  _CustomerAddressState createState() => _CustomerAddressState();
}

class _CustomerAddressState extends State<CustomerAddress> {
  late TextEditingController queryController;
  late TextEditingController apartmentController;
  late YandexMapController yMapController;
  late String street = '';
  Point _point = const Point(latitude: 38.576271, longitude: 68.779716);
  List<dynamic> searchResults = [];
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
  void dispose() {
    // TODO: implement dispose
    queryController.dispose();
    yMapController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var getProvider = Provider.of<ProviderProduct>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            "",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.amber,
          elevation: 0,
        ),
        body: Container(
            // alignment: Alignment.center,
            child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 250,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Stack(
                        children: [
                          YandexMap(
                            onMapCreated: (YandexMapController
                                yandexMapController) async {
                              yMapController = yandexMapController;
                              if (widget.address != null) {
                                _point = Point(
                                    latitude: widget.address!.lat,
                                    longitude: widget.address!.lon);
                                await yMapController.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: _point, zoom: 17)));
                              } else {
                                await yMapController.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: _point, zoom: 12)));
                              }
                              Placemark(
                                  mapId: placemarkId,
                                  point: _point,
                                  onTap: (Placemark self, Point point) =>
                                      print('Tapped me at $point'),
                                  opacity: 0.7,
                                  direction: 90,
                                  isDraggable: true,
                                  onDragStart: (_) => print('Drag start'),
                                  onDrag: (_, Point point) =>
                                      print('Drag at point $point'),
                                  onDragEnd: (_) => print('Drag end'),
                                  icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                      image: BitmapDescriptor.fromAssetImage(
                                          'lib/assets/place.png'),
                                      rotationType: RotationType.rotate)));
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
                      )
                    ],
                  ),
                ),
                Container(
                    color: Colors.amber,
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("SEARCH_RESULT",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                            child: Container(
                                height: 30,
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                color: Colors.green,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "SET",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                )),
                            onTap: setPoint),
                      ],
                    )),
                if (widget.address != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      children: [
                        const Text("ADDRESS :",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(widget.address!.street,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                if (widget.address != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Text('Lat:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(widget.address!.lat.toStringAsFixed(6),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('Lon:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(widget.address!.lon.toStringAsFixed(6),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 170,
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "Constants.INPUT_ADDRES" : null,
                            controller: queryController,
                            decoration: const InputDecoration(
                              labelText: "Constants.SEARCH_ADDRESS",
                              border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(5)
                                  ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 110,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: apartmentController,
                            decoration: const InputDecoration(
                              labelText: "Constants.APARTMENT",
                              border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(5)
                                  ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                            child: Container(
                              height: double.maxFinite,
                              color: Colors.blue,
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            onTap: _search),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            street = searchResults[index]['name'].toString();
                            List<String> coords = searchResults[index]['Point']
                                    ['pos']
                                .toString()
                                .split(' ');
                            setState(() {
                              if (widget.address != null) {
                                widget.address!.street =
                                    searchResults[index]['name'];
                                widget.address!.lat = double.parse(coords[1]);
                                widget.address!.lon = double.parse(coords[0]);
                              } else {
                                widget.address = Address(
                                    street: searchResults[index]['name'],
                                    lat: double.parse(coords[1]),
                                    lon: double.parse(coords[0]));
                              }
                            });
                            await yMapController.moveCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: Point(
                                        latitude: widget.address!.lat,
                                        longitude: widget.address!.lon),
                                    zoom: 12)));
                          },
                          child: Container(
                            color: Colors.grey[200],
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchResults[index]['name']
                                      .toString()
                                      .trim(),
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  searchResults[index]['description']
                                      .toString()
                                      .trim(),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                if (searchResults.isEmpty && queryController.text != '')
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: const Text('No results found!'),
                  ),
                TextButton(
                    onPressed: () async {
                      if (street.isNotEmpty) {
                        await DbIceCreamHelper.addressApi(street);
                        getProvider.updateAddress(street);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const OrderPage()));
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => OrderPage()),
                        //   (Route<dynamic> route) => false,
                        // );
                        //print(" STREET $street");
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Сначала введите адресс"),
                          duration: Duration(seconds: 1),
                        ));
                        return;
                        // return;
                      }
                    },
                    child: const Text("add"))
              ]),
        )));
  }

  void _search() async {
    if (queryController.text != '') {
      EasyLoading.show(status: "SEARCHING");
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

  void setPoint() async {
    if (apartmentController.text == '') {
      EasyLoading.showError('Please set apartment number first!');
      return;
    }
    EasyLoading.show(status: 'SEARCHING');
    var point = (await yMapController.getCameraPosition()).target;
    // (await yMapController.getCameraPosition()).target;
    var resultWithSession = YandexSearch.searchByPoint(
      point: point,
      zoom: 20,
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
        widget.address!.lat = point.latitude;
        widget.address!.lon = point.longitude;
        widget.address!.apartment = apartmentController.text;
      } else {
        widget.address = Address(
            street: temp,
            lat: point.latitude,
            lon: point.longitude,
            apartment: apartmentController.text);
      }
      widget.callback!(widget.address);
      Navigator.pop(context);
    }
    print('Page ${result.page}: $result');
  }
}
