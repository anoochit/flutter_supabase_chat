import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_supabase/const.dart';
import 'package:flutter_supabase/controllers/chat_controller.dart';
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
  ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    peerId = arg[0];
    roomId = arg[1];
    log('peer = $peerId');
    log('room = $roomId');
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
              stream: chatController.getChatMessage(roomId: roomId),
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
                  // log('$messages');

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
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                ),
                onFieldSubmitted: ((value) {
                  // send message
                  if (textMessageController.text.trim().isNotEmpty) {
                    // send message
                    chatController.sentMessage(
                        content: textMessageController.text.trim(),
                        userFrom: supabase.auth.currentUser!.id,
                        userTo: peerId,
                        room: roomId);
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
