import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/categories_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/app_widgets/alert_notify_widgets.dart';
import '../../utils/app_widgets/shimmer_headlines.dart';
import '../chat/chat_screen.dart';
import '../../utils/app_widgets/news_list_widget.dart';

class NewsCategoryScreen extends StatefulWidget {
  static const screenRouteName = '/categories_screen';
  const NewsCategoryScreen({super.key});

  @override
  State<NewsCategoryScreen> createState() => _NewsCategoryScreenState();
}

class _NewsCategoryScreenState extends State<NewsCategoryScreen> {
  final format = DateFormat('MMM dd, yyyy');
  final controller = Get.find<CategoriesController>();
  final ScrollController _verticalScrollController = ScrollController();
  final alert = AlertNotifyWidgets();

  @override
  void initState() {
    super.initState();
    _verticalScrollController.addListener(_onVerticalScroll);
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _onVerticalScroll() {
    if (_verticalScrollController.position.atEdge) {
      if (_verticalScrollController.position.pixels != 0) {
        // User has scrolled to the end of the vertical list
        controller.endCategoryNews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            await controller.fetchCategoryCountryNews(
                category: controller.selectedCategory.value,
                load: false,
                refresh: true);
          },
          child: BuildScreenAndChat(
            mainContent: _buildMainContent(),
          )),
    ));
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      controller: _verticalScrollController,
      slivers: [
        _buildSliverAppBar(),
        _buildCategories(),
        _buildVerticalNewsList(),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: false,
      pinned: false,
      expandedHeight: 60,
      title: Obx(
        () => Text(
          "${controller.selectedCategory.value} Category News",
          style: GoogleFonts.almendra(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_outlined,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: Get.height * .065,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          itemCount: controller.categoriesList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (controller.selectedCategory.value !=
                    controller.categoriesList[index]) {
                  controller.noMoreCatNews.value = false;
                  controller.selectedCategory.value =
                      controller.categoriesList[index];
                  controller.fetchCategoryCountryNews(
                      category: controller.selectedCategory.value, load: false);
                }
              },
              child: Obx(
                () => Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 8.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3),
                  decoration: BoxDecoration(
                    color: controller.selectedCategory.value ==
                            controller.categoriesList[index]
                        ? Colors.green[400]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  child: Center(
                    child: Text(
                      controller.categoriesList[index].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: controller.selectedCategory.value ==
                                controller.categoriesList[index]
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerticalNewsList() {
    return Obx(() {
      if (controller.categoryShimmer.value) {
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return ShimmerHeadlines(isHeadline: false);
        }, childCount: 8));
      } else if (controller.errorCategory.value == true &&
          controller.categoriesData.isEmpty) {
        return SliverToBoxAdapter(
          child: alert.errorContainer(
            height: 0.325,
            head: "Oups! Something went wrong",
            msg:
                "We encountered an error while fetching your data from server. Please try again by refreshing your screen.",
          ),
        );
      } else if (controller.categoriesData.isEmpty) {
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
          if (index < controller.categoriesData.length) {
            DateTime dateTime = DateTime.parse(
                controller.categoriesData[index].publishedAt.toString());
            if (controller.categoriesData[index].author == null &&
                controller.categoriesData[index].title == "[Removed]") {
              return const SizedBox();
            } else {
              return NewsListItem(
                  article: controller.categoriesData[index],
                  date: format.format(dateTime),
                  index: index,
                  newsType: "CategoryHeadlines");
            }
          } else if (controller.errorCategory.value &&
              controller.categoriesData.isNotEmpty) {
            return Center(child: alert.loadingError());
          } else if (controller.noMoreCatNews.value) {
            return Center(
              child: SizedBox(
                height: 50,
                width: 100,
                child: alert.showNoMoreArticles(),
              ),
            );
          } else {
            return  Center(
              child: SizedBox(
                width: 100,
                child: alert.dataLoading(),
              ),
            );
          }
        }, childCount: controller.categoriesData.length + 1));
      }
    });
  }
}

