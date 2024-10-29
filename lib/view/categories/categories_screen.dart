import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/categories_controller.dart';
import 'package:global_news/view/categories/widgets/category_headlines_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../utils/app_widgets/shimmer_headlines.dart';


class CategoriesScreen extends GetView<CategoriesController> {
  static const screenRouteName = '/categories_screen';
  final format = DateFormat('MMM dd, yyyy');

  CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      body: Obx(() => SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                controller.scrolled(innerBoxIsScrolled);
                return [
                  SliverAppBar(
                    leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.deepPurple[200],
                      ),
                    ),
                    title: Text(
                        "${controller.selectedCategory.value} Category News"),
                    centerTitle: true,
                    titleTextStyle: TextStyle(
                        color: Colors.deepPurple[400],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400),
                  ),
                ];
              },
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 6.0,
                  ),
                  SizedBox(
                    height: height * .065,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categoriesList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            controller.selectedCategory.value =
                                controller.categoriesList[index];
                            controller.fetchCategoryCountryNews(
                                category: controller.selectedCategory.value,
                                load: false);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 8.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 3),
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
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  (controller.categoryShimmer.value)
                      ? const Expanded(
                          child: ShimmerHeadlines("categoryShimmer"))
                      : (controller.errorCategory.value == true &&
                              controller.categoriesData.value == null)
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * .7,
                              child: const Center(
                                  child:
                                      Text('Failed to fetch Headlines News.')),
                            )
                          : Expanded(
                              child: LazyLoadScrollView(
                                scrollDirection: Axis.vertical,
                                onEndOfPage: () {
                                  controller.endCategoryNews();
                                },
                                child: RefreshIndicator(
                                  color: Colors.blue,
                                  onRefresh: () async {
                                    await controller.fetchCategoryCountryNews(
                                        category:
                                            controller.selectedCategory.value,
                                        load: false);
                                  },
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    itemCount: controller.categoriesData.value!
                                            .articles.length +
                                        (controller.moreCatNews.value ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index <
                                          controller.categoriesData.value!
                                              .articles.length) {
                                        DateTime dateTime = DateTime.parse(
                                            controller.categoriesData.value!
                                                .articles[index].publishedAt
                                                .toString());
                                        if (controller.categoriesData.value!
                                                    .articles[index].author ==
                                                null &&
                                            controller.categoriesData.value!
                                                    .articles[index].title ==
                                                "[Removed]") {
                                          return const SizedBox();
                                        } else {
                                          return CategoryHeadlinesWidget(
                                            controller: controller,
                                            date: format.format(dateTime),
                                            index: index,
                                          );
                                        }
                                      } else if (controller.errorCategory.value &&
                                          controller.categoriesData.value !=
                                              null) {
                                        return const Center(
                                          child: Text(
                                              'Error loading more articles.'),
                                        );
                                      } else if (controller
                                                  .errorCategory.value ==
                                              false &&
                                          controller.categoriesData.value !=
                                              null &&
                                          controller.noMoreCatNews.value ==
                                              true) {
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
                              ),
                            ),
                ],
              ),
            ),
          )),
    );
  }
}

const spinKit = SpinKitFadingCircle(
  color: Colors.cyan,
  size: 50,
);
