import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHeadlines extends StatelessWidget {
  const ShimmerHeadlines(this.s, {super.key});

  final String s;

  @override
  Widget build(BuildContext context) {
    if (s == "headlineShimmer") {
      return ListView.builder(
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
                child: Stack(
                  children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey.shade400,
                    child: Container(
                      height: Get.height * .4,
                      width: Get.width * .75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 2,
                      child: Card(
                          elevation: 7,
                          shadowColor: Colors.grey[400],
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey.shade400,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              height: Get.height * .18,
                              width: Get.width * .7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: Get.height * .015,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(14.0)),
                                  ),
                                  Container(
                                    height: Get.height * .015,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(14.0)),
                                  ),
                                  Container(
                                    height: Get.height * .015,
                                    width: Get.width * .35,
                                    margin: EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(14.0)),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: Get.height * .015,
                                          width: Get.width * .15,
                                          margin: EdgeInsets.only(left: 12.0, top: 30.0, right: 12.0),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(14.0)),
                                        ),
                                        Container(
                                          height: Get.height * .015,
                                          width: Get.width * .2,
                                          margin: EdgeInsets.only(left: 12.0, top: 30.0, right: 12.0),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(14.0)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      ))
                  ]
                ),
            );
          });
    } else {
      return shimmerListView();
    }
  }

  Widget shimmerListView(){
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          height: Get.height * .15,
          width: Get.width * .1,
          margin: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.0)),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: Get.height * .15,
                    width: Get.width * .28,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14.0)),
                  ),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: Get.height * .015,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 8.0, top: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14.0)),
                      ),
                      Container(
                        height: Get.height * .015,
                        width: Get.width * .4,
                        margin: EdgeInsets.only(left: 8.0, top: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14.0)),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: Get.height * .015,
                              width: Get.width * .15,
                              margin: EdgeInsets.only(left: 8.0, top: 30.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(14.0)),
                            ),
                            Container(
                              height: Get.height * .015,
                              width: Get.width * .2,
                              margin: EdgeInsets.only(left: 8.0, top: 30.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(14.0)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        );
      },
      itemCount: 8,
      scrollDirection: Axis.vertical,
    );
  }
}
