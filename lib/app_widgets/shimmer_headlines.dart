import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHeadlines extends StatelessWidget {
  const ShimmerHeadlines(this.s, {super.key});

  final String s;

  @override
  Widget build(BuildContext context) {
    if (s == "headlineShimmer") {
      return SizedBox(
        height: Get.height * .5,
        width: Get.width,
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    height: Get.height * .5,
                    width: Get.width * .7,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21.0)),
                  );
                })),
      );
    } else if (s == "countryShimmer") {
      return SizedBox(
        width: Get.width,
        height: Get.height - Get.height * .5,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                height: Get.height * .15,
                width: Get.width * .25,
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0)),
              );
            },
            itemCount: 8,
            scrollDirection: Axis.vertical,
          ),
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              height: Get.height * .16,
              width: Get.width,
              margin:
                  const EdgeInsets.only(bottom: 15.0, left: 12.0, right: 12.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0)),
            );
          },
          itemCount: 8,
          scrollDirection: Axis.vertical,
        ),
      );
    }
  }
}
