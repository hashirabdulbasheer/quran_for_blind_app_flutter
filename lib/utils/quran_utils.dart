import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

class QuranUtils {
  // read aloud
  static Future<void> announce(String message) async {
    final AnnounceSemanticsEvent event =
        AnnounceSemanticsEvent(message, TextDirection.ltr);
    await SystemChannels.accessibility.send(event.toMap());
  }
}
