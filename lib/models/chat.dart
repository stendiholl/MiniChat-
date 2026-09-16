import 'package:flutter/material.dart';

class Chat {
  final int id;
  final String name;
  final String initials;
  final Color color;
  final String lastMessage;
  final String time;
  final int unread;

  const Chat({
    required this.id,
    required this.name,
    required this.initials,
    required this.color,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
  });
}