import 'package:get/get.dart';
import 'package:global_news/repository/news_repository.dart';

import '../exceptions/app_exception.dart';
import '../models/articles_model.dart';
import '../models/news_model.dart';
import '../utils/app_widgets/alert_notify_widgets.dart';
import '../utils/cache_data/cache_news.dart';

class CategoriesController extends GetxController {
  var categoryShimmer = true.obs;
  var errorCategory = false.obs;
  var noMoreCatNews = false.obs;
  var scrolled = false.obs;
  var categoriesData = <Articles>[].obs;
  var selectedCategory = 'General'.obs;
  var previousCategory = 'General'.obs;

  var categoryNewsSize = 0;

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  late NewsRepository _repository;
  late String cntName;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<NewsRepository>(); // Get initialized instance
    cntName = _repository.prefs.fetchStringData("CountryName")!;
    fetchCategoryCountryNews(category: selectedCategory.value, load: false);
  }

  void endCategoryNews() {
    if (categoriesData.length >= categoryNewsSize) {
      noMoreCatNews(true);
    } else {
      noMoreCatNews(false);
      fetchCategoryCountryNews(category: selectedCategory.value, load: true);
    }
  }

  Future<void> fetchCategoryCountryNews(
      {required String category,
      required bool load,
      bool refresh = false}) async {
    try {
      categoryShimmer(!load);
      errorCategory(false);
      if (refresh || selectedCategory.value != previousCategory.value) {
        previousCategory.value = selectedCategory.value;
        categoriesData.value = [];
      }
      var map = await _repository.fetchCategoryCountryBased(
          category: category.toLowerCase(), country: cntName, refresh: refresh);
      var response = NewsModel.fromJson(map);
      if (response.articles.isNotEmpty) {
        categoryNewsSize = response.articles.length;
        int startIndex = categoriesData.isEmpty ? 0 : categoriesData.length;
        int endIndex = categoriesData.length + 20 < response.articles.length
            ? categoriesData.length + 20
            : response.articles.length;
        categoriesData.addAll(response.articles.sublist(startIndex, endIndex));
      } else {
        categoriesData.value = [];
      }
    } on AppException catch (e) {
      if (e.message == "No Internet connection") {
        final cachedData = CacheNewsData().getCacheCountryNews(
            'country_category_news_$cntName&${category.toLowerCase()}');
        if (cachedData != null) {
          categoriesData.value = NewsModel.fromJson(cachedData).articles;
          noMoreCatNews(true);
        } else {
          errorCategory(true);
        }
      }
      AlertNotifyWidgets().showSnackBar(e.message.toString());
    } catch (e) {
      errorCategory(true);
      AlertNotifyWidgets().showSnackBar(e.toString());
    } finally {
      categoryShimmer(false);
    }
  }
}
