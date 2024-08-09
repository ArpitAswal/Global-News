import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:global_news/app_widgets/image_load_error.dart';
import 'package:global_news/controllers/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../news_detail_screen.dart';

class MiniHeadlinesWidget extends StatelessWidget {
  final String dateAndTime;
  final int index;
  final HomeController controller;
  const MiniHeadlinesWidget(
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
        Map<String, String> newsLine = {'news': 'MiniHeadlines'};
        Get.toNamed(NewsDetailScreen.screenRouteName,
            arguments: [controller.cntNewsData.value!.articles[index], index],
            parameters: newsLine);
      },
      child: Hero(
        tag:
            "MiniHeadLines: ${controller.cntNewsData.value!.articles[index].urlToImage ?? 'index $index is null'}",
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
          margin: const EdgeInsets.only(
              top: 0.0, left: 10.0, right: 10.0, bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                    imageUrl: controller
                        .cntNewsData.value!.articles[index].urlToImage
                        .toString(),
                    fit: BoxFit.cover,
                    height: height * .15,
                    width: width * .25,
                    placeholder: (context, url) => const Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        ImageLoadError().imageError(textSize: 11.0)),
              ),
              Expanded(
                child: Container(
                  height: height * .15,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Text(
                        controller.cntNewsData.value!.articles[index].title
                            .toString(),
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.cntNewsData.value!.articles[index]
                                  .source!.name
                                  .toString(),
                              style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            dateAndTime,
                            style: GoogleFonts.poppins(
                                color: Colors.black45,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
