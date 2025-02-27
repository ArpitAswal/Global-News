import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:global_news/models/articles_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../animation/custom_recttween.dart';
import 'alert_notify_widgets.dart';
import '../../view/all_news_views/news_detail_screen.dart';

class NewsListItem extends StatelessWidget {
  final String date;
  final int index;
  final Articles article; // Use dynamic to handle different data types
  final String newsType;

  const NewsListItem({
    super.key,
    required this.date,
    required this.index,
    required this.article,
    required this.newsType,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            reverseTransitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => NewsDetailScreen(
              article: article,
              newsType: newsType,
              index: index,
            ),
          ),
        );
      },
      child: Container(
        height: height * .15,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            Hero(
              tag: "${article.title},$index",
              transitionOnUserGestures: true,
              createRectTween: (Rect? begin, Rect? end) {
                return CustomRectTween(begin: begin, end: end);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage.toString(),
                  fit: BoxFit.cover,
                  height: height * .15,
                  width: width * .28,
                  placeholder: (context, url) => const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      AlertNotifyWidgets().imageError(textSize: 11.0),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        article.title.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            article.source!.name.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          date,
                          style: GoogleFonts.poppins(
                            color: Colors.black45,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}