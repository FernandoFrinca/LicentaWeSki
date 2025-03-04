import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weski/Api/groupApi.dart';
import 'package:weski/Api/skiResortAPI.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/ConcretObjects/Group.dart';
import 'package:weski/ConcretObjects/User.dart';
import 'package:weski/Widget/customDraggable.dart';

import '../Assets/LocationLogic.dart';
import '../ConcretObjects/Friend.dart';
import '../ConcretObjects/SearchElement.dart';
import '../Widget/customDrawer.dart';
import '../Widget/customGoogleMap.dart';
import '../Widget/customSearch.dart';
import 'FriendsPage.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  final User? curentUser;
  const HomePage({super.key, required this.curentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  MapType _currentMapType = MapType.normal;
  int mapTypeIndex = 0;
  LocationData? currentLocation;
  double _currentZoom = 15.0;
  Set<Polyline> set_polylines = {};
  Set<Marker> markers_list = {};
  List<SearchElement> searchedElementsList = [];
  ValueNotifier<double> speedNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<double> totalDistanceNotifier = ValueNotifier<double> (0.0);
  ValueNotifier<double> averageSpeedNotifier = ValueNotifier<double> (0.0);
  ValueNotifier<double> maxAltitudeNotifier = ValueNotifier<double> (0.0);
  ValueNotifier<LocationData?> currentLocationNotifier = ValueNotifier(null);

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
      for(var marker in markers_list){
        SearchElement aux = new SearchElement();
        aux.name = marker.infoWindow.title!;
        LatLng auxPos = marker.position;
        aux.lat = auxPos.latitude;
        aux.lng = auxPos.longitude;
        searchedElementsList.add(aux);
      }
    }
    print("test:");
    print(searchedElementsList);
  }

  void onCameraMove(CameraPosition cameraPosition) {
    setState(() {
      _currentZoom = cameraPosition.zoom;
    });
    hidePolyline();
  }

  void searchBarMovedCamera(double lat, double lng) async {
    setIsTrackingFalse();
    final GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng,),
          zoom: 15,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    startLocationUpdates((newLoc, speed, distance, avgSpeed, maxAltitude) {
      currentLocationNotifier.value = newLoc;
      speedNotifier.value = speed;
      totalDistanceNotifier.value = distance / 1000;
      averageSpeedNotifier.value = avgSpeed;
      maxAltitudeNotifier.value = maxAltitude;
    }, _controller.future, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      Stack(
        children: [
          ValueListenableBuilder<LocationData?>(
            valueListenable: currentLocationNotifier,
            builder: (context, currentLocation, child) {
              if (currentLocation == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return customGoogleMap(
                mapType: _currentMapType,
                currentLocation: currentLocation,
                zoom: _currentZoom,
                markers: {
                  Marker(
                    markerId: const MarkerId("Current Location"),
                    position: LatLng(
                      currentLocation.latitude!,
                      currentLocation.longitude!,
                    ),
                  ),
                  ...markers_list,
                },
                polylines: displayed_polylines,
                mapControlerCreat: (controller) => _controller.complete(controller),
                moveCamera: onCameraMove,
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          searchList: searchedElementsList,
                          moveTo: searchBarMovedCamera,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.06),
                        child: RawMaterialButton(
                          onPressed: () async {
                            List<Friend> friends = await userApi.fetchFriends(widget.curentUser!.id);
                            List<Group> groups = await groupApi.fetchUserGroups(widget.curentUser!.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FriendsPage(curentUserId:widget.curentUser!.id, friends: friends, groups: groups, )),
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
                          if(isTracking == false) {
                            setIsTrackingTrue();
                          }else{
                            setIsTrackingFalse();
                          }
                          final googleMapController = await _controller.future;
                          googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  currentLocation!.latitude!,
                                  currentLocation!.longitude!,
                                ),
                                zoom: _currentZoom,
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
                        child: isTracking == true ? Icon(
                          Icons.gps_fixed,
                          color: Colors.black,
                          size: screenWidth * 0.07,) : Icon(
                          Icons.gps_off_outlined,
                          color: Colors.red,
                          size: screenWidth * 0.07,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          customDraggable(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            speedNotifier: speedNotifier,
            averageSpeedNotifier: averageSpeedNotifier,
            totalDistanceNotifier: totalDistanceNotifier,
            maxAltitudeNotifier: maxAltitudeNotifier,
            currentUser: widget.curentUser!,
          )
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
