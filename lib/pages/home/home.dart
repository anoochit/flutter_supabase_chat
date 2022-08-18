import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_supabase/controllers/app_controller.dart';
import 'package:flutter_supabase/models/contact.dart';
import 'package:flutter_supabase/pages/chat/chat.dart';
import 'package:flutter_supabase/widgets/center_loading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../const.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppController _controller = Get.find<AppController>();

  // ignore: deprecated_member_use
  final _contactData = supabase.from('contact').select().neq('id', supabase.auth.currentUser!.id).execute();

  String room = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact"),
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
            return const Center(child: Text("Error"));
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
                final id = contacts[index].id;
                final username = contacts[index].username;

                // show only friends
                // if (supabase.auth.currentUser!.id != id) {
                return ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(username.toString().split('@').first),
                  subtitle: Text('$id'),
                  onTap: () {
                    // create room id
                    if (supabase.auth.currentUser!.id.compareTo(id!) > 0) {
                      room = "${supabase.auth.currentUser!.id}_$id";
                    } else {
                      room = "${id}_${supabase.auth.currentUser!.id}";
                    }
                    log('select room = $room');
                    Get.to(() => ChatPage(), arguments: [id, room]);
                  },
                );
                // }
              },
            );
          }

          // loading
          return const CenterLoading();
        },
      ),
    );
  }
}
