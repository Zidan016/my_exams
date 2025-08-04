import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class Helper {
  static int toTimestamp(DateTime date, TimeOfDay time) {
    DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return combinedDateTime.millisecondsSinceEpoch;
  }

  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static String toMySQLDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final adjustedTime = dateTime.toUtc().add(Duration(hours: 7));
    return "${adjustedTime.year.toString().padLeft(4, '0')}-"
           "${adjustedTime.month.toString().padLeft(2, '0')}-"
           "${adjustedTime.day.toString().padLeft(2, '0')} "
           "${adjustedTime.hour.toString().padLeft(2, '0')}:"
           "${adjustedTime.minute.toString().padLeft(2, '0')}:"
           "${adjustedTime.second.toString().padLeft(2, '0')}";
  }

  String? getTrustedMime(String path) {
    final mime = lookupMimeType(path);
    if (mime != null && mime != 'application/octet-stream') {
      return mime;
    }

    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'mpeg':
        return 'video/mpeg';
      default:
        return null;
    }
  }

  static String generateRandomLetters(int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  static final AudioPlayer _player = AudioPlayer();

  static void stopAudio() {
    _player.stop();
  }

  static Future<void> playAudioSequentially(List<String> audioUrls) async {
    for (var url in audioUrls) {
      await _player.setSourceUrl(url);
      await _player.resume();
      await _player.onPlayerComplete.first;
    }
  }
}