import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/categories_controller.dart';
import 'package:global_news/view/categories/widgets/category_headlines_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../controllers/chat_controller.dart';
import '../../utils/app_widgets/chat_widgets.dart';
import '../../utils/app_widgets/message_widgets.dart';
import '../../utils/app_widgets/shimmer_headlines.dart';


class CategoriesScreen extends StatefulWidget {
  static const screenRouteName = '/categories_screen';
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  final format = DateFormat('MMM dd, yyyy');
  final chatCtrl = Get.find<ChatController>();
  final controller = Get.find<CategoriesController>();
  final _prompt = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
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
    _animationController.dispose();
    _prompt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      body: SafeArea(
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
                      ),
                    ),
                    title: Obx(()=> Text(
                          "${controller.selectedCategory.value} Category News", style: GoogleFonts.almendra(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple),),
                    ),
                    centerTitle: true,
                    titleTextStyle: TextStyle(
                        color: Colors.deepPurple[400],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400),
                  ),
                ];
              },
              body: Stack(
                children:[
                LazyLoadScrollView(
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
                    child: Column(
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
                                child: Obx(()=>
                                 Container(
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
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Obx((){
                          if (controller.categoryShimmer.value){
                            return Expanded(
                                child: ShimmerHeadlines("categoryShimmer"));
                          } else if (controller.errorCategory.value == true &&
                              controller.categoriesData.value == null){
                            return Expanded(
                              child: MessageWidgets.errorContainer(
                                  height: 0.35,
                                  head: "Oups! Something went wrong",
                                  msg:
                                  "We encountered an error while fetching your data from server. please try again by refreshing your screen."),
                            );
                          } else if (controller.categoriesData.value != null &&
                              controller.categoriesData.value!.totalResults == 0){
                            return Expanded(
                              child: MessageWidgets.errorContainer(
                                  height: 0.35,
                                  head: "Oups! No Country News",
                                  msg:
                                  "We apologies for this inconvenience, we will make sure that we would add news articles related to this country."),
                            );
                          } else{
                            return Expanded(child:
                            ListView.builder(
                              padding: const EdgeInsets.only(top: 5.0),
                              itemCount: controller.categoriesData.value!
                                  .articles.length + 1,
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
                                } else if (controller.errorCategory.value == true &&
                                    controller.categoriesData.value != null) {
                                  return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: MessageWidgets.loadingError(),
                                      ));
                                } else if (controller.noMoreCatNews.value ==
                                        true) {
                                  return Center(
                                      child: SizedBox(
                                          width: 120,
                                          child: MessageWidgets.showNoMoreArticles()));
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
                      ],
                    ),
                  ),
                ),
                  ChatWidgets.chatButton(
                      pressed: (){
                        chatCtrl.toggleChat();
                        chatCtrl.isChatOpen.value
                            ? _animationController.forward()
                            : _animationController.reverse();
                      }
                  ),
                  chatScreen()
              ]),
            ),
          ),
    );
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
