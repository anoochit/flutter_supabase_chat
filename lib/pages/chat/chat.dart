import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_supabase/const.dart';
import 'package:flutter_supabase/models/message.dart';
import 'package:flutter_supabase/widgets/center_loading.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> arg = Get.arguments;

  late String peerId;
  late String roomId;

  late Stream<dynamic> response;

  TextEditingController textMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    peerId = arg[0];
    roomId = arg[1];
    log('peer = $peerId');
    log('room = $roomId');

    response = supabase.from('message:room=eq.$roomId').stream(['room']).order('created_at').execute();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          // message list
          Expanded(
            child: StreamBuilder(
              stream: response,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // has error
                if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }

                // has data
                if (snapshot.hasData) {
                  final response = snapshot.data;
                  // log('$response');

                  final jsonString = jsonEncode(response);
                  //log(jsonString);
                  final messages = messageFromJson(jsonString);

                  // final messages = response.data;
                  // log('$messages');
                  // log('length = ${messages.length}');
                  return ListView.builder(
                    reverse: true,
                    itemCount: response.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Align(
                          alignment:
                              (messages[index].userFrom == peerId) ? Alignment.centerLeft : Alignment.centerRight,
                          child: Text('${messages[index].content}'),
                        ),
                      );
                    },
                  );
                  //return Container();/
                }

                // loading
                return const CenterLoading();
              },
            ),
          ),
          const Divider(
            thickness: 1.0,
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextFormField(
                controller: textMessageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     Icons.send,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  //   onPressed: () {
                  //     // send message
                  //   },
                  // ),
                ),
                onFieldSubmitted: ((value) {
                  // send message
                  if (textMessageController.text.trim().isNotEmpty) {
                    supabase.from('message').insert({
                      'content': textMessageController.text.trim(),
                      'user_from': supabase.auth.currentUser!.id,
                      'user_to': peerId,
                      'room': roomId,
                      // ignore: deprecated_member_use
                    }).execute();
                  }
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// owner = cf599367-4910-4938-9b4c-5e5512036c49
// peer = 0ad11ea4-4ebc-4096-9f36-0036e7d57846
