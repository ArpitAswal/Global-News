import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:global_news/models/categories_new_model.dart';
import 'package:global_news/repository/news_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/app_exception.dart';
import '../utils/app_widgets/message_widgets.dart';

class CategoriesController extends GetxController {
  var categoryShimmer = true.obs;
  var errorCategory = false.obs;
  var noMoreCatNews = false.obs;
  var scrolled = false.obs;
  var categoriesData = Rxn<CategoriesNewsModel>();
  var selectedCategory = 'General'.obs;
  var previousCategory = 'General'.obs;

  var categoryNewsSize = 20;

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCategoryCountryNews(category: selectedCategory.value, load: false);
  }

  void endCategoryNews() {
    if(categoryNewsSize + 20 > 100){
      noMoreCatNews(true);
      categoryNewsSize = 100;
    }
    else {
      categoryNewsSize += 20;
      noMoreCatNews(false);
      fetchCategoryCountryNews(category: selectedCategory.value, load: true);
    }
  }

  Future<void> fetchCategoryCountryNews(
      {required String category, required bool load}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cntName = prefs.getString("CountryName") ?? "";
      categoryShimmer(!load);
      errorCategory(false);
      if (selectedCategory.value != previousCategory.value) {
        previousCategory.value = selectedCategory.value;
        categoryNewsSize = 20;
      }
      var map = await NewsRepository().fetchCategoryCountryBased(
          category: category.toLowerCase(),
          country: cntName,
          dataSize: categoryNewsSize);
      var response = CategoriesNewsModel.fromJson(map);

      if (response.status == 'ok') {
        categoriesData.value = response;
      } else {
        errorCategory(true);
        MessageWidgets.toast(response.status.toString(), gravity: ToastGravity.CENTER);
      }
    } on AppException catch (e) {
      errorCategory(true);
      MessageWidgets.showSnackBar(e.message.toString());
    } catch (e) {
      errorCategory(true);
      MessageWidgets.showSnackBar(e.toString());
    } finally {
      categoryShimmer(false);
    }
  }
}
