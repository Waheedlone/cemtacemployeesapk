import 'dart:developer' as developer;

class Log {
  static void d(String tag, String message) {
    developer.log(message, name: tag, level: 800); // 800 is INFO level
    print("ExampleLog D/$tag: $message");
  }

  static void e(String tag, String message) {
    developer.log(message, name: tag, level: 1000); // 1000 is SEVERE level
    print("ExampleLog E/$tag: $message");
  }

  static void i(String tag, String message) {
    developer.log(message, name: tag, level: 800);
    print("ExampleLog I/$tag: $message");
  }
}
