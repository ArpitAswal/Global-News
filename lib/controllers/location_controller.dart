import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/home_controller.dart';
import 'package:global_news/utils/app_widgets/location_alert.dart';
import 'package:global_news/utils/app_widgets/message_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  StreamSubscription<Position>? _posStream;
  late bool _serviceEnabled;
  late LocationPermission _permission;

  final RxString _permissionStatus = ''.obs;
  final RxString _permissionMsg = ''.obs;

  String get permissionStatus => _permissionStatus.value;
  String get permissionMsg => _permissionMsg.value;

  set statusPermission(String value) => _permissionStatus.value = value;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation().then((value) {
      if (value.second is String) {
        isNewLocation(value);
      } else if(value.second == false){
        statusPermission = value.first;
        setPermissionMsg();
        bottomSheet();
      } else{
        MessageWidgets.showSnackBar(value.first);
      }
    });
  }

  void bottomSheet() {
    Get.bottomSheet(
        elevation: 8.0,
        ignoreSafeArea: true,
        persistent: true,
        isDismissible: false,
        enableDrag: false,
        LocationAlert());
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
        List<Placemark> deviceLocation =
        await placemarkFromCoordinates(position.latitude, position.longitude);

        if (deviceLocation.isNotEmpty) {
          Placemark placeMark = deviceLocation.first;
          Pair pairValue =
          Pair(placeMark.country.toString(), placeMark.isoCountryCode);
          return pairValue;
        }
      } catch (e) {
        // Handle timeout or other exceptions from getting position
        return Pair("Failed to retrieve location, check your network connection and refresh the screen", true);
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
      debugPrint("error: ${e.toString()}");
    } finally {
      _posStream?.cancel;
    }
  }

  void setPermissionMsg() {
    if (permissionStatus == "Location permission required") {
      _permissionMsg.value =
          "This app needs location access to provide personalized services. Please enable location permissions.";
    } else if (permissionStatus == "Location permission permanently denied") {
      _permissionMsg.value =
          "Please enable location permissions in the app settings to use this feature.";
    } else {
      _permissionMsg.value =
          "Enable your device location for a better delivery experience and refresh the screen";
    }
  }

  void saveLocation(Pair value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CountryName", value.first);
    prefs.setString("CountryCode", value.second);
    Get.find<HomeController>().getCountryCode();
  }

  void isNewLocation(Pair value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value.first != prefs.getString("CountryName") ||
     value.second != prefs.getString("CountryCode")){
      saveLocation(value);
    } else{
      Get.find<HomeController>().getCountryCode();
    }
  }
}

class Pair {
  String first;
  dynamic second;

  Pair(this.first, this.second);
}
