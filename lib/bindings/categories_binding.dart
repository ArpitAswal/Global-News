
import 'package:get/get.dart';

import '../controllers/categories_controller.dart';

class CategoriesBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> CategoriesController());
  }
}