import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_supabase/binding/root_binding.dart';
import 'package:flutter_supabase/controllers/app_controller.dart';
import 'package:flutter_supabase/pages/signin/signin.dart';
import 'package:flutter_supabase/pages/signup/signup.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home/home.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env
  await dotenv.load(fileName: ".env");

  // supabase initialized
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? "",
    anonKey: dotenv.env['SUPABASE_ANNON_KEY'] ?? "",
    authCallbackUrlHostname: 'login-callback',
  );

  // run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      initialBinding: RootBinging(),
      initialRoute: _controller.isSignIn() ? '/home' : '/signin',
      getPages: [
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
        GetPage(name: '/signin', page: () => SignInPage()),
      ],
    );
  }
}
