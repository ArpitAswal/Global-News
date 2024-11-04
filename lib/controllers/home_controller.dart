import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:global_news/exceptions/app_exception.dart';
import 'package:global_news/repository/news_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/news_model.dart';
import '../utils/app_widgets/message_widgets.dart';

class HomeController extends GetxController {
  final headlinesData = Rxn<NewsModel>();
  final cntNewsData = Rxn<NewsModel>();
  final _repository = NewsRepository();

  var headlineShimmer = true
      .obs; // to show the shimmer effect while the headlines news data is fetched
  var countryShimmer = true
      .obs; // to show the shimmer effect while the country news data is fetched
  var errorHeadline = false.obs; // to indicate error in headlines news data
  var errorCountry = false.obs; // to indicate error in country news data
  var noMoreHeadNews =
      false.obs; // to indicate that headlines news data are more
  var noMoreCntNews = false.obs; // to indicate that country news data are more

  var headlinesSize =
      6; // this is default value of headlines news data that can display at current time
  var cntNewsSize =
      20; // this is default value of country news data that can display at current time

  late RxString selectedCountry = ''.obs;
  late RxString cntCode = ''.obs;

  final List<String> countryNames = [
    "Argentina",
    "Austria",
    "Australia",
    "Belgium",
    "Bulgaria",
    "Brazil",
    "Canada",
    "China",
    "Colombia",
    "Cuba",
    "Czech Republic",
    "Egypt",
    "France",
    "Germany",
    "Greece",
    "Hong Kong",
    "Hungary",
    "India",
    "Indonesia",
    "Ireland",
    "Israel",
    "Italy",
    "Japan",
    "Latvia",
    "Lithuania",
    "Malaysia",
    "Mexico",
    "Morocco",
    "Netherlands",
    "New Zealand",
    "Nigeria",
    "Norway",
    "Philippines",
    "Poland",
    "Portugal",
    "Romania",
    "Russia",
    "Saudi Arabia",
    "Serbia",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "South Africa",
    "South Korea",
    "Sweden",
    "Switzerland",
    "Taiwan",
    "Thailand",
    "Turkey",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "Venezuela"
  ];

  final List<String> countryCodes = [
    "ar",
    "at",
    "au",
    "be",
    "bg",
    "br",
    "ca",
    "cn",
    "co",
    "cu",
    "cz",
    "eg",
    "fr",
    "de",
    "gr",
    "hk",
    "hu",
    "in",
    "id",
    "ie",
    "il",
    "it",
    "jp",
    "lv",
    "lt",
    "my",
    "mx",
    "ma",
    "nl",
    "nz",
    "ng",
    "no",
    "ph",
    "pl",
    "pt",
    "ro",
    "ru",
    "sa",
    "rs",
    "sg",
    "sk",
    "si",
    "za",
    "kr",
    "se",
    "ch",
    "tw",
    "th",
    "tr",
    "ua",
    "ae",
    "gb",
    "us",
    "ve",
  ];

  void callHomeAPI(){
    fetchNews( load: false, code: cntCode.value);
    getCountryNews(load: false, country: selectedCountry.value);
  }

  void endCountryNews() {
    if (cntNewsSize + 20 > 100) {
      cntNewsSize = 100;
      noMoreCntNews(true);
    } else {
      noMoreCntNews(false);
      cntNewsSize += 20;
      getCountryNews(
          load: true,
          country: selectedCountry.value);
    }
  }

  void endHeadlines() {
    if (headlinesSize + 20 > 100) {
      headlinesSize = 100;
      noMoreHeadNews(true);
    } else {
      noMoreHeadNews(false);
      headlinesSize += 20;
      fetchNews(
          load: true,
          code: cntCode.value);
    }
  }

  Future<void> fetchNews(
      {required bool load, required String code}) async {
    try {
      headlineShimmer(!load);
      errorHeadline(false);
      var map = await _repository.fetchCountryTopHeadlines(
          countryCode: code, dataSize: headlinesSize);
      var response = NewsModel.fromJson(map);
      if (response.status == "ok") {
        headlinesData.value = response;
      } else {
        errorHeadline(true);
        MessageWidgets.toast(response.status.toString(), gravity: ToastGravity.CENTER);
      }
    } on AppException catch (e) {
      errorHeadline(true);
      MessageWidgets.showSnackBar(e.message.toString());
    } catch (e) {
      errorHeadline(true);
      MessageWidgets.showSnackBar(e.toString());
    } finally {
      headlineShimmer(false);
    }
    // here what we do is whenever we fetch data from API, UI will display shimmer effect until data is fetched. in case we get some error it will set the error headlines to true that will indicate that we faced some error while fetching data from server. also it make sure that headlines more set to false no matter what either data is fetched or not to indicate that currently we don't have any more news.
  }

  Future<void> getCountryNews(
      {required bool load, required String country}) async {
    try {
      countryShimmer(!load);
      errorCountry(false);
      var map = await _repository.fetchCountryNews(
          country: country, dataSize: cntNewsSize);
      var response = NewsModel.fromJson(map);
      if (response.status == "ok") {
        cntNewsData.value = response;
      } else {
        errorCountry(true);
        MessageWidgets.toast(response.status.toString(), gravity: ToastGravity.CENTER);
      }
    } on AppException catch (e) {
      errorCountry(true);
      MessageWidgets.showSnackBar(e.message.toString());
    } catch (e) {
      errorCountry(true);
      MessageWidgets.showSnackBar(e.toString());
    } finally {
      countryShimmer(false);
    }
    // here what we do is whenever we fetch data from API, UI will display shimmer effect until data is fetched. in case we get some error it will set the errorCountry to true that will indicate that we faced some error while fetching data from server. also it make sure that country news more set to false no matter what either data is fetched or not to indicate that currently we don't have any more news.
  }

  Future<void> getCountryCode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      selectedCountry.value = prefs.getString("CountryName") ?? "";
      cntCode.value = prefs.getString("CountryCode") ?? "";
      if (selectedCountry.value.isNotEmpty && cntCode.value.isNotEmpty) {
        callHomeAPI();
      }
    } catch (e) {
      MessageWidgets.showSnackBar(e.toString());
    }
  }

  void setSelectedCountry(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    headlinesSize = 20;
    cntNewsSize = 20;
    selectedCountry.value = country;
    cntCode.value = countryCodes[countryNames.indexOf(country)];
    prefs.setString("CountryName", selectedCountry.value);
    prefs.setString("CountryCode", cntCode.value);
    callHomeAPI();
  }
}
