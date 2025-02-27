import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHeadlines extends StatelessWidget {
  const ShimmerHeadlines({
    required this.isHeadline,
    super.key,
  });

  final bool isHeadline;

  @override
  Widget build(BuildContext context) {
    return isHeadline ? _buildHeadlineShimmer() : _buildCountryNewsShimmer();
  }

  Widget _buildHeadlineShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) {
        return _ShimmerItem(
          height: Get.height * .5,
          width: Get.width * .7,
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
                    child: _ShimmerContent(
                      height: Get.height * .18,
                      width: Get.width * .7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryNewsShimmer() {
    return _ShimmerItem(
      height: Get.height * .15,
      width: Get.width * .1,
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
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              Expanded(
                child: _ShimmerContent(
                  height: Get.height * .15,
                  width: Get.width * .4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  const _ShimmerItem({
    required this.height,
    required this.width,
    required this.child,
  });

  final double height;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.0),
      ),
      child: child,
    );
  }
}

class _ShimmerContent extends StatelessWidget {
  const _ShimmerContent({
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: Get.height * .015,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          Container(
            height: Get.height * .015,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          Container(
            height: Get.height * .015,
            width: width * .5,
            margin: const EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: Get.height * .015,
                  width: width * .3,
                  margin:
                      const EdgeInsets.only(left: 12.0, top: 30.0, right: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                Container(
                  height: Get.height * .015,
                  width: width * .4,
                  margin:
                      const EdgeInsets.only(left: 12.0, top: 30.0, right: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
