import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:weski/Api/locationApi.dart';
import 'package:weski/ConcretObjects/User.dart';

import '../Api/consts.dart';
import '../Api/locationSocket.dart';

LocationData? currentLocation;
LocationData? _lastLocationData;
LatLng? _lastLocation;
LatLng? _lastDistanceLocation;
double totalDistance = 0.0;
double currentSpeed = 0.0;
double totalSum = 0;
int totalCount = 0;
double sumSpeed = 0;
double maxSpeed = 0.0;
int count = 0;
double averageSpeed = 0;
double maxAltitude = 0.0;
bool isTracking = false;
ValueNotifier<bool> isRecordingNotifier = ValueNotifier(false);
ValueNotifier<double> weatherTempNotifier = ValueNotifier(0.0);
ValueNotifier<String> weatherCondNotifier = ValueNotifier("clear");
ValueNotifier<List<List<dynamic>>> weatherFiveDaysNotifier = ValueNotifier([]);
Timer? weatherTimer;
Timer? locationTimer;

void resetData(){
  totalDistance = 0.0;
  currentSpeed = 0.0;
  totalSum = 0;
  totalCount = 0;
  sumSpeed = 0;
  count = 0;
  averageSpeed = 0;
  maxAltitude = 0.0;
  maxSpeed = 0.0;
  isRecordingNotifier.value = false;
}

Future<LocationData> getCurrentLocation() async {
  return currentLocation ?? LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
}

