import 'package:flutter_supabase/controllers/app_controller.dart';
import 'package:flutter_supabase/controllers/chat_controller.dart';
import 'package:get/get.dart';

class RootBinging implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(ChatController());
  }
}
