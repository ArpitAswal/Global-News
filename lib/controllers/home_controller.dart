import 'package:get/get.dart';
import 'package:global_news/exceptions/app_exception.dart';
import 'package:global_news/repository/news_repository.dart';

import '../models/articles_model.dart';
import '../models/news_model.dart';
import '../utils/app_widgets/alert_notify_widgets.dart';
import '../utils/cache_data/cache_news.dart';
import 'location_controller.dart';

class HomeController extends GetxController {
  // Observables for UI state management
  final headlinesData = <Articles>[].obs; // List of headline articles
  final cntNewsData = <Articles>[].obs; // List of country news articles
  final headlineShimmer = true.obs; // Show shimmer while loading headlines
  final countryShimmer = true.obs; // Show shimmer while loading country news
  final errorHeadline = false.obs; // Indicate error fetching headlines
  final errorCountry = false.obs; // Indicate error fetching country news
  final noMoreHeadNews = false.obs; // Indicate no more headlines available
  final noMoreCntNews = false.obs; // Indicate no more country news available

  var _networkErrorShown = false; // Flag to prevent multiple network error snackbars
  var locationAllow = false; // Flag for location permission
  var headlinesSize = 0; // Total available headline articles
  var cntNewsSize = 0; // Total available country news articles

  late RxString selectedCountry = ''.obs; // Currently selected country name
  late RxString cntCode = ''.obs; // Currently selected country code
  late NewsRepository _repository;

  final List<String> countryNames = const [
    "Argentina", "Austria", "Australia", "Belgium", "Bulgaria", "Brazil", "Canada",
    "China", "Colombia", "Cuba", "Czech Republic", "Egypt", "France", "Germany",
    "Greece", "Hong Kong", "Hungary", "India", "Indonesia", "Ireland", "Israel",
    "Italy", "Japan", "Latvia", "Lithuania", "Malaysia", "Mexico", "Morocco",
    "Netherlands", "New Zealand", "Nigeria", "Norway", "Philippines", "Poland",
    "Portugal", "Romania", "Russia", "Saudi Arabia", "Serbia", "Singapore",
    "Slovakia", "Slovenia", "South Africa", "South Korea", "Sweden", "Switzerland",
    "Taiwan", "Thailand", "Turkey", "Ukraine", "United Arab Emirates", "United Kingdom",
    "United States", "Venezuela"
  ];
  final List<String> countryCodes = const [
    "ar", "at", "au", "be", "bg", "br", "ca", "cn", "co", "cu", "cz", "eg", "fr",
    "de", "gr", "hk", "hu", "in", "id", "ie", "il", "it", "jp", "lv", "lt", "my",
    "mx", "ma", "nl", "nz", "ng", "no", "ph", "pl", "pt", "ro", "ru", "sa", "rs",
    "sg", "sk", "si", "za", "kr", "se", "ch", "tw", "th", "tr", "ua", "ae", "gb",
    "us", "ve"
  ];
  final LocationController locationController = Get.find<LocationController>();

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<NewsRepository>(); // Initialize NewsRepository
    initialPermission(refresh: true); // Get initial location permissions
    ever(locationController.locationUpdate, (bool update) {
      callHomeAPI(); // Call API when location updates
    });
  }

// Fetch headlines and country news simultaneously
  void callHomeAPI() {
    headlinesData.value = []; // Clear existing headlines
    cntNewsData.value = []; // Clear existing country news
    Future.wait([
      fetchNews(load: false, code: cntCode.value, initialCall: true),
      getCountryNews(load: false, country: selectedCountry.value, initialCall: true)
    ]);
  }

// Load more country news if available
  void endCountryNews() {
    if (cntNewsData.length >= cntNewsSize) {
      noMoreCntNews(true); // No more news available
    } else {
      noMoreCntNews(false);
      getCountryNews(load: true, country: selectedCountry.value, initialCall: false);
    }
  }

