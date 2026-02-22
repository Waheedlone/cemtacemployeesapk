
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset(
        'assets/models/mobile_facenet.tflite',
        options: interpreterOptions,
      );
    } on PlatformException catch (e) {
      print('Failed to load model: ${e.message}');
    }
  }

  Interpreter? get interpreter => _interpreter;
}
