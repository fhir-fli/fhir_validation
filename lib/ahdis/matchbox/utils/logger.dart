import 'package:logger/logger.dart';

final log = Logger(
  level: Level.debug, // Set the desired log level
  printer: PrettyPrinter(
    methodCount: 0, // Hide method count in logs
    errorMethodCount: 8, // Show stack trace for errors only
    lineLength: 120, // Wrap logs to new line after this length
    colors: true, // Use colors for output
    printEmojis: false, // Print emojis for log levels
  ), // Use a pretty printer for output
);
