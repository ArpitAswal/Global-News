import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news/app_widgets/image_load_error.dart';
import 'package:global_news/controllers/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../news_detail_screen.dart';
import '../home_screen.dart';

class HeadlinesWidget extends StatelessWidget {
  final String dateAndTime;
  final int index;
  final HomeController controller;
  const HeadlinesWidget(
      {Key? key,
      required this.dateAndTime,
      required this.index,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return InkWell(
      onTap: () {
        Map<String, String> newsLine = {'news': 'Headlines'};
        Get.toNamed(NewsDetailScreen.screenRouteName,
            arguments: [controller.headlinesData.value!.articles[index], index],
            parameters: newsLine);
      },
      child: Hero(
        tag:
            "Headlines: ${controller.headlinesData.value!.articles[index].urlToImage ?? 'index $index is null'}",
        transitionOnUserGestures: true,
        flightShuttleBuilder:
            (flightContext, animation, direction, fromContext, toContext) {
          return const Icon(
            Icons.image_rounded,
            size: 150.0,
          );
        },
        createRectTween: (Rect? begin, Rect? end) {
          return MaterialRectCenterArcTween(begin: begin, end: end);
        },
        child: Container(
            height: height * .4,
            width: width * .75,
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: height * .4,
                  width: width * .75,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: controller.headlinesData.value!
                                .articles[index].urlToImage ??
                            '',
                        placeholder: (context, url) => Container(
                              child: spinKit,
                            ),
                        errorWidget: (context, url, error) =>
                            ImageLoadError().imageError()),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  child: Card(
                    elevation: 7,
                    shadowColor: Colors.grey[400],
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: height * .18,
                      width: width * .7,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.headlinesData.value!.articles[index]
                                    .title ??
                                '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.headlinesData.value!
                                          .articles[index].source!.name ??
                                      '',
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 26.0),
                                child: Text(
                                  dateAndTime,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
