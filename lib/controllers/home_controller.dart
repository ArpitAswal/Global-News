import 'package:get/get.dart';
import 'package:global_news/exceptions/app_exception.dart';
import 'package:global_news/repository/news_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/country_news_model.dart';
import '../models/headlines_model.dart';
import '../utils/app_widgets/message_widgets.dart';

class HomeController extends GetxController {
  final headlinesData = Rxn<HeadlinesModel>();
  final cntNewsData = Rxn<CountryNewsModel>();
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
  var isSearching =
      false.obs; // to indicate that user searching something or not
  var searchText = ''.obs;

  var headlinesSize =
      6; // this is default value of headlines news data that can display at current time
  var cntNewsSize =
      20; // this is default value of country news data that can display at current time

  late RxString selectedCountry = ''.obs;
  late RxString cntCode = ''.obs;
  //late final map;

  final List<String> countryNames = [
    "United Arab Emirates",
    "Argentina",
    "Austria",
    "Australia",
    "Belgium",
    "Bulgaria",
    "Brazil",
    "Canada",
    "Switzerland",
    "China",
    "Colombia",
    "Cuba",
    "Czech Republic",
    "Germany",
    "Egypt",
    "France",
    "United Kingdom",
    "Greece",
    "Hong Kong",
    "Hungary",
    "Indonesia",
    "Ireland",
    "Israel",
    "India",
    "Italy",
    "Japan",
    "South Korea",
    "Lithuania",
    "Latvia",
    "Morocco",
    "Mexico",
    "Malaysia",
    "Nigeria",
    "Netherlands",
    "Norway",
    "New Zealand",
    "Philippines",
    "Poland",
    "Portugal",
    "Romania",
    "Serbia",
    "Russia",
    "Saudi Arabia",
    "Sweden",
    "Singapore",
    "Slovenia",
    "Slovakia",
    "Thailand",
    "Turkey",
    "Taiwan",
    "Ukraine",
    "United States",
    "Venezuela",
    "South Africa"
  ];

  final List<String> countryCodes = [
    "ae",
    "ar",
    "at",
    "au",
    "be",
    "bg",
    "br",
    "ca",
    "ch",
    "cn",
    "co",
    "cu",
    "cz",
    "de",
    "eg",
    "fr",
    "gb",
    "gr",
    "hk",
    "hu",
    "id",
    "ie",
    "il",
    "in",
    "it",
    "jp",
    "kr",
    "lt",
    "lv",
    "ma",
    "mx",
    "my",
    "n",
    "nl",
    "no",
    "nz",
    "ph",
    "pl",
    "pt",
    "ro",
    "rs",
    "ru",
    "sa",
    "se",
    "sg",
    "si",
    "sk",
    "th",
    "tr",
    "tw",
    "ua",
    "us",
    "ve",
    "za"
  ];

  void endCountryNews() {
    if (cntNewsSize + 20 > 100) {
      cntNewsSize = 100;
      noMoreCntNews(true);
    } else {
      noMoreCntNews(false);
      cntNewsSize += 20;
      getCountryNews(
          (isSearching.value && searchText.value.isNotEmpty)
              ? searchText.value
              : null,
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
          (isSearching.value && searchText.value.isNotEmpty)
              ? searchText.value
              : null,
          load: true,
          code: cntCode.value);
    }
  }

  Future<void> fetchNews(String? query,
      {required bool load, required String code}) async {
    try {
      headlineShimmer(!load);
      errorHeadline(false);
      var map = await _repository.fetchCountryTopHeadlines(query,
          countryCode: 'us', dataSize: headlinesSize);
      var response = HeadlinesModel.fromJson(map);
      if (response.status == "ok") {
        headlinesData.value = response;
      } else {
        errorHeadline(true);
        MessageWidgets.toast(response.status.toString());
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

  Future<void> getCountryNews(String? query,
      {required bool load, required String country}) async {
    try {
      countryShimmer(!load);
      errorCountry(false);
      var map = await _repository.fetchCountryNews(query,
          country: country, dataSize: cntNewsSize);
      var response = CountryNewsModel.fromJson(map);
      if (response.status == "ok") {
        cntNewsData.value = response;
      } else {
        errorCountry(true);
        MessageWidgets.toast(response.status.toString());
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
        Future.wait([
          fetchNews(null, load: false, code: cntCode.value),
          getCountryNews(null, load: false, country: selectedCountry.value)
        ]);
      }
    } catch (e) {
      MessageWidgets.showSnackBar(e.toString());
    }
  }

  void performSearch() {
    fetchNews((searchText.value.isEmpty) ? null : searchText.value,
        load: false, code: cntCode.value);
    getCountryNews((searchText.value.isEmpty) ? null : searchText.value,
        load: false, country: selectedCountry.value);
  }

  void setSearchText(String text) {
    searchText.value = text;
  }

  void setSelectedCountry(String country, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    headlinesSize = 20;
    cntNewsSize = 20;
    selectedCountry.value = country;
    cntCode.value = countryCodes[index];
    prefs.setString("CountryName", selectedCountry.value);
    prefs.setString("CountryCode", cntCode.value);
    fetchNews(
        (isSearching.value && searchText.value.isNotEmpty)
            ? searchText.value
            : null,
        load: false,
        code: cntCode.value);
    getCountryNews(
        (isSearching.value && searchText.value.isNotEmpty)
            ? searchText.value
            : null,
        load: false,
        country: selectedCountry.value);
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }
}
