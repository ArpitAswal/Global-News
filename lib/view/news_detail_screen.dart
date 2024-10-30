import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/articles_model.dart';
import '../utils/app_widgets/message_widgets.dart';
import 'categories/categories_screen.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key});
  static const screenRouteName = '/news_detail_screen';

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  Articles article = Get.arguments[0];
  int index = Get.arguments[1];
  Map<String, String?> newsType = Get.parameters;
  final format = DateFormat('MMMM dd,yyyy');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime dateTime = DateTime.parse(article.publishedAt!);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: SizedBox(
            height: 30,
            width: width,
          )),
      body: Stack(
        children: [
          Hero(
            tag: "$newsType: ${article.urlToImage ?? 'index $index is null'}",
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21.0),
              child: CachedNetworkImage(
                  imageUrl: article.urlToImage.toString(),
                  fit: BoxFit.fill,
                  height: height * .5,
                  width: width,
                  filterQuality: FilterQuality.high,
                  placeholder: (context, url) => const Center(child: spinKit),
                  errorWidget: (context, url, error) =>
                      MessageWidgets.imageError(textSize: 14)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.45),
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            height: height * 0.6,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: ListView(
              children: [
                Text(article.title ?? '',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Site:",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: () => launchURL(article.url!.toString()),
                          child: Text(
                            article.url ?? '',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  article.description ?? '',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      textBaseline: TextBaseline.ideographic),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(article.content ?? '',
                    maxLines: 20,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          article.source?.name ?? '',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '(source)',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            article.author ?? 'Anonymous',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '(author)',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          format.format(dateTime),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '(published)',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.03,
                ),
              ],
            ),
          ),
          Positioned(
            top: height * 0.02,
            left: width * 0.02,
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                  size: 30.0,
                )),
          ),
        ],
      ),
    );
  }

  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppBrowserView,
      );
    } else {
      MessageWidgets.showSnackBar('Could not launch $url');
    }
  }
}
