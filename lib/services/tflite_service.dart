export 'tflite_service_mobile.dart'
    if (dart.library.html) 'tflite_service_web.dart'
    if (dart.library.js_util) 'tflite_service_web.dart';
