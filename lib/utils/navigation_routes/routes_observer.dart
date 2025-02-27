import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news/controllers/chat_controller.dart';

class RoutesObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name == '/home_screen' &&
        route.settings.name == '/categories_screen') {
      // User navigated back from Screen B to Screen A
      Get.find<ChatController>().hideChatScreen();
    }
  }
}

/*
Working Route Observer:

. The RouteObserver listens for route changes (pushes and pops).
. When a route is popped (using Get.back() or the device's back button), the didPop method is called.
. The didPop method checks the previousRoute and route settings to determine if the user navigated back from Screen B to Screen A.
. This is done by comparing the route names.
. If the navigation is from Screen B to Screen A, the method() method in your controller is called.
 */