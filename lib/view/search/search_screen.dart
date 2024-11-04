import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:global_news/utils/app_widgets/message_widgets.dart';
import 'package:global_news/utils/app_widgets/shimmer_headlines.dart';
import 'package:global_news/view/search/widgets/search_newsline_widget.dart';
import 'package:intl/intl.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/search_controller.dart';
import '../../utils/app_widgets/chat_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final format = DateFormat('MMMM dd, yyyy');
  final query = TextEditingController();
  final ScrollController _verticalScroll = ScrollController();
  final controller = Get.put(SearchingController(), permanent: true);
  final chatCtrl = Get.find<ChatController>();
  final _prompt = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _verticalScroll.addListener(_onScroll);
    query.text = controller.searchText.value;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _verticalScroll.removeListener(_onScroll);
    _verticalScroll.dispose();
    _animationController.dispose();
    _prompt.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_verticalScroll.position.atEdge) {
      if (_verticalScroll.position.pixels ==
          _verticalScroll.position.maxScrollExtent) {
        controller.endSearchNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 8.0,
                          spreadRadius: 4.0),
                      BoxShadow(
                          color: Colors.deepPurpleAccent.shade100,
                          blurRadius: 8.0,
                          spreadRadius: 0.3)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                        controller: query,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12)),
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Search News",
                          filled: true,
                          fillColor: Colors.deepPurple.shade100,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          fetchQuery(value);
                        },
                      ),
                    ),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          if (query.text.isEmpty) {
                            fetchQuery(query.text);
                          } else {
                            query.text = "";
                            controller.clearQuery();
                          }
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
                          child: (controller.isSearching.value)
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Icon(
                                  (controller.searchText.value.isEmpty)
                                      ? Icons.search
                                      : Icons.clear,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isSearching.value) {
                    return ShimmerHeadlines("searchShimmer");
                  } else if (controller.searchError.value == true &&
                      controller.searchData.value == null) {
                    return SizedBox(
                      height: Get.height * .5,
                      child: MessageWidgets.errorContainer(
                        msg:
                            "We encountered an error while loading your query, please try again!",
                        height: 0.5,
                        head: "Oops! Something went wrong",
                      ),
                    );
                  } else if (controller.searchData.value != null &&
                      controller.searchData.value!.articles.isNotEmpty) {
                    return ListView.builder(
                      controller: _verticalScroll,
                      itemCount:
                          controller.searchData.value!.articles.length + 1,
                      itemBuilder: (context, index) {
                        if (index <
                            controller.searchData.value!.articles.length) {
                          final article =
                              controller.searchData.value!.articles[index];
                          final dateTime =
                              DateTime.parse(article.publishedAt.toString());
                          if (article.author == null &&
                              article.title == "[Removed]") {
                            return const SizedBox();
                          } else {
                            return SearchNewsLineWidget(
                              dateAndTime: format.format(dateTime),
                              index: index,
                              controller: controller,
                            );
                          }
                        } else if (controller.searchError.value ||
                            controller.searchData.value == null) {
                          // this is the case when we try to fetching the more data from server than currently we have and get error
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MessageWidgets.loadingError(),
                          ));
                        } else if (controller.noMoreSearchNews.value) {
                          return Center(
                              child: SizedBox(
                                  width: 120,
                                  child: MessageWidgets.showNoMoreArticles()));
                        } else {
                          return const Center(child: spinKit);
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
          ),
          ChatWidgets.chatButton(pressed: () {
            chatCtrl.toggleChat();
            chatCtrl.isChatOpen.value
                ? _animationController.forward()
                : _animationController.reverse();
          }),
          chatScreen()
        ]),
      ),
    );
  }

  Future<void> fetchQuery(String text) async {
    await controller.searchNews(text, true);
  }

  Widget chatScreen() {
    return GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            chatCtrl.toggleChat();
            chatCtrl.isChatOpen.value
                ? _animationController.forward()
                : _animationController.reverse();
          }
        },
        child: ChatWidgets.chatBox(_offsetAnimation, _prompt));
  }
}

const spinKit = SpinKitFadingCircle(
  color: Colors.cyan,
  size: 50,
);
