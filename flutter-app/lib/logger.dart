import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(level: kDebugMode ? Level.debug : Level.error);
final loggerNoStack = Logger(
  level: kDebugMode ? Level.debug : Level.error,
  printer: PrettyPrinter(methodCount: 0),
);
