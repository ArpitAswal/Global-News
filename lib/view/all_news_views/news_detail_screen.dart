import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/voice_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/articles_model.dart';
import '../../utils/app_widgets/alert_notify_widgets.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen(
      {super.key,
      required this.article,
      required this.newsType,
      required this.index});

  final Articles article;
  final String newsType;
  final int index;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMMM dd,yyyy');
  final controller = Get.put(VoiceController());
  final alert = AlertNotifyWidgets();

  @override
  void dispose() {
    Get.delete<VoiceController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime? dateTime = (widget.article.publishedAt != null)
        ? DateTime.parse(widget.article.publishedAt.toString())
        : null;
    String? date = (dateTime != null) ? format.format(dateTime) : null;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: SizedBox(
            height: 30,
            width: width,
          )),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () {
            (controller.ttsState.value)
                ? controller.stop()
                : controller.speak(
                    firstMsg: widget.article.title ?? "",
                    secondMsg: widget.article.description ?? "",
                    thirdMsg: widget.article.content ?? "");
          },
          tooltip: "Read aloud",
          mini: true,
          shape: CircleBorder(),
          child:
              Icon((controller.ttsState.value) ? Icons.stop : Icons.play_arrow),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(height: height, width: width),
          Hero(
            tag: "${widget.article.title},${widget.index}",
            transitionOnUserGestures: true,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: CachedNetworkImage(
                  imageUrl: widget.article.urlToImage.toString(),
                  fit: BoxFit.fill,
                  height: height * .55,
                  width: width,
                  filterQuality: FilterQuality.high,
                  placeholder: (context, url) =>
                      Center(child: alert.dataLoading()),
                  errorWidget: (context, url, error) =>
                      alert.imageError(textSize: 14)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: height * 0.45),
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              height: height * 0.45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(21),
                      topRight: Radius.circular(21))),
              child: ListView(
                children: [
                  Text(widget.article.title ?? "No News Title!",
                      softWrap: true,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.aclonica(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w800)),
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
                      SizedBox(width: 8.0),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (widget.article.url != null &&
                                widget.article.url!.isNotEmpty) {
                              launchURL(widget.article.url!.toString());
                            }
                          },
                          child: Text(
                            widget.article.url ?? 'No site available',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    widget.article.description ?? 'No News Description!',
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        textBaseline: TextBaseline.ideographic),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(widget.article.content ?? "No News Content!",
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.article.source?.name ?? 'Unknown Source',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.alumniSans(
                                fontSize: 14,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '(source)',
                            style: GoogleFonts.abel(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.article.author ?? 'Anonymous',
                              style: GoogleFonts.alumniSans(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '(author)',
                              style: GoogleFonts.abel(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            date ?? "No Published Date",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.alumniSans(
                                fontSize: 14,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '(published)',
                            style: GoogleFonts.abel(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
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
      alert.showSnackBar('Could not launch $url');
    }
  }
}
