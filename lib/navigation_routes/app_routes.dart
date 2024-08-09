import 'package:get/get.dart';
import 'package:global_news/view/news_detail_screen.dart';

import '../bindings/categories_binding.dart';
import '../bindings/home_binding.dart';
import '../view/categories/categories_screen.dart';
import '../view/home/home_screen.dart';
import '../view/splash_screen.dart';

class AppRoutes {
  static const initialRoute = SplashScreen.screenRouteName;
  static final routes = [
    GetPage(
        name: SplashScreen.screenRouteName, page: () => const SplashScreen()),
    GetPage(
        name: HomeScreen.screenRouteName,
        page: () => HomeScreen(),
        binding: HomeBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: CategoriesScreen.screenRouteName,
        page: () => CategoriesScreen(),
        binding: CategoriesBinding(),
        transition: Transition.leftToRight),
    GetPage(
        name: NewsDetailScreen.screenRouteName,
        page: () => const NewsDetailScreen(),
        transition: Transition.zoom)
  ];
}
