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

import '../Api/locationSocket.dart';
import '../Assets/LocationLogic.dart';
import '../ConcretObjects/Friend.dart';
import '../ConcretObjects/SearchElement.dart';
import '../Widget/customDrawer.dart';
import '../Widget/customGoogleMap.dart';
import '../Widget/customSearch.dart';
import 'FriendsPage.dart';

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
  ValueNotifier<Polyline> userTrakNotifier = ValueNotifier(Polyline(
    polylineId: const PolylineId("emptry"),
    points: [],
  ));


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
    final markers = await skiResortApi.fetchResortsMarkers(_controller, _updatePolylines);
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
    initSocket();
    initWebSocket();
    _loadMarkers();
    startLocationUpdates((newLoc, speed, distance, avgSpeed, maxAltitude) {
      currentLocationNotifier.value = newLoc;
      speedNotifier.value = speed;
      totalDistanceNotifier.value = distance / 1000;
      averageSpeedNotifier.value = avgSpeed;
      maxAltitudeNotifier.value = maxAltitude;
    }, _controller.future, _currentZoom, widget.curentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));

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
              return ValueListenableBuilder<Map<int, Marker>>(
                valueListenable: markersNotifier,
                builder: (context, usersMarkersMap, child) {
                  final usersMarker = usersMarkersMap.values.toSet();
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
                      ...usersMarker??{},
                    },
                    polylines: {
                      ...displayed_polylines,
                      userTrakNotifier.value!
                    },
                    mapControlerCreat: (controller) => _controller.complete(controller),
                    moveCamera: onCameraMove,
                  );
                },
              );
            }
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenDiagonal * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenDiagonal * 0.025),
                        child: Builder(
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(theme.colorScheme.onTertiary.value).withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: RawMaterialButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                fillColor: Color(theme.colorScheme.tertiary.value),
                                shape: const CircleBorder(),
                                elevation: 5,
                                constraints: BoxConstraints(
                                  minWidth: screenWidth * 0.13,
                                  minHeight: screenWidth * 0.13,
                                ),
                                child: Icon(
                                  Icons.menu,
                                  color: Color(theme.colorScheme.onTertiary.value),
                                  size: screenDiagonal * 0.03,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                        child: CustomSearchBar(
                          fillColor: theme.colorScheme.tertiary.value,
                          textColor: theme.colorScheme.onTertiary.value,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          searchList: searchedElementsList,
                          moveTo: searchBarMovedCamera,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: screenDiagonal * 0.025),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(theme.colorScheme.onTertiary.value).withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: RawMaterialButton(
                            onPressed: () async {
                              List<Friend> friends = await userApi.fetchFriends(widget.curentUser!.id);
                              print(friends);
                              List<Group> groups = await groupApi.fetchUserGroups(widget.curentUser!.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FriendsPage(curentUserId:widget.curentUser!.id, friends: friends, groups: groups, )),
                              );
                            },
                            fillColor: Color(theme.colorScheme.tertiary.value),
                            shape: const CircleBorder(),
                            elevation: 5,
                            constraints: BoxConstraints(
                              minWidth: screenWidth * 0.13,
                              minHeight: screenWidth * 0.13,
                            ),
                            child: Icon(
                              Icons.groups,
                              color: Color(theme.colorScheme.onTertiary.value),
                              size: screenDiagonal * 0.03,
                            ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(theme.colorScheme.onTertiary.value).withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
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
                          fillColor: Color(theme.colorScheme.tertiary.value),
                          shape: const CircleBorder(),
                          elevation: 5,
                          constraints: BoxConstraints(
                            minWidth: screenWidth * 0.13,
                            minHeight: screenWidth * 0.13,
                          ),
                          child: Icon(
                            Icons.layers_outlined,
                            color: Color(theme.colorScheme.onTertiary.value),
                            size: screenDiagonal * 0.03,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.06, bottom: screenHeight * 0.165),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(theme.colorScheme.onTertiary.value).withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: RawMaterialButton(
                          onPressed: () async {
                            if (isTracking == false) {
                              setIsTrackingTrue();
                            } else {
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
                          fillColor: Color(theme.colorScheme.tertiary.value),
                          shape: const CircleBorder(),
                          constraints: BoxConstraints(
                            minWidth: screenWidth * 0.13,
                            minHeight: screenWidth * 0.13,
                          ),
                          child: isTracking
                              ? Icon(
                            Icons.gps_fixed,
                            color: Color(theme.colorScheme.onTertiary.value),
                            size: screenDiagonal * 0.03,
                          )
                              : Icon(
                            Icons.gps_off_outlined,
                            color: Colors.red,
                            size: screenDiagonal * 0.03,
                          ),
                        ),
                      )
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
            userTrackPolylineNotifier: userTrakNotifier
          )
        ],
      ),
      drawer: customDrawer(
        user: widget.curentUser,
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }
}
