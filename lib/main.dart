import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news/utils/navigation_routes/app_routes.dart';
import 'package:global_news/utils/navigation_routes/routes_observer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorKey: navigatorKey,
        title: 'Global News',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        initialRoute: '/splash_screen',
        navigatorObservers: [RoutesObserver()],
        getPages: AppRoutes.routes);
  }
}
