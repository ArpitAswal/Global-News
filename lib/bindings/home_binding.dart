
import 'package:get/get.dart';
import 'package:global_news/controllers/chat_controller.dart';

import '../controllers/home_controller.dart';
import '../controllers/location_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(LocationController());
    Get.put(HomeController(), permanent: true);
    Get.put(ChatController(), permanent: true);
  }
}