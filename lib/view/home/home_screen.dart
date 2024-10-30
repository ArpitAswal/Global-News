import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/location_controller.dart';
import 'package:global_news/utils/app_widgets/message_widgets.dart';
import 'package:global_news/view/home/widgets/headlines_widget.dart';
import 'package:global_news/view/home/widgets/mini_headlines_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/home_controller.dart';
import '../../utils/app_widgets/shimmer_headlines.dart';
import '../categories/categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const screenRouteName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final ctrl = Get.find<LocationController>();
  final format = DateFormat('MMMM dd, yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController controller = Get.find<HomeController>();
  final ScrollController _verticalScroll = ScrollController();
  final ScrollController _horizontalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _verticalScroll.addListener(_onScroll);
    _horizontalScroll.addListener(_onHScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _verticalScroll.removeListener(_onScroll);
    _verticalScroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_verticalScroll.position.atEdge) {
      if (_verticalScroll.position.pixels ==
          _verticalScroll.position.maxScrollExtent) {
        controller
            .endCountryNews(); // Call endCountryNews at the end of the list
      }
    }
  }

  void _onHScroll() {
    if (_horizontalScroll.position.atEdge) {
      if (_horizontalScroll.position.pixels ==
          _horizontalScroll.position.maxScrollExtent) {
        controller.endHeadlines();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check location permission when app resumes
      ctrl.getCurrentLocation().then((value) {
        if (value.second == false) {
          ctrl.statusPermission = value.first;
          ctrl.setPermissionMsg();
          ctrl.bottomSheet();
        } else {
          ctrl.saveLocation(value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: controller.countryNames.map((country) {
              return ListTile(
                title: Text(country),
                onTap: () {
                  int index = controller.countryNames.indexOf(country);
                  controller.setSelectedCountry(country, index);
                  Navigator.of(context).pop(); // Close the drawer
                },
              );
            }).toList(),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: Obx(
          () => (controller.isSearching.value)
              ? searchAppBar(ctrl: controller)
              : AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Get.toNamed(CategoriesScreen.screenRouteName);
                    },
                    icon: Image.asset(
                      'images/category_icon.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  title: Text(
                    'Top 100 Headlines',
                    style: GoogleFonts.almendra(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple),
                  ),
                  centerTitle: true,
                  actions: [
                    if (!controller.isSearching.value)
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          controller.toggleSearch();
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.public), // Globe icon
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ],
                ),
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            await controller.getCountryCode();
          },
          child: CustomScrollView(
            controller: _verticalScroll,
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                // SliverToBoxAdapter plays a crucial role in creating precise and efficient scrolling experiences. It essentially helps to display a single box widget inside the CustomScrollView, making the widget capable of working with slivers. This enables a more flexible layout with the ability to mix multiple widgets with different scroll effects in a scrollable area.
                child: Obx(() {
                  if (controller.headlineShimmer.value) {
                    return const ShimmerHeadlines("headlineShimmer");
                  } else if (controller.errorHeadline.value == true &&
                      controller.headlinesData.value == null) {
                    return SizedBox(
                      height: Get.height * 0.35,
                      child: MessageWidgets.errorContainer(
                          height: 0.35,
                          head: "Oups! Something went wrong",
                          msg:
                              "We encountered an error while fetching your data from server. please try again by refreshing your screen."),
                    );
                  } else if (controller.headlinesData.value != null &&
                      controller.headlinesData.value!.totalResults == 0) {
                    return SizedBox(
                      height: Get.height * 0.35,
                      child: MessageWidgets.errorContainer(
                          height: 0.35,
                          head: "Oups! No Top- Headlines",
                          msg:
                              "We apologies for this inconvenience, we will make sure that we would add Top-Headlines related to this country."),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .5,
                      child: ListView.builder(
                        controller: _horizontalScroll,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            controller.headlinesData.value!.articles.length + 1,
                        itemBuilder: (context, index) {
                          if (index <
                              controller.headlinesData.value!.articles.length) {
                            DateTime dateTime = DateTime.parse(controller
                                .headlinesData
                                .value!
                                .articles[index]
                                .publishedAt
                                .toString());
                            if (controller.headlinesData.value!.articles[index]
                                        .author ==
                                    null &&
                                controller.headlinesData.value!.articles[index]
                                        .title ==
                                    "[Removed]") {
                              return const SizedBox();
                            } else {
                              return HeadlinesWidget(
                                dateAndTime: format.format(dateTime),
                                index: index,
                                controller: controller,
                              );
                            }
                          } else if (controller.errorHeadline.value ||
                              controller.headlinesData.value == null) {
                            return Center(child: MessageWidgets.loadingError());
                          } else if (controller.noMoreHeadNews.value) {
                            return Center(
                                child: SizedBox(
                                    height: 50,
                                    child:
                                        MessageWidgets.showNoMoreArticles()));
                          } else {
                            return const Center(
                              child: SizedBox(
                                width: 100,
                                child: spinKit,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                }),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text("Country News for you",
                    style: GoogleFonts.aclonica(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
              )),
              Obx(() {
                if (controller.countryShimmer.value) {
                  return SliverToBoxAdapter(
                      child: const ShimmerHeadlines("countryShimmer"));
                } else if (controller.errorCountry.value == true &&
                    controller.cntNewsData.value == null) {
                  // we faced error while fetching data from API
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: Get.height * 0.35,
                      child: MessageWidgets.errorContainer(
                          height: 0.35,
                          head: "Oups! Something went wrong",
                          msg:
                              "We encountered an error while fetching your data from server. please try again by refreshing your screen."),
                    ),
                  );
                } else if (controller.cntNewsData.value != null &&
                    controller.cntNewsData.value!.totalResults == 0) {
                  // we don't have any news articles data related to country
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: Get.height * 0.35,
                      child: MessageWidgets.errorContainer(
                          height: 0.35,
                          head: "Oups! No Country News",
                          msg:
                              "We apologies for this inconvenience, we will make sure that we would add news articles related to this country."),
                    ),
                  );
                } else {
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index <
                          controller.cntNewsData.value!.articles.length) {
                        DateTime dateTime = DateTime.parse(controller
                            .cntNewsData.value!.articles[index].publishedAt
                            .toString());
                        if (controller.cntNewsData.value!.articles[index]
                                    .author ==
                                null &&
                            controller
                                    .cntNewsData.value!.articles[index].title ==
                                "[Removed]") {
                          return const SizedBox();
                          // if there are any data that are removed but still does not remove from server properly we would nor display those data
                        } else {
                          return MiniHeadlinesWidget(
                            dateAndTime: format.format(dateTime),
                            index: index,
                            controller: controller,
                          );
                        }
                      } else if (controller.errorCountry.value ||
                          controller.cntNewsData.value == null) {
                        // this is the case when we try to fetching the more data from server than currently we have and get error
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: MessageWidgets.loadingError(),
                        ));
                      } else if (controller.noMoreCntNews.value == true) {
                        return Center(
                            child: SizedBox(
                                width: 120,
                                child: MessageWidgets.showNoMoreArticles()));
                        // this is the case when we try to fetching the more data from server than currently we have and we already got full data from server than it will indicate that we don't have any more articles related to this country
                      } else {
                        // at last this case remain when we try to fetch more data than currently we have it will show spinner to indicate that more data is reloading
                        return const Center(
                          child: SizedBox(
                            width: 100,
                            child: spinKit,
                          ),
                        );
                      }
                    },
                    childCount:
                        controller.cntNewsData.value!.articles.length + 1,
                  ));
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget searchAppBar({required HomeController ctrl}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search...',
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black, style: BorderStyle.solid)),
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black, style: BorderStyle.solid)),
        ),
        onChanged: (value) {
          controller.setSearchText(value);
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            controller.performSearch();
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          color: Colors.black,
          onPressed: () {
            controller.toggleSearch();
            if (controller.searchText.value.isNotEmpty) {
              controller.searchText.value = '';
              controller.performSearch();
            }
          },
        ),
        SizedBox(
          width: Get.width * 0.035,
        )
      ],
    );
  }
}

const spinKit = SpinKitFadingCircle(
  color: Colors.cyan,
  size: 50,
);
