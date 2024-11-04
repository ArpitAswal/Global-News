import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:global_news/repository/news_repository.dart';

import '../exceptions/app_exception.dart';
import '../models/news_model.dart';
import '../utils/app_widgets/message_widgets.dart';

class SearchingController extends GetxController{

  RxBool isSearching = false.obs;
  RxBool searchError = false.obs;
  RxBool noMoreSearchNews = false.obs;
  RxString searchText = "".obs;
  Rxn<NewsModel> searchData = Rxn<NewsModel>();

  final _repository = NewsRepository();

  int newsSize = 20;

  void clearQuery(){
    searchText.value = "";
    searchData.value = null;
  }

  Future<NewsModel?> searchNews(String query, bool load) async{
    try {
      isSearching(load);
      searchError(false);
      if(query.isEmpty){
        MessageWidgets.toast("Enter the query",gravity: ToastGravity.BOTTOM);
        return null;
      }
      searchText.value = query;
      var map = await _repository.searchQueryNews(q: query, size: newsSize);
      var response = NewsModel.fromJson(map);
      if (response.status == "ok") {
        searchData.value = response;
        return searchData.value;
      } else {
        searchError(true);
        MessageWidgets.toast(response.status.toString(), gravity: ToastGravity.BOTTOM);
        return null;
      }
    } on AppException catch (e) {
      searchError(true);
      MessageWidgets.showSnackBar(e.message.toString());
      return null;
    } catch (e) {
      searchError(true);
      MessageWidgets.showSnackBar(e.toString());
      return null;
    } finally {
      isSearching(false);
    }
  }

  void endSearchNews() {
    if(newsSize + 20 > 100){
      noMoreSearchNews(true);
      newsSize = 100;
    } else{
      noMoreSearchNews(false);
      newsSize += 20;
      searchNews(searchText.value, false);
    }
  }
}