import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var appLogger = Logger(
  filter: _DebugFilter(),
);

class _DebugFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode; // Логирование только в дебаг-режиме
  }
}
