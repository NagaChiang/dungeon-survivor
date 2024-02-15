import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;

Logger get logger => Logger.instance;

class Logger {
  static final Map<log.Level, String> levelStringMap = initLevelStringMap();

  static Logger get instance => _instance ??= Logger._();
  static Logger? _instance;

  late final log.Logger _logger;

  static Map<log.Level, String> initLevelStringMap() {
    final Map<log.Level, String> map = {};
    for (log.Level level in log.Level.values) {
      map[level] = level.toString().split('.').last;
    }

    return map;
  }

  Logger._() {
    var logLevel = log.Level.trace;
    if (kReleaseMode) {
      logLevel = log.Level.info;
    }

    bool isTestMode = Platform.environment.containsKey('FLUTTER_TEST');
    if (isTestMode) {
      logLevel = log.Level.off;
    }

    _logger = log.Logger(
      printer: log.PrettyPrinter(
        methodCount: 0,
        printEmojis: false,
        noBoxingByDefault: true,
      ),
      level: logLevel,
    );
  }

  void trace(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final formatMessage = _formatMessage(log.Level.trace, tag, message);
    _logger.t(
      formatMessage,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void debug(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final formatMessage = _formatMessage(log.Level.debug, tag, message);
    _logger.d(
      formatMessage,
      error: error,
      stackTrace: stackTrace,
    );

    // FirebaseCrashlytics.instance.log(formatMessage);
  }

  void info(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final formatMessage = _formatMessage(log.Level.info, tag, message);
    _logger.i(
      formatMessage,
      error: error,
      stackTrace: stackTrace,
    );

    // FirebaseCrashlytics.instance.log(formatMessage);
  }

  void warning(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final formatMessage = _formatMessage(log.Level.warning, tag, message);
    _logger.w(
      formatMessage,
      error: error,
      stackTrace: stackTrace,
    );

    // FirebaseCrashlytics.instance.log(formatMessage);
  }

  void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    bool shouldSend = true,
  }) {
    final formatMessage = _formatMessage(log.Level.error, tag, message);
    _logger.e(
      formatMessage,
      error: error,
      stackTrace: stackTrace,
    );

    // FirebaseCrashlytics.instance.log(formatMessage);

    // if (shouldSend) {
    //   FirebaseCrashlytics.instance.recordError(
    //     error,
    //     stackTrace,
    //     reason: message,
    //   );
    // }
  }

  String _formatMessage(log.Level level, String? tag, String message) {
    String formatted = '${levelStringMap[level]} | ';
    if (tag != null) {
      formatted += '$tag | ';
    }

    formatted += message;

    return formatted;
  }
}
