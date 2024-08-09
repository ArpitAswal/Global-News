import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationCountry {
  static Future<Pair> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle this scenario
      return Pair("Device location not enabled", false);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle this scenario
        return Pair('Location permission required', false);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle this scenario
      return Pair('Location permission permanently denied', false);
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get the address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        Pair pairValue =
            Pair(placemark.country.toString(), placemark.isoCountryCode);
        return pairValue;
      }
    }
    return Pair("", false);
  }

  StreamSubscription<Position>? posStream;

  void getLocationUpdates() {
    try {
      const locSetting = LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 100);
      posStream = Geolocator.getPositionStream(locationSettings: locSetting)
          .listen((Position position) {
        debugPrint("${position.latitude}, ${position.longitude}");
      });
    } catch (e) {
      debugPrint("error: ${e.toString()}");
    }
  }

  void stopListening() {
    posStream?.cancel;
  }
}

class Pair {
  String first;
  dynamic second;

  Pair(this.first, this.second);
}
