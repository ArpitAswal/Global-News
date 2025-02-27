import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news/utils/app_widgets/alert_notify_widgets.dart';
import 'package:global_news/utils/app_widgets/headlines_widget.dart';
import 'package:global_news/utils/app_widgets/news_list_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../utils/app_widgets/shimmer_headlines.dart';
import '../chat/chat_screen.dart';
import '../all_news_views/news_search_screen.dart';
import 'categories_screen.dart';

class HeadlinesNewsScreen extends StatefulWidget {
  const HeadlinesNewsScreen({super.key});
  static const screenRouteName = '/home_screen';

  @override
  State<HeadlinesNewsScreen> createState() => _HeadlinesNewsScreenState();
}

class _HeadlinesNewsScreenState extends State<HeadlinesNewsScreen>
    with WidgetsBindingObserver {
  final HomeController controller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final alert = AlertNotifyWidgets();
  final format = DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _horizontalScrollController.addListener(_onHorizontalScroll);
    _verticalScrollController.addListener(_onVerticalScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.initialPermission();
    }
  }

  void _onHorizontalScroll() {
    if (_horizontalScrollController.position.atEdge) {
      if (_horizontalScrollController.position.pixels != 0) {
        // User has scrolled to the end of the horizontal list
        controller.endHeadlines();
      }
    }
  }

  void _onVerticalScroll() {
    if (_verticalScrollController.position.atEdge) {
      if (_verticalScrollController.position.pixels != 0) {
        // User has scrolled to the end of the vertical list
        controller.endCountryNews();
      }
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: Text('Are you sure?'),
            titleTextStyle: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
            titlePadding: EdgeInsets.only(top: 16.0, left: 16.0),
            content: Text('Do you want to exit the app?'),
            contentTextStyle: TextStyle(color: Colors.black54),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
            actionsPadding: EdgeInsets.zero,
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(),
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.blue,
            onRefresh: () async {
              await controller.initialPermission(refresh: true);
            },
            child: BuildScreenAndChat(
              mainContent: _buildMainContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: controller.countryNames.map((country) {
            return ListTile(
              title: Text(country),
              onTap: () {
                if (controller.selectedCountry.value != country) {
                  controller.setSelectedCountry(country);
                }
                Navigator.of(context).pop();
              },
              trailing: CountryFlag.fromCountryCode(
                controller
                    .countryCodes[controller.countryNames.indexOf(country)],
                width: 40,
                height: 24,
                shape: const RoundedRectangle(6),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      controller: _verticalScrollController,
      slivers: [
        _buildSliverAppBar(),
        _buildHorizontalNewsList(),
        _buildCountryNewsHeader(),
        _buildVerticalNewsList(),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: false,
      pinned: false,
      expandedHeight: 60,
      title: Text(
        'Top Headlines',
        style: GoogleFonts.almendra(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Get.find<ChatController>().hideChatScreen();
          Get.toNamed(NewsCategoryScreen.screenRouteName);
        },
        icon: Image.asset(
          'images/category_icon.png',
          height: 24,
          width: 24,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Get.to(() => SearchScreen());
          },
        ),
        GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: CircleAvatar(
            radius: 18,
            child: Obx(() => (controller.cntCode.value.isNotEmpty)
                ? CountryFlag.fromCountryCode(
                    controller.cntCode.value,
                    shape: const Circle(),
                  )
                : Icon(Icons.public)),
          ),
        ),
        SizedBox(width: Get.width * 0.02),
      ],
    );
  }

  Widget _buildHorizontalNewsList() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.headlineShimmer.value) {
          return SizedBox(
            height: Get.height * .5,
            width: Get.width,
            child: const ShimmerHeadlines(isHeadline: true),
          );
        } else if (controller.errorHeadline.value == true &&
            controller.headlinesData.isEmpty) {
          return alert.errorContainer(
            height: 0.325,
            head: "Oups! Something went wrong",
            msg:
                "We encountered an error while fetching your data from server. Please try again by refreshing your screen.",
          );
        } else if (controller.headlinesData.isEmpty) {
          return alert.errorContainer(
            height: 0.325,
            head: "Oups! No Top-Headlines",
            msg:
                "We apologize for this inconvenience. We will make sure to add Top-Headlines later.",
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: ListView.builder(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: controller.headlinesData.length + 1,
              itemBuilder: (context, index) {
                if (index < controller.headlinesData.length) {
                  DateTime dateTime = DateTime.parse(
                      controller.headlinesData[index].publishedAt.toString());
                  if (controller.headlinesData[index].author == null &&
                      controller.headlinesData[index].title == "[Removed]") {
                    return const SizedBox();
                  } else {
                    return HeadlinesWidget(
                      dateAndTime: format.format(dateTime),
                      index: index,
                      controller: controller,
                    );
                  }
                } else if (controller.errorHeadline.value == true &&
                    controller.headlinesData.isNotEmpty) {
                  return Center(child: alert.loadingError());
                } else if (controller.noMoreHeadNews.value) {
                  return Center(
                    child: SizedBox(
                      height: 50,
                      child: alert.showNoMoreArticles(),
                    ),
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      width: 100,
                      child: alert.dataLoading(),
                    ),
                  );
                }
              },
            ),
          );
        }
      }),
    );
  }

  Widget _buildCountryNewsHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0).copyWith(top: 10.0),
        child: Text(
          "Country News for you",
          style: GoogleFonts.aclonica(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalNewsList() {
    return Obx(() {
      if (controller.countryShimmer.value) {
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return ShimmerHeadlines(isHeadline: false);
        }, childCount: 8));
      } else if (controller.errorCountry.value == true &&
          controller.cntNewsData.isEmpty) {
        return SliverToBoxAdapter(
          child: alert.errorContainer(
            height: 0.325,
            head: "Oups! Something went wrong",
            msg:
                "We encountered an error while fetching your data from server. Please try again by refreshing your screen.",
          ),
        );
      } else if (controller.cntNewsData.isEmpty) {
        return SliverToBoxAdapter(
          child: alert.errorContainer(
            height: 0.325,
            head: "Oups! No Country News",
            msg:
                "We apologize for this inconvenience. We will make sure to add news articles related to this country.",
          ),
        );
      } else {
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          if (index < controller.cntNewsData.length) {
            DateTime dateTime = DateTime.parse(
                controller.cntNewsData[index].publishedAt.toString());
            if (controller.cntNewsData[index].author == null &&
                controller.cntNewsData[index].title == "[Removed]") {
              return const SizedBox();
            } else {
              return NewsListItem(
                  article: controller.cntNewsData[index],
                  date: format.format(dateTime),
                  index: index,
                  newsType: "MiniHeadlines");
            }
          } else if (controller.errorCountry.value == true &&
              controller.cntNewsData.isNotEmpty) {
            return Center(child: alert.loadingError());
          } else if (controller.noMoreCntNews.value) {
            return Center(
              child: SizedBox(
                height: 50,
                width: 100,
                child: alert.showNoMoreArticles(),
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: 100,
                child: alert.dataLoading(),
              ),
            );
          }
        }, childCount: controller.cntNewsData.length + 1));
      }
    });
  }
}