Future<void> getWeather() async {
  if (currentLocation != null) {
    WeatherFactory weatherDataFactory = WeatherFactory(keyWeather);
    Weather weatherData = await weatherDataFactory.currentWeatherByLocation(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    List<Weather> weatherFiveDaysList = await weatherDataFactory.fiveDayForecastByLocation(
        currentLocation!.latitude!,
        currentLocation!.longitude!
    );

    List<List<dynamic>> extractedFiveDaysWeather = [];
    for (var weather in weatherFiveDaysList) {
      List<dynamic> aux = [];

      if(weather.date?.hour == 12){
        aux.add(weather.weatherMain??"clear");
        aux.add(weather.temperature?.celsius);
        extractedFiveDaysWeather.add(aux);
      }

    }

    weatherTempNotifier.value = weatherData.temperature?.celsius ?? 0.0;
    weatherCondNotifier.value = weatherData.weatherMain??"clear";
    weatherFiveDaysNotifier.value = extractedFiveDaysWeather??[];

    weatherTimer = Timer.periodic(Duration(hours: 1), (timer) async {
      Weather weatherData = await weatherDataFactory.currentWeatherByLocation(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );

      weatherTempNotifier.value = weatherData.temperature?.celsius ?? 0.0;
      weatherCondNotifier.value = weatherData.weatherMain??"clear";
    });
  }
}


void setIsTrackingTrue(){
  isTracking = true;
}
void setIsTrackingFalse(){
  isTracking = false;
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

double haversineInMeters(LatLng start, LatLng end) {
  const double earthRadius = 6371000;
  double dLat = degreesToRadians(end.latitude - start.latitude);
  double dLng = degreesToRadians(end.longitude - start.longitude);

  double a = pow(sin(dLat / 2), 2) +
      cos(degreesToRadians(start.latitude)) *
          cos(degreesToRadians(end.latitude)) *
          pow(sin(dLng / 2), 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double calculateSpeed(LocationData newLoc, LocationData? lastLoc, LatLng newPosition) {
  if (lastLoc != null && newLoc.time != null && lastLoc.time != null) {
    double timeDiffMillis = newLoc.time! - lastLoc.time!;
    if (timeDiffMillis > 0) {
      double timeDiffSec = timeDiffMillis / 1000.0;
      double distance = haversineInMeters(
        LatLng(lastLoc.latitude!, lastLoc.longitude!),
        newPosition,
      );
      return (distance < 1.0) ? 0.0 : distance / timeDiffSec; // m/s
    }
  }
  return 0.0;
}

void averageSpeedCalc() {
  if (currentSpeed != 0) {
    sumSpeed += currentSpeed;
    count++;
    if (count == 10) {
      double groupAverage = sumSpeed / count;
      totalSum += groupAverage * count;
      totalCount += count;
      averageSpeed = totalSum / totalCount;
      sumSpeed = 0;
      count = 0;
    }
  }
}

Future<void> updateMap(LatLng newPosition, double currentZoom,
    Future<GoogleMapController> googleMapControllerFuture) async {
  final googleMapController = await googleMapControllerFuture;
  googleMapController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: newPosition,
        zoom: currentZoom,
      ),
    ),
  );
}

void stopLocationSaving() {
  if (locationTimer != null) {
    locationTimer!.cancel();
    locationTimer = null;
  }
}

void startLocationUpdates(
    Function(LocationData, double, double, double, double) onLocationUpdate,
    Future<GoogleMapController> googleMapControllerFuture,
    double currentZoom, int curentUserId) async
{

  Location location = Location();

  if (!await location.serviceEnabled()) {
    if (!await location.requestService()) return;
  }

  if (await location.hasPermission() == PermissionStatus.denied) {
    if (await location.requestPermission() != PermissionStatus.granted) return;
  }

  await location.changeSettings(accuracy: LocationAccuracy.high);
  location.getLocation().then((loc) {
    currentLocation = loc;
    _lastLocationData = loc;
    _lastLocation = LatLng(loc.latitude!, loc.longitude!);
    _lastDistanceLocation = _lastLocation;
    maxAltitude = loc.altitude ?? 0.0;
    onLocationUpdate(loc, 0.0, totalDistance, averageSpeed, maxAltitude);
    getWeather();
  });

  location.onLocationChanged.listen((newLoc) async {
    if (newLoc.accuracy != null && newLoc.accuracy! < 25.0 && newLoc.accuracy! > 1.0) {
      LatLng newPosition = LatLng(newLoc.latitude!, newLoc.longitude!);
      double speed = 0.0;
      double distanceIncrement = 0.0;

      if (isRecordingNotifier.value) {
        speed = calculateSpeed(newLoc, _lastLocationData, newPosition);
        distanceIncrement = (_lastDistanceLocation != null)
            ? haversineInMeters(_lastDistanceLocation!, newPosition)
            : 0.0;

        if (newLoc.altitude != null && newLoc.altitude != 0.0 && (maxAltitude < newLoc.altitude!)) {
          maxAltitude = newLoc.altitude!;
        }

        if (distanceIncrement > 3 && distanceIncrement < 1000) {
          totalDistance += distanceIncrement;
          _lastDistanceLocation = newPosition;
        }
        currentSpeed = speed;
        if(currentSpeed > maxSpeed){
          maxSpeed = currentSpeed * 3.6;
        }
        averageSpeedCalc();

        if (isRecordingNotifier.value && locationTimer == null) {
          locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
            if (currentLocation != null) {
              await locationApi.saveUserData(curentUserId,
                  currentLocation!.latitude!,
                  currentLocation!.longitude!);
            }
          });
        }


      }

      currentLocation = newLoc;
      _lastLocationData = newLoc;
      _lastLocation = newPosition;

      sendLocation(currentLocation!.latitude ?? 0, currentLocation!.longitude ?? 0, curentUserId);

      onLocationUpdate(
          newLoc,
          isRecordingNotifier.value ? maxSpeed : 0.0,
          isRecordingNotifier.value ? totalDistance : 0.0,
          isRecordingNotifier.value ? averageSpeed : 0.0,
          isRecordingNotifier.value ? maxAltitude : 0.0
      );

      if (isTracking) {
        await updateMap(newPosition, currentZoom, googleMapControllerFuture);
      }
    }
  });
}

