import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppController extends GetxController {
  final supabase = Supabase.instance.client;

  AppController() {
    authState();
  }

  mockSignUp() async {
    final response = await supabase.auth.signUp(
      'anoochit@gmail.com',
      'Hello123',
    );
    log('${response.user!.id}');
    log('${response.user!.email}');
  }

  mockSignIn() async {
    try {
      final response = await supabase.auth.signIn(
        email: 'anoochit@gmail.com',
        password: 'Hello123',
      );

      if (response.user != null) {
        log('${response.user!.id}');
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/signin');
      }
    } on GoTrueException catch (e) {
      log('${e.message}');
      Get.snackbar('Error', '${e.message}');
    }
  }

  signOut() async {
    await supabase.auth.signOut();
  }

  authState() {
    supabase.auth.onAuthStateChange((event, session) {
      if (session?.user == null) {
        //log('user not signd in');
        Get.offAllNamed('/signin');
      }
      //log('user signed in');
    });
  }

  bool isSignIn() {
    return (supabase.auth.currentUser == null) ? false : true;
  }
}
