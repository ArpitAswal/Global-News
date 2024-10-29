import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';

class LocationAlert extends StatelessWidget {
  LocationAlert({super.key});
  final controller = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey[400],
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: Get.width,
        height: Get.height * .12,
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_off_rounded,
                color: Colors.red,
                size: Get.height * .04,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.permissionStatus,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      controller.permissionMsg,
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: Colors.red[500],
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 12.0)),
                child: const Text(
                  'Enable',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Geolocator.openLocationSettings().whenComplete(Get.back);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
