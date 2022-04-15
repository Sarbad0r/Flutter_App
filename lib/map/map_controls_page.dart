import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';


class MapControlsPage extends StatelessWidget {
  const MapControlsPage() : super();

  @override
  Widget build(BuildContext context) {
    return _MapControlsExample();
  }
}

class _MapControlsExample extends StatefulWidget {
  @override
  _MapControlsExampleState createState() => _MapControlsExampleState();
}

class _MapControlsExampleState extends State<_MapControlsExample> {
  late YandexMapController controller;
  final List<MapObject> mapObjects = [];

  final MapObjectId targetMapObjectId = MapObjectId('target_placemark');
  static const Point _point = Point(latitude: 59.945933, longitude: 30.320045);
  final animation = const MapAnimation(type: MapAnimationType.smooth, duration: 2.0);

  bool tiltGesturesEnabled = true;
  bool zoomGesturesEnabled = true;
  bool rotateGesturesEnabled = true;
  bool scrollGesturesEnabled = true;
  bool modelsEnabled = true;
  bool nightModeEnabled = false;
  bool fastTapEnabled = false;
  bool mode2DEnabled = false;
  bool indoorEnabled = false;
  bool liteModeEnabled = false;
  ScreenRect? screenRect;

  final String style = '''
    [
      {
        "tags": {
          "all": ["landscape"]
        },
        "stylers": {
          "color": "f00",
          "saturation": 0.5,
          "lightness": 0.5
        }
      }
    ]
  ''';

