import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:global_news/view/home/widgets/headlines_widget.dart';
import 'package:global_news/view/home/widgets/mini_headlines_widget.dart';
import 'package:global_news/app_widgets/shimmer_headlines.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../controllers/home_controller.dart';
import '../categories/categories_screen.dart';

class HomeScreen extends GetView<HomeController> {
  static const screenRouteName = '/home_screen';

  final format = DateFormat('MMMM dd, yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeScreen({super.key});

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
              ? AppBar(
                  automaticallyImplyLeading: false,
                  title: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black, style: BorderStyle.solid)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black, style: BorderStyle.solid)),
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
                      width: MediaQuery.of(context).size.width * 0.035,
                    )
                  ],
                )
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
                    'News',
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w700),
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
      body: LazyLoadScrollView(
        onEndOfPage: () {
          controller.endCountryNews();
        },
        child: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            await controller.getCountryCode();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.headlineShimmer.value) {
                    return const ShimmerHeadlines("headlineShimmer");
                  } else if (controller.errorHeadline.value == true &&
                      controller.headlinesData.value == null) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .5,
                      child: const Center(
                          child: Text('Failed to fetch Headlines News.')),
                    );
                  } else if (controller.headlinesData.value != null &&
                      controller.headlinesData.value!.totalResults == 0) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .4,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          "There are no top-headlines regarding your query",
                          softWrap: true,
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    );
                  } else {
                    return LazyLoadScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .5,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              controller.headlinesData.value!.articles.length +
                                  (controller.headlinesMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index <
                                controller
                                    .headlinesData.value!.articles.length) {
                              DateTime dateTime = DateTime.parse(controller
                                  .headlinesData
                                  .value!
                                  .articles[index]
                                  .publishedAt
                                  .toString());
                              if (controller.headlinesData.value!
                                          .articles[index].author ==
                                      null &&
                                  controller.headlinesData.value!
                                          .articles[index].title ==
                                      "[Removed]") {
                                return const SizedBox();
                              } else {
                                return HeadlinesWidget(
                                  dateAndTime: format.format(dateTime),
                                  index: index,
                                  controller: controller,
                                );
                              }
                            } else if (controller.errorHeadline.value &&
                                controller.headlinesData.value != null) {
                              return const Center(
                                  child: Text('Error loading more articles.'));
                            } else if (controller.errorHeadline.value ==
                                    false &&
                                controller.headlinesData.value != null &&
                                controller.noMoreHeadlines.value == true) {
                              return const Center(
                                  child: Text('No more articles.'));
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
                      ),
                      onEndOfPage: () {
                        controller.endHeadlines();
                      },
                    );
                  }
                }),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 12.0),
              ),
              Obx(() {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (controller.countryShimmer.value) {
                        return const ShimmerHeadlines("countryShimmer");
                      } else if (controller.errorCountry.value == true &&
                          controller.cntNewsData.value == null) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: const Center(
                              child: Text('Failed to fetch Country News.')),
                        );
                      } else if (controller.cntNewsData.value != null &&
                          controller.cntNewsData.value!.totalResults == 0) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text(
                              "There are no articles regarding your query",
                              softWrap: true,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ),
                        );
                      } else {
                        if (index <
                            controller.cntNewsData.value!.articles.length) {
                          DateTime dateTime = DateTime.parse(controller
                              .cntNewsData.value!.articles[index].publishedAt
                              .toString());
                          if (controller.cntNewsData.value!.articles[index]
                                      .author ==
                                  null &&
                              controller.cntNewsData.value!.articles[index]
                                      .title ==
                                  "[Removed]") {
                            return const SizedBox();
                          } else {
                            return MiniHeadlinesWidget(
                              dateAndTime: format.format(dateTime),
                              index: index,
                              controller: controller,
                            );
                          }
                        } else if (controller.errorCountry.value &&
                            controller.cntNewsData.value != null) {
                          return const Center(
                              child: Text('Error loading more articles.'));
                        } else if (controller.errorCountry.value == false &&
                            controller.cntNewsData.value != null &&
                            controller.noMoreCntNews.value == true) {
                          return const Center(child: Text('No more articles.'));
                        } else {
                          return const Center(
                            child: SizedBox(
                              width: 100,
                              child: spinKit,
                            ),
                          );
                        }
                      }
                    },
                    childCount: controller.cntNewsData.value?.articles.length ??
                        2 + (controller.cntNewsMore.value ? 1 : 0),
                  ),
                );
              }),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.permissionStatus.value != "Allow") {
                    // Show modal bottom sheet if location is disabled
                    Future.microtask(() => bottomSheetCard(
                        context, controller.permissionStatus.value));
                  }
                  return const SizedBox();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const spinKit = SpinKitFadingCircle(
  color: Colors.cyan,
  size: 50,
);

void bottomSheetCard(BuildContext context, String value) {
  late String msg;
  if (HomeController().permissionStatus.value ==
      "Location permission required") {
    msg =
        "This app needs location access to provide personalized services. Please enable location permissions.";
  } else if (HomeController().permissionStatus.value ==
      "Location permission permanently denied") {
    msg =
        "Please enable location permissions in the app settings to use this feature.";
  } else {
    msg =
        "Enable your device location for a better delivery experience and refresh the screen";
  }
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext context) {
      return Card(
        elevation: 5,
        shadowColor: Colors.grey[400],
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: Get.width,
          height: Get.height * .12,
          margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_off_rounded,
                  color: Colors.red,
                  size: Get.height * .04,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        msg,
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black45, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.red[500],
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 12.0)),
                  child: const Text(
                    'Enable',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Geolocator.openLocationSettings();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
