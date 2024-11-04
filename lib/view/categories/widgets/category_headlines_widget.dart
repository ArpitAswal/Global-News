import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_news/controllers/categories_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/animation/custom_recttween.dart';
import '../../../utils/app_widgets/message_widgets.dart';
import '../../home/home_screen.dart';
import '../../news_detail_screen.dart';

class CategoryHeadlinesWidget extends StatefulWidget {
  const CategoryHeadlinesWidget(
      {super.key,
      required this.controller,
      required this.date,
      required this.index});

  final CategoriesController controller;
  final String date;
  final int index;

  @override
  State<CategoryHeadlinesWidget> createState() =>
      _CategoryHeadlinesWidgetState();
}

class _CategoryHeadlinesWidgetState extends State<CategoryHeadlinesWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return InkWell(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 600),
            reverseTransitionDuration: Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => NewsDetailScreen(article:
            widget.controller.categoriesData.value!.articles[widget.index], newsType: "CategoryHeadlines", index: widget.index,)));
      },
      child: Hero(
        tag: "${widget.controller.categoriesData.value!.articles[widget.index].title},${widget.index}",
        transitionOnUserGestures: true,
        createRectTween: (Rect? begin, Rect? end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: Container(
          height: height * .16,
          width: width,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.only(
              top: 0.0, bottom: 15.0, left: 12.0, right: 12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                    imageUrl: widget.controller.categoriesData.value!
                        .articles[widget.index].urlToImage
                        .toString(),
                    fit: BoxFit.cover,
                    height: height * .16,
                    width: width * .28,
                    placeholder: (context, url) => const Center(child: spinKit),
                    errorWidget: (context, url, error) =>
                        MessageWidgets.imageError(textSize: 14)),
              ),
              Expanded(
                child: Container(
                  height: height * .14,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Column(
                    children: [
                      Text(
                        widget.controller.categoriesData.value!
                            .articles[widget.index].title
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
                              widget.controller.categoriesData.value!
                                  .articles[widget.index].source!.name
                                  .toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            widget.date,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black45,
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