  String _enabledText(bool enabled) {
    return enabled ? 'on' : 'off';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: YandexMap(
            tiltGesturesEnabled: tiltGesturesEnabled,
            zoomGesturesEnabled: zoomGesturesEnabled,
            rotateGesturesEnabled: rotateGesturesEnabled,
            scrollGesturesEnabled: scrollGesturesEnabled,
            modelsEnabled: modelsEnabled,
            nightModeEnabled: nightModeEnabled,
            fastTapEnabled: fastTapEnabled,
            mode2DEnabled: mode2DEnabled,
            indoorEnabled: indoorEnabled,
            liteModeEnabled: liteModeEnabled,
            logoAlignment: MapAlignment(horizontal: HorizontalAlignment.left, vertical: VerticalAlignment.bottom),
            screenRect: screenRect,
            mapObjects: mapObjects,
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;

              final cameraPosition = await controller.getCameraPosition();
              final minZoom = await controller.getMinZoom();
              final maxZoom = await controller.getMaxZoom();

              print('Camera position: $cameraPosition');
              print('Min zoom: $minZoom, Max zoom: $maxZoom');
            },
            onMapTap: (Point point) => print('Tapped map at $point'),
            onMapLongTap: (Point point) => print('Long tapped map at $point'),
            onCameraPositionChanged: (CameraPosition cameraPosition, CameraUpdateReason reason, bool finished) {
              print('Camera position: $cameraPosition, Reason: $reason');

              if (finished) {
                print('Camera position movement has been finished');
              }
            },
          )
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Table(
              children: <TableRow>[
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await controller.moveCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(target: _point)),
                        animation: animation
                      );
                    },
                    child: Text("Specific position"),
                    // title: ''
                  ),
                  TextButton(
                    onPressed: () async {
                      await controller.moveCamera(CameraUpdate.zoomTo(1), animation: animation);
                    },
                    // title: 'Specific zoom', 
                    child: Text('Specific zoom'),
                  )
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await controller.moveCamera(CameraUpdate.azimuthTo(1), animation: animation);
                    },
                    // title: 'Specific azimuth'
                    child: Text("Specific azimuth"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await controller.moveCamera(CameraUpdate.tiltTo(1), animation: animation);
                    },
                    child: Text("Specific tilt"),
                    // title: 'Specific tilt'
                  ),
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await controller.moveCamera(CameraUpdate.zoomIn(), animation: animation);
                    },
                    // title: 'Zoom in'
                    child: Text("Zoom in"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await controller.moveCamera(CameraUpdate.zoomOut(), animation: animation);
                    },
                    // title: 'Zoom out'
                    child: Text("Zoom out"),
                  ),
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      final newBounds = BoundingBox(
                        northEast: const Point(latitude: 65.0, longitude: 40.0),
                        southWest: const Point(latitude: 60.0, longitude: 30.0),
                      );
                      await controller.moveCamera(CameraUpdate.newBounds(newBounds), animation: animation);
                    },
                    // title: 'New bounds'
                    child: Text("New bounds"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final newBounds = BoundingBox(
                        northEast: const Point(latitude: 65.0, longitude: 40.0),
                        southWest: const Point(latitude: 60.0, longitude: 30.0),
                      );
                      await controller.moveCamera(
                        CameraUpdate.newTiltAzimuthBounds(newBounds, azimuth: 1, tilt: 1),
                        animation: animation
                      );
                    },
                    // title: 'New bounds with tilt and azimuth'
                    child: Text("New bounds with tilt and azimuth"),
                  ),
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      final placemark = Placemark(
                        mapId: targetMapObjectId,
                        point: (await controller.getCameraPosition()).target,
                        opacity: 0.7,
                        icon: PlacemarkIcon.single(
                          PlacemarkIconStyle(
                            image: BitmapDescriptor.fromAssetImage('lib/assets/place.png')
                          )
                        )
                      );

                      setState(() {
                        mapObjects.removeWhere((el) => el.mapId == targetMapObjectId);
                        mapObjects.add(placemark);
                      });
                    },
                    // title: 'Target point'
                    child: Text("Target point"),
                  ),
                  Container()
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await controller.setMapStyle(style);
                    },
                    // title: 'Set Style'
                    child: Text('Set Style'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await controller.setMapStyle('');
                    },
                    // title: 'Remove style'
                    child: Text('Remove style'),
                  ),
                ]),
                TableRow(
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          screenRect = const ScreenRect(
                            bottomRight: ScreenPoint(x: 600, y: 600),
                            topLeft: ScreenPoint(x: 200, y: 200)
                          );
                        });
                      },
                      // title: 'Focus rect'
                      child: Text('Focus rect'),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          screenRect = null;
                        });
                      },
                      child: Text('Clear focus rect'),
                      // title: 'Clear focus rect'
                    )
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        final region = await controller.getFocusRegion();
                        print(region);
                      },
                      // title: 'Focus region'
                      child: Text('Focus region'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final region = await controller.getVisibleRegion();
                        print(region);
                      },
                      // title: 'Visible region'
                      child: Text('Visible region'),
                    )
                  ],
                ),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      final screenPoint = await controller.getScreenPoint(
                        (await controller.getCameraPosition()).target
                      );

                      print(screenPoint);
                    },
                    // title: 'Map point to screen'
                    child: Text('Map point to screen'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final mediaQuery = MediaQuery.of(context);
                      final point = await controller.getPoint(
                        ScreenPoint(x: mediaQuery.size.width, y: mediaQuery.size.height)
                      );

                      print(point);
                    },
                    // title: 'Screen point to map'
                    child: Text('Screen point to map'),
                  ),
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          tiltGesturesEnabled = !tiltGesturesEnabled;
                        });
                      },
                      // title: 'Tilt gestures: ${_enabledText(tiltGesturesEnabled)}'
                      child: Text('Tilt gestures: ${_enabledText(tiltGesturesEnabled)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        rotateGesturesEnabled = !rotateGesturesEnabled;
                      });
                    },
                    // title: 'Rotate gestures: ${_enabledText(rotateGesturesEnabled)}'
                    child: Text('Rotate gestures: ${_enabledText(rotateGesturesEnabled)}'),
                  ),
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        zoomGesturesEnabled = !zoomGesturesEnabled;
                      });
                    },
                    // title: 'Zoom gestures: ${_enabledText(zoomGesturesEnabled)}'
                    child: Text('Zoom gestures: ${_enabledText(zoomGesturesEnabled)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        scrollGesturesEnabled = !scrollGesturesEnabled;
                      });
                    },
                    // title: 'Scroll gestures: ${_enabledText(scrollGesturesEnabled)}'
                    child: Text('Scroll gestures: ${_enabledText(scrollGesturesEnabled)}'),
                  )
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        modelsEnabled = !modelsEnabled;
                      });
                    },
                    // title: 'Models: ${_enabledText(modelsEnabled)}'
                    child: Text('Models: ${_enabledText(modelsEnabled)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        nightModeEnabled = !nightModeEnabled;
                      });
                    },
                    // title: 'Night mode: ${_enabledText(nightModeEnabled)}'
                    child: Text('Night mode: ${_enabledText(nightModeEnabled)}'),
                  )
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        fastTapEnabled = !fastTapEnabled;
                      });
                    },
                    // title: 'Fast tap: ${_enabledText(fastTapEnabled)}'
                    child: Text('Fast tap: ${_enabledText(fastTapEnabled)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        mode2DEnabled = !mode2DEnabled;
                      });
                    },
                    // title: '2D mode: ${_enabledText(mode2DEnabled)}'
                    child: Text('2D mode: ${_enabledText(mode2DEnabled)}'),
                  )
                ]),
                TableRow(children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        indoorEnabled = !indoorEnabled;
                      });
                    },
                    // title: 'Indoor mode: ${_enabledText(indoorEnabled)}'
                    child: Text('Indoor mode: ${_enabledText(indoorEnabled)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        liteModeEnabled = !liteModeEnabled;
                      });
                    },
                    // title: 'Lite mode: ${_enabledText(liteModeEnabled)}'
                    child: Text('Lite mode: ${_enabledText(liteModeEnabled)}'),
                  )
                ])
              ],
            ),
          ),
        )
      ]
    );
  }
}