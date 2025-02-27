import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:global_news/utils/app_widgets/alert_notify_widgets.dart';

import '../utils/preference_data/news_preference.dart';

class LocationController extends GetxController {
  StreamSubscription<Position>? _posStream;
  late bool _serviceEnabled;
  late LocationPermission _permission;
  late NewsPreference _prefs;

  var locationUpdate = false.obs;

  @override
  void onInit() {
    super.onInit();
    _prefs = NewsPreference();
    _prefs.removeStringData("categories_saved");
  }

  Future<Pair> getCurrentLocation() async {
    // Check if location services are enabled
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      // Location services are not enabled, handle this scenario
      return Pair("Device location not enabled", false);
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied ||
        _permission == LocationPermission.deniedForever) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        // Permissions are denied, handle this scenario
        return Pair('Location permission required', false);
      }
    }
    if (_permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle this scenario
      return Pair('Location permission permanently denied', false);
    }

    if (_permission == LocationPermission.whileInUse ||
        _permission == LocationPermission.always) {
      // Get the current location
      try {
        // Adding a timeout to prevent hanging if there's no response
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(Duration(seconds: 10), onTimeout: () {
          throw TimeoutException("Location request timed out");
        });
        // Get the address from coordinates
        List<Placemark> deviceLocation = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (deviceLocation.isNotEmpty) {
          Placemark placeMark = deviceLocation.first;
          Pair pairValue =
              Pair(placeMark.country.toString(), placeMark.isoCountryCode);
          return pairValue;
        }
      } catch (e) {
        // Handle timeout or other exceptions from getting position
        return Pair("Failed to retrieve location", true);
      }
    }
    return Pair("Internal Location Error", true);
  }

  void getLatLong() {
    try {
      const locSetting = LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 100);
      _posStream = Geolocator.getPositionStream(locationSettings: locSetting)
          .listen((Position position) {
        debugPrint("${position.latitude}, ${position.longitude}");
      });
    } catch (e) {
      throw ("error: ${e.toString()}");
    } finally {
      _posStream?.cancel;
    }
  }

  void setPermissionMsg({required String status}) {
    String permissionMsg = "";
    if (status == "Location permission required") {
      permissionMsg =
          "This app needs location access to provide personalized services. Please enable location permissions.";
    } else if (status == "Location permission permanently denied") {
      permissionMsg =
          "Please enable location permissions in the app settings to use this feature.";
    } else {
      permissionMsg =
          "Enable your device location for a better delivery experience and refresh the screen";
    }
    AlertNotifyWidgets().bottomSheet(status: status, msg: permissionMsg);
  }

  void saveLocation(Pair value) async {
    _prefs.saveStringData("CountryName", value.first);
    _prefs.saveStringData("CountryCode", value.second);
    locationUpdate.value = !locationUpdate.value;
  }
}

class Pair {
  String first;
  dynamic second;

  Pair(this.first, this.second);
}
