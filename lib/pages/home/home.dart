import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_supabase/controllers/app_controller.dart';
import 'package:flutter_supabase/models/contact.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final supabase = Supabase.instance.client;

class _HomePageState extends State<HomePage> {
  final AppController _controller = Get.find<AppController>();

  // ignore: deprecated_member_use
  final _contactData = supabase.from('contact').select().execute();

  // final x = supabase.from('contact').select().execute().then((value) {
  //   print(value.data);
  //   log(json.encode(value.data));
  //   final jsonString = json.encode(value.data);
  //   contactFromJson(jsonString);
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
        actions: [
          IconButton(
            onPressed: () {
              // sing out
              _controller.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: FutureBuilder(
        future: _contactData,
        builder: (BuildContext context, AsyncSnapshot<PostgrestResponse<dynamic>> snapshot) {
          // hase error
          if (snapshot.hasError) {
            return Text("Error");
          }

          // has data
          if (snapshot.hasData) {
            final response = snapshot.data;

            // TODO : should conver from list map to object
            final jsonString = json.encode(response!.data);
            final contacts = contactFromJson(jsonString);

            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                final username = contacts[index].username;
                return ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(username.toString().split('@').first),
                );
              },
            );
          }

          // loading
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text("Loading..."),
              ],
            ),
          );
        },
      ),
    );
  }
}
