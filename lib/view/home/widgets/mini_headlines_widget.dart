import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/home_controller.dart';
import 'package:global_news/utils/app_widgets/message_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/animation/custom_recttween.dart';
import '../../news_detail_screen.dart';

class MiniHeadlinesWidget extends StatelessWidget {
  final String dateAndTime;
  final int index;
  final HomeController controller;
  const MiniHeadlinesWidget(
      {super.key,
      required this.dateAndTime,
      required this.index,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 600),
            reverseTransitionDuration: Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => NewsDetailScreen(article: controller.cntNewsData.value!.articles[index], newsType: "MiniHeadlines", index: index,)));
      },
      child: Container(
        height: Get.height * .15,
        width: Get.width,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "${controller.cntNewsData.value!.articles[index].title},$index",
              transitionOnUserGestures: true,
              createRectTween: (Rect? begin, Rect? end) {
                return CustomRectTween(begin: begin, end: end);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                    imageUrl: controller
                        .cntNewsData.value!.articles[index].urlToImage
                        .toString(),
                    fit: BoxFit.cover,
                    height: Get.height * .15,
                    width: Get.width * .28,
                    placeholder: (context, url) => const Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        MessageWidgets.imageError(textSize: 11.0)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        controller.cntNewsData.value!.articles[index].title
                            .toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
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
    );
  }
}
