import 'package:flutter/foundation.dart'; // Для доступа к kDebugMode
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'logger.dart'; // Предполагается, что здесь находится ваш логгер

class _DebugFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode; // Логирование только в дебаг-режиме
  }
}

class LoggingNavigatorObserver extends RouteObserver {
  final Logger logger = Logger(filter: _DebugFilter());
  void _log(String message, [Level level = Level.debug]) { // Default level is debug
    if (kDebugMode) {
      appLogger.log(level, message); // Pass the level and message
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final fromRoute = previousRoute?.settings.name ?? 'null';
    final toRoute = route.settings.name;
    _log('Navigated from $fromRoute to $toRoute');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final fromRoute = route.settings.name;
    final toRoute = previousRoute?.settings.name ?? 'null';
    _log('Popped from $fromRoute to $toRoute');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final fromRoute = oldRoute?.settings.name ?? 'null';
    final toRoute = newRoute?.settings.name ?? 'null';
    _log('Replaced $fromRoute with $toRoute');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    final removedRoute = route.settings.name;
    _log('Removed $removedRoute');
  }
}
