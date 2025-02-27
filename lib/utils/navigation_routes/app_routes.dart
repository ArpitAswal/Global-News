import 'package:get/get.dart';

import '../../bindings/categories_binding.dart';
import '../../bindings/headlines_binding.dart';
import '../../view/all_news_views/categories_screen.dart';
import '../../view/all_news_views/headlines_news_screen.dart';
import '../../view/splash_screen.dart';


class AppRoutes {
  static final initialRoute = SplashScreen.screenRouteName;
  static final routes = [
    GetPage(
        name: SplashScreen.screenRouteName, page: () => const SplashScreen()),
    GetPage(
        name: HeadlinesNewsScreen.screenRouteName,
        page: () => HeadlinesNewsScreen(),
        binding: HeadlinesBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: NewsCategoryScreen.screenRouteName,
        page: () => NewsCategoryScreen(),
        binding: CategoriesBinding(),
        transition: Transition.leftToRight),
  ];
}
