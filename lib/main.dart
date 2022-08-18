import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_supabase/binding/root_binding.dart';
import 'package:flutter_supabase/pages/signin/signin.dart';
import 'package:flutter_supabase/pages/signup/signup.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home/home.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env
  await dotenv.load(fileName: ".env");

  // TODO: supabase initialized
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? "",
    anonKey: dotenv.env['SUPABASE_ANNON_KEY'] ?? "",
  );

  // run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
      home: const HomePage(),
      getPages: [
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/signup', page: () => SignInPage()),
        GetPage(name: '/signin', page: () => SignUpPage()),
      ],
    );
  }
}
