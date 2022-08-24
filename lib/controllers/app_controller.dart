import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppController extends GetxController {
  SupabaseClient supabase = Supabase.instance.client;

  // constructor
  AppController() {
    authState();
  }

  // mock signup
  Future<bool> signUp({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signUp(
        email,
        password,
      );

      if (response != null) {
        log('${response.user!.id}');
        log('${response.user!.email}');
        await supabase
            .from('contact')
            .insert({'id': response.user!.id, 'username': '${response.user!.email}'}).whenComplete(
                () => log("insert user data complete"));
        return true;
      } else {
        return false;
      }
    } on GoTrueException catch (e) {
      log('${e.message}');
      return false;
    }
  }

  //   sign in
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signIn(
        email: email,
        password: password,
      );

      log('uid = ${response.user!.id}');

      if (response.user != null) {
        log('${response.user!.id}');
        return true;
      } else {
        return false;
      }
    } on GoTrueException catch (e) {
      log('${e.message}');
      return false;
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
      } else {
        Get.offAllNamed('/home');
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
