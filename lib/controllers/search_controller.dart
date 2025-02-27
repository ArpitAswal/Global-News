import 'dart:async';

import 'package:get/get.dart';
import 'package:global_news/repository/news_repository.dart';

import '../exceptions/app_exception.dart';
import '../models/articles_model.dart';
import '../models/news_model.dart';
import '../utils/app_widgets/alert_notify_widgets.dart';

class SearchingController extends GetxController {
  RxBool isSearching = false.obs;
  RxBool searchError = false.obs;
  RxBool noMoreSearchNews = false.obs;

  final searchData = <Articles>[].obs;
  final tempData = <Articles>[].obs;

  late NewsRepository _repository;
  late AlertNotifyWidgets _alert;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<NewsRepository>(); // Get initialized instance
    _alert = AlertNotifyWidgets();
  }

  void reachBottom() {
    if (searchData.length + 20 >= tempData.length) {
      searchData.addAll(tempData.sublist(searchData.length, tempData.length));
      noMoreSearchNews(true);
    } else {
      noMoreSearchNews(false);
      searchData
          .addAll(tempData.sublist(searchData.length, searchData.length + 20));
    }
  }

  Future<void> searchNews({required String query}) async {
    try {
      if (query.isEmpty) {
        _alert.showSnackBar("Empty query can not search data...");
      } else {
        searchData.value = [];
        tempData.value = [];
        isSearching(true);
        searchError(false);
        var map = await _repository.searchQueryNews(query: query);
        var response = NewsModel.fromJson(map);
        if (response.articles.isNotEmpty) {
          tempData.value = response.articles;
          int startIndex = searchData.length;
          int endIndex = (searchData.length + 20 >= tempData.length)
              ? tempData.length
              : searchData.length + 20;
          searchData.addAll(tempData.sublist(startIndex, endIndex));
        } else {
          searchData.value = [];
        }
      }
    } on AppException catch (e) {
      if (e.message == "No Internet connection") {
        if (tempData.isNotEmpty) {
          searchData.addAll(tempData);
          noMoreSearchNews(true);
        } else {
          searchError(true);
        }
      }
      _alert.showSnackBar(e.message.toString());
    } catch (e) {
      searchError(true);
      _alert.showSnackBar(e.toString());
    } finally {
      isSearching(false);
    }
  }
}
