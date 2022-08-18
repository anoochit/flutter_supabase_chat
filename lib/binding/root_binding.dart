import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class RootBinging implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
  }
}
