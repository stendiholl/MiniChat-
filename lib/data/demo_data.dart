import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';

final demoChats = [
  Chat(
    id: 1,
    name: 'Алексей Петров',
    initials: 'АП',
    color: const Color(0xFF3478F6),
    lastMessage: 'Привет! Как дела?',
    time: '14:32',
    unread: 2,
  ),
  Chat(
    id: 2,
    name: 'Максим Иванов',
    initials: 'МИ',
    color: const Color(0xFFFF9500),
    lastMessage: 'До завтра!',
    time: '13:15',
  ),
  Chat(
    id: 3,
    name: 'Анна Смирнова',
    initials: 'АС',
    color: const Color(0xFF34C759),
    lastMessage: 'Хорошо, договорились',
    time: '12:47',
  ),
  Chat(
    id: 4,
    name: 'Дмитрий',
    initials: 'Д',
    color: const Color(0xFFAF52DE),
    lastMessage: 'Посмотри файл, который я отправил',
    time: '11:20',
  ),
  Chat(
    id: 5,
    name: 'Мария',
    initials: 'М',
    color: const Color(0xFFFF2D55),
    lastMessage: 'Спасибо!',
    time: 'Вчера',
  ),
];

final demoContacts = [
  Contact(
    id: 1,
    name: 'Алексей Петров',
    username: '@alex',
    initials: 'АП',
    color: const Color(0xFF3478F6),
  ),
  Contact(
    id: 2,
    name: 'Максим Иванов',
    username: '@max',
    initials: 'МИ',
    color: const Color(0xFFFF9500),
  ),
  Contact(
    id: 3,
    name: 'Анна Смирнова',
    username: '@anna',
    initials: 'АС',
    color: const Color(0xFF34C759),
  ),
  Contact(
    id: 4,
    name: 'Дмитрий',
    username: '@dmitry',
    initials: 'Д',
    color: const Color(0xFFAF52DE),
  ),
  Contact(
    id: 5,
    name: 'Мария',
    username: '@maria',
    initials: 'М',
    color: const Color(0xFFFF2D55),
  ),
];

final demoMessages = [
  Message(
    id: 1,
    chatId: 1,
    text: 'Привет! Как дела?',
    time: DateTime(2026, 9, 16, 14, 30),
    isMine: false,
  ),
  Message(
    id: 2,
    chatId: 1,
    text: 'Привет! Всё отлично, а у тебя?',
    time: DateTime(2026, 9, 16, 14, 31),
    isMine: true,
  ),
  Message(
    id: 3,
    chatId: 1,
    text: 'Тоже хорошо!',
    time: DateTime(2026, 9, 16, 14, 31),
    isMine: false,
  ),
  Message(
    id: 4,
    chatId: 1,
    text: 'Что делаешь сегодня?',
    time: DateTime(2026, 9, 16, 14, 32),
    isMine: true,
  ),
];