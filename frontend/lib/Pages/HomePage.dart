import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weski/Api/skiResortAPI.dart';
import 'package:weski/ConcretObjects/User.dart';
import 'package:weski/Pages/friendsPage.dart';
import 'package:weski/Widget/customDraggable.dart';

import '../Widget/customDrawer.dart';
import '../Widget/customSearch.dart';

class HomePage extends StatefulWidget {
  final User? curentUser;
  HomePage({Key? key, required this.curentUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  late MapType _currentMapType = MapType.normal;
  late int mapTypeIndex = 0;
  LocationData? currentLocation;
  double _currentZoom = 15.0;
  final LatLng _initialPosition = const LatLng(45.3219, 23.2363);
  Set<Polyline> set_polylines = {};
  LatLng? _lastLocation;
  late Set<Marker> markers_list = {};

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    await location.changeSettings(
      accuracy: LocationAccuracy.high,
    );

    location.getLocation().then((loc) {
      setState(() {
        currentLocation = loc;
      });
    });

    location.onLocationChanged.listen((newLoc) async {
      LatLng newPosition = LatLng(newLoc.latitude!, newLoc.longitude!);


      if (_lastLocation == null || _calculateDistance(_lastLocation!, newPosition) > 5) {
        setState(() {
          currentLocation = newLoc;
          _lastLocation = newPosition;
        });

        final googleMapController = await _controller.future;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: newPosition,
              zoom: _currentZoom,
            ),
          ),
        );
      }
    });
  }


  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000;
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLng = _degreesToRadians(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    getCurrentLocation();
  }

  Set<Polyline> displayed_polylines = {};
  void hidePolyline() {
    setState(() {
      if (_currentZoom >= 13) {
        displayed_polylines = set_polylines;
      } else {
        displayed_polylines = {};
      }
    });
  }


  void _updatePolylines(Set<Polyline> newPolylines) {
    setState(() {
      set_polylines = newPolylines;
      hidePolyline();
    });
  }
  Future<void> _loadMarkers() async {
    final markers = await skiResortApi.fetchResorts(_controller, _updatePolylines);
    if (markers != null) {
      setState(() {
        markers_list = markers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      Stack(
        children: [
          currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
              zoom: _currentZoom,
            ),
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            mapType: _currentMapType,
            markers: {
              Marker(
                markerId: const MarkerId("Current Location"),
                position: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
                //icon: _customMarkerIcon,
              ),
              ...markers_list,
            },
            polylines: displayed_polylines,
            onCameraMove: (cameraPosition) {
              setState(() {
                _currentZoom = cameraPosition.zoom;
              });
              hidePolyline();
            },

          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.06),
                        child: Builder(
                          builder: (BuildContext context) {
                            return RawMaterialButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              fillColor: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 5,
                              constraints: BoxConstraints(
                                minWidth: screenWidth * 0.13,
                                minHeight: screenWidth * 0.13,
                              ),
                              child: Icon(
                                Icons.menu,
                                color: Colors.black,
                                size: screenWidth * 0.07,
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                        child: CustomSearchBar(
                          fillColor: 0xFFFFFFFF,
                          textColor: 0xFF000000,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.06),
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const friendsPage()),
                            );
                          },
                          fillColor: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 5,
                          constraints: BoxConstraints(
                            minWidth: screenWidth * 0.13,
                            minHeight: screenWidth * 0.13,
                          ),
                          child: Icon(
                            Icons.groups,
                            color: Colors.black,
                            size: screenWidth * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.06, left: screenWidth * 0.06, bottom: screenHeight * 0.165),
                      child: RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            if(mapTypeIndex == 0){
                              _currentMapType = MapType.normal;
                              mapTypeIndex = 1;
                            }
                            else if(mapTypeIndex == 1){
                              _currentMapType = MapType.terrain;
                              mapTypeIndex = 2;
                            }
                            else{
                              _currentMapType = MapType.satellite;
                              mapTypeIndex = 0;
                            }
                          });
                        },
                        fillColor: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 5,
                        constraints: BoxConstraints(
                          minWidth: screenWidth * 0.13,
                          minHeight: screenWidth * 0.13,
                        ),
                        child: Icon(
                          Icons.layers_outlined,
                          color: Colors.black,
                          size: screenWidth * 0.07,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.06, bottom: screenHeight * 0.165),
                      child: RawMaterialButton(
                        onPressed: () async {
                          final googleMapController = await _controller.future;
                          googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  currentLocation!.latitude!,
                                  currentLocation!.longitude!,
                                ),
                                zoom: 19,
                              ),
                            ),
                          );
                        },
                        fillColor: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 5,
                        constraints: BoxConstraints(
                          minWidth: screenWidth * 0.13,
                          minHeight: screenWidth * 0.13,
                        ),
                        child: Icon(
                          Icons.gps_fixed,
                          color: Colors.black,
                          size: screenWidth * 0.07,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          customDraggable(screenWidth: screenWidth, screenHeight: screenHeight)
        ],
      ),
      drawer: customDrawer(
        user: widget.curentUser!,
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }
}
