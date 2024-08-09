import 'package:get/get.dart';
import 'package:global_news/exceptions/app_exception.dart';
import 'package:global_news/repository/news_repository.dart';
import 'package:global_news/app_widgets/message_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../location/location_country.dart';
import '../models/country_news_model.dart';
import '../models/headlines_model.dart';

class HomeController extends GetxController {
  final headlinesData = Rxn<HeadlinesModel>();
  final cntNewsData = Rxn<CountryNewsModel>();

  var headlineShimmer = true.obs;
  var countryShimmer = true.obs;
  var errorHeadline = false.obs;
  var errorCountry = false.obs;
  var headlinesMore = false.obs;
  var cntNewsMore = false.obs;
  var noMoreHeadlines = false.obs;
  var noMoreCntNews = false.obs;
  var isSearching = false.obs;
  var searchText = ''.obs;

  var permissionStatus = "Allow".obs;

  var headlinesSize = 10;
  var cntNewsSize = 10;

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

  @override
  void onInit() {
    super.onInit();
    getCountryCode();
  }

  void endHeadlines() {
    headlinesSize = headlinesData.value!.articles.length + 10;
    headlinesMore(true);
    if (headlinesSize >
        ((headlinesData.value!.totalResults! > 100)
            ? 100
            : headlinesData.value!.totalResults!)) {
      headlinesSize =
          (headlinesSize > 100) ? 100 : headlinesData.value!.totalResults!;
      noMoreHeadlines(true);
    } else {
      noMoreHeadlines(false);
      fetchNews(
        (isSearching.value && searchText.value.isNotEmpty)
            ? searchText.value
            : null,
        load: headlinesMore.value,
        code: cntCode.value,
      );
    }
  }

  void endCountryNews() {
    cntNewsSize = cntNewsData.value!.articles.length + 10;
    cntNewsMore(true);
    if (cntNewsSize >
        ((cntNewsData.value!.totalResults! > 100)
            ? 100
            : cntNewsData.value!.totalResults!)) {
      cntNewsSize = (cntNewsData.value!.totalResults! > 100)
          ? 100
          : cntNewsData.value!.totalResults!;
      noMoreCntNews(true);
    } else {
      noMoreCntNews(false);
      getCountryNews(
          (isSearching.value && searchText.value.isNotEmpty)
              ? searchText.value
              : null,
          load: cntNewsMore.value,
          country: selectedCountry.value);
    }
  }

  void fetchNews(String? query,
      {required bool load, required String code}) async {
    try {
      headlineShimmer(!load);
      errorHeadline(false);
      var map = await NewsRepository().fetchCountryTopHeadlines(query,
          countryCode: code, dataSize: headlinesSize);
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
      headlinesMore(false);
    }
  }

  Future<void> getCountryCode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Pair loc = await LocationCountry.getCurrentLocation();
      if (loc.second == false) {
        permissionStatus(loc.first);
      } else {
        selectedCountry.value = loc.first;
        cntCode.value = loc.second;
        permissionStatus("Allow");
        prefs.setString("CountryCode", cntCode.value);
        prefs.setString("CountryName", selectedCountry.value);
        fetchNews(null, load: false, code: cntCode.value);
        getCountryNews(null, load: false, country: selectedCountry.value);
      }
    } catch (e) {
      MessageWidgets.showSnackBar(e.toString());
    }
  }

  void getCountryNews(String? query,
      {required bool load, required String country}) async {
    try {
      countryShimmer(!load);
      errorCountry(false);
      var map = await NewsRepository()
          .fetchCountryNews(query, country: country, dataSize: cntNewsSize);
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
      cntNewsMore(false);
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
    headlinesSize = 10;
    cntNewsSize = 10;
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
