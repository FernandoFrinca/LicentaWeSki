import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class customGoogleMap extends StatelessWidget {
  final LocationData currentLocation;
  final double zoom;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final MapType mapType;
  final Function(GoogleMapController) mapControlerCreat;
  final Function(CameraPosition) moveCamera;

  const customGoogleMap({
    Key? key,
    required this.currentLocation,
    required this.zoom,
    required this.markers,
    required this.polylines,
    required this.mapControlerCreat,
    required this.mapType,
    required this.moveCamera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: zoom,
      ),
      onMapCreated: (mapController) => mapControlerCreat(mapController),
      markers: markers,
      mapType: mapType,
      polylines: polylines,
      onCameraMove: moveCamera,
    );
  }
}
