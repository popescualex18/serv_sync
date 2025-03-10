import 'package:talker_flutter/talker_flutter.dart';

class Logger {
  static final _logger = TalkerFlutter.init();
  static Talker get instance => _logger;
}