import 'package:flutter_supabase/controllers/app_controller.dart';
import 'package:get/get.dart';

class RootBinging implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AppController());
  }
}
