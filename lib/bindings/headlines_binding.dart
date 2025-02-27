
import 'package:get/get.dart';
import 'package:global_news/controllers/chat_controller.dart';

import '../controllers/home_controller.dart';
import '../controllers/location_controller.dart';

class HeadlinesBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController(), fenix: true); // ensures LocationController is created only when needed.
    Get.lazyPut<ChatController>(()=> ChatController(), fenix: true); // ensures ChatController is created only when needed.
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);  // ensures HomeController is created only when needed.
  }
}