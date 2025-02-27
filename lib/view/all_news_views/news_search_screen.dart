import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news/utils/app_widgets/alert_notify_widgets.dart';
import 'package:global_news/utils/app_widgets/shimmer_headlines.dart';
import 'package:global_news/view/chat/chat_screen.dart';
import 'package:global_news/utils/app_widgets/news_list_widget.dart';
import 'package:intl/intl.dart';

import '../../controllers/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final queryText = TextEditingController();
  final controller = Get.put(SearchingController());
  final format = DateFormat('MMMM dd, yyyy');
  final _debouncer = Debouncer(milliseconds: 500);
  final alert = AlertNotifyWidgets();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _verticalScrollController.addListener(_onVerticalScroll);
  }

  void _onVerticalScroll() {
    if (_verticalScrollController.position.atEdge) {
      if (_verticalScrollController.position.pixels != 0) {
        // User has scrolled to the end of the vertical list
        controller.reachBottom();
      }
    }
  }

  void fetchQuery(String text) {
    _debouncer.run(() async {
      await controller.searchNews(query: text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SafeArea(child: BuildScreenAndChat(mainContent: _buildMainContent())),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.deepPurple.shade100,
              blurRadius: 6.0,
              spreadRadius: 0.1),
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 5,
                child: TextFormField(
                  controller: queryText,
                  style: TextStyle(
                      color: Colors.deepPurple,
                      textBaseline: TextBaseline.alphabetic,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.white),
                  cursorColor: Colors.deepPurple,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.white, width: 2.0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.white, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.white, width: 2.0)),
                    hintText: "Search News",
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                    hintStyle: TextStyle(color: Colors.deepPurple),
                  ),
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    fetchQuery(value);
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  fetchQuery(queryText.text);
                },
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      border: Border.all(color: Colors.white)),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isSearching.value) {
              return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ShimmerHeadlines(isHeadline: false);
                  },
                  itemCount: 8);
            } else if (controller.searchError.value == true &&
                controller.searchData.isEmpty) {
              return alert.errorContainer(
                msg:
                    "We encountered an error while loading your query, please try again!",
                height: 0.325,
                head: "Oops! Something went wrong",
              );
            } else if (controller.searchData.isNotEmpty) {
              return ListView.builder(
                controller: _verticalScrollController,
                itemCount: controller.searchData.length + 1,
                itemBuilder: (context, index) {
                  if (index < controller.searchData.length) {
                    DateTime dateTime = DateTime.parse(
                        controller.searchData[index].publishedAt.toString());
                    if (controller.searchData[index].author == null &&
                        controller.searchData[index].title == "[Removed]") {
                      return const SizedBox();
                    } else {
                      return NewsListItem(
                        date: format.format(dateTime),
                        index: index,
                        article: controller.searchData[index],
                        newsType: 'SearchNewsLines',
                      );
                    }
                  } else if (controller.searchError.value &&
                      controller.searchData.isNotEmpty) {
                    return Center(child: alert.loadingError());
                  } else if (controller.noMoreSearchNews.value) {
                    return Center(
                        child: SizedBox(
                            height: 50,
                            width: 100,
                            child: alert.showNoMoreArticles()));
                  } else {
                    return Center(
                      child: SizedBox(
                        width: 100,
                        child: alert.dataLoading(),
                      ),
                    );
                  }
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_search_rounded,
                      size: 100,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text("Search Data...")
                  ],
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
