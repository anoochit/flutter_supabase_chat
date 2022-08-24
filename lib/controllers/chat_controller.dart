import 'package:flutter_supabase/controllers/app_controller.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  late Stream<dynamic> message;

  AppController appController = Get.find<AppController>();

  Stream getChatMessage({required String roomId}) {
    return appController.supabase.from('message:room=eq.$roomId').stream(['room']).order('created_at').execute();
  }

  sentMessage({required String content, required String userFrom, required String userTo, required String room}) async {
    await appController.supabase.from('message').insert({
      'content': content,
      'user_from': userFrom,
      'user_to': userTo,
      'room': room,
      // ignore: deprecated_member_use
    }).execute();
  }
}
