// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

List<Message> messageFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String messageToJson(List<Message> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  Message({
    this.id,
    this.content,
    this.markAsRead,
    this.userFrom,
    this.userTo,
    this.createdAt,
    this.room,
  });

  String? id;
  String? content;
  bool? markAsRead;
  String? userFrom;
  String? userTo;
  DateTime? createdAt;
  String? room;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"] == null ? null : json["id"],
        content: json["content"] == null ? null : json["content"],
        markAsRead: json["mark_as_read"] == null ? null : json["mark_as_read"],
        userFrom: json["user_from"] == null ? null : json["user_from"],
        userTo: json["user_to"] == null ? null : json["user_to"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        room: json["room"] == null ? null : json["room"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "content": content == null ? null : content,
        "mark_as_read": markAsRead == null ? null : markAsRead,
        "user_from": userFrom == null ? null : userFrom,
        "user_to": userTo == null ? null : userTo,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "room": room == null ? null : room,
      };
}
