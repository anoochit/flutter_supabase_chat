import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppController extends GetxController {
  final supabase = Supabase.instance.client;

  // constructor
  AppController() {
    authState();
  }

  // mock signup
  mockSignUp() async {
    try {
      final response = await supabase.auth.signUp(
        'anoochit@gmail.com',
        'Hello123',
      );

      if (response != null) {
        log('${response.user!.id}');
        log('${response.user!.email}');
        await supabase
            .from('contact')
            .insert({'id': response.user!.id, 'username': '${response.user!.email}'}).whenComplete(
                () => log("insert user data complete"));
      }
    } on GoTrueException catch (e) {
      log('${e.message}');
      Get.snackbar('Error', '${e.message}');
    }
  }

  // mock sign in
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

  // sign out
  signOut() async {
    await supabase.auth.signOut();
  }

  // authentication state change
  authState() {
    supabase.auth.onAuthStateChange((event, session) {
      if (session?.user == null) {
        Get.offAllNamed('/signin');
      }
    });
  }

  // is user sign in ?
  bool isSignIn() {
    return (supabase.auth.currentUser == null) ? false : true;
  }

  // get current user
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}