// Load more headlines if available
  void endHeadlines() {
    if (headlinesData.length >= headlinesSize) {
      noMoreHeadNews(true); // No more headlines available
    } else {
      noMoreHeadNews(false);
      fetchNews(load: true, code: cntCode.value, initialCall: false);
    }
  }

  // Fetch headlines news from API or cache
  Future<void> fetchNews({required bool load, required String code, required bool initialCall}) async {
    try {
      headlineShimmer(!load); // Show shimmer while loading
      errorHeadline(false); // Reset error flag
      final map = await _repository.fetchCountryTopHeadlines(countryCode: code, initialCall: initialCall);
      final response = NewsModel.fromJson(map);

      if (response.articles.isNotEmpty) {
        headlinesSize = response.articles.length; // Update total headlines size
        final startIndex = headlinesData.isEmpty ? 0 : headlinesData.length;
        final endIndex = (headlinesData.length + 20 < response.articles.length)
            ? headlinesData.length + 20
            : response.articles.length;
        headlinesData.addAll(response.articles.sublist(startIndex, endIndex)); // Add new articles
      } else {
        headlinesData.value = []; // Clear headlines if API returns empty
      }
    } on AppException catch (e) {
      if (e.message == "No Internet connection") {
        final cachedData = CacheNewsData().getCacheCountryNews('headlines_news_$code');
        if (cachedData != null) {
          headlinesData.value = NewsModel.fromJson(cachedData).articles; // Load from cache
          noMoreHeadNews(true); // Indicate no more news (from API)
        } else {
          errorHeadline(true); // Indicate error if no cache
        }
      }
      _handleNetworkError(msg: e.message.toString()); // Handle network error
    } catch (e) {
      errorHeadline(true); // Indicate other errors
      AlertNotifyWidgets().showSnackBar(e.toString());
    } finally {
      headlineShimmer(false); // Hide shimmer
    }
  }

  // Fetch country news from API or cache
  Future<void> getCountryNews({required bool load, required String country, required bool initialCall}) async {
    try {
      countryShimmer(!load); // Show shimmer while loading
      errorCountry(false); // Reset error flag
      final map = await _repository.fetchCountryNews(country: country, initialCall: initialCall);
      final response = NewsModel.fromJson(map);

      if (response.articles.isNotEmpty) {
        cntNewsSize = response.articles.length; // Update total country news size
        final startIndex = cntNewsData.isEmpty ? 0 : cntNewsData.length;
        final endIndex = (cntNewsData.length + 20 < response.articles.length)
            ? cntNewsData.length + 20
            : response.articles.length;
        cntNewsData.addAll(response.articles.sublist(startIndex, endIndex)); // Add new articles
      } else {
        cntNewsData.value = []; // Clear country news if API returns empty
      }
    } on AppException catch (e) {
      if (e.message == "No Internet connection") {
        final cachedData = CacheNewsData().getCacheCountryNews('country_news_$country');
        if (cachedData != null) {
          cntNewsData.value = NewsModel.fromJson(cachedData).articles; // Load from cache
          noMoreCntNews(true); // Indicate no more news (from API)
        } else {
          errorCountry(true); // Indicate error if no cache
        }
      }
      _handleNetworkError(msg: e.message.toString()); // Handle network error
    } catch (e) {
      errorCountry(true); // Indicate other errors
      AlertNotifyWidgets().showSnackBar(e.toString());
    } finally {
      countryShimmer(false); // Hide shimmer
    }
  }

  void setSelectedCountry(String country) async {
    selectedCountry.value = country;
    cntCode.value = countryCodes[countryNames.indexOf(country)];
    _repository.prefs.saveStringData("CountryName", selectedCountry.value);
    _repository.prefs.saveStringData("CountryCode", cntCode.value);
    callHomeAPI();
  }

  // Get initial location permissions and set the country
  Future<void> initialPermission({bool refresh = false}) async {
    selectedCountry.value = _repository.prefs.fetchStringData('CountryName') ?? "";
    cntCode.value = _repository.prefs.fetchStringData('CountryCode') ?? "";
    await locationController.getCurrentLocation().then((value) {
      if (value.second is String) {
        // Location permission granted and country determined
        if (refresh || locationAllow) {
          selectedCountry.value = value.first;
          cntCode.value = value.second;
          locationAllow = false;
          locationController.saveLocation(value);
        }
      } else if (!value.second) {
        // Location permission denied
        locationAllow = true;
        locationController.setPermissionMsg(status: value.first);
      } else if (value.second) {
        // Location service enabled but no country determined
        if (selectedCountry.value.isNotEmpty && cntCode.value.isNotEmpty) {
          callHomeAPI();
        }
        AlertNotifyWidgets().showSnackBar(value.first);
      }
    });
  }

  // Handle network error and display a single snackbar
  Future<void> _handleNetworkError({required String msg}) async {
    if (!_networkErrorShown) {
      _networkErrorShown = true;
      AlertNotifyWidgets().showSnackBar(msg);
      await Future.delayed(const Duration(seconds: 5)); // Delay before resetting
      _networkErrorShown = false; // Reset flag
    }
  }
}
