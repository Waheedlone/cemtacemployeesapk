import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FaceService {
  late FaceDetector _faceDetector;
  Interpreter? _interpreter;

  FaceService({Interpreter? interpreter}) {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    _interpreter = interpreter;
  }

  Future<List<Face>> detectFaces(InputImage inputImage) async {
    return await _faceDetector.processImage(inputImage);
  }

  /// Processes and decodes image while fixing orientation
  Future<img.Image?> processImage(String path) async {
    final bytes = await File(path).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return null;

    // Fix orientation based on EXIF data
    return img.bakeOrientation(image);
  }

  List<double> extractEmbedding(img.Image image, Face face) {
    if (_interpreter == null) {
      print("DEBUG: extractEmbedding: Interpreter is NULL");
      return [];
    }

    try {
      // Crop face from image
      img.Image croppedFace = img.copyCrop(
        image,
        x: face.boundingBox.left.toInt(),
        y: face.boundingBox.top.toInt(),
        width: face.boundingBox.width.toInt(),
        height: face.boundingBox.height.toInt(),
      );

      // Resize to model input size (e.g., 112x112 for MobileFaceNet)
      img.Image resizedFace = img.copyResize(croppedFace, width: 112, height: 112);

      // Preprocess (normalize)
      var input = _imageToByteListFloat32(resizedFace);
      var output = Float32List(1 * 192).reshape([1, 192]); // MobileFaceNet output is 192

      print("DEBUG: Running TFLite Interpreter...");
      _interpreter!.run(input.reshape([1, 112, 112, 3]), output);
      print("DEBUG: TFLite Run Successful");

      return List<double>.from(output[0]);
    } catch (e) {
      print("DEBUG: Error in extractEmbedding: $e");
      return [];
    }
  }

  Float32List _imageToByteListFloat32(img.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (int i = 0; i < 112; i++) {
      for (int j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        // Normalize 0..255 to -1..1 (MobileFaceNet requirement)
        buffer[pixelIndex++] = (pixel.r - 127.5) / 128;
        buffer[pixelIndex++] = (pixel.g - 127.5) / 128;
        buffer[pixelIndex++] = (pixel.b - 127.5) / 128;
      }
    }
    return convertedBytes;
  }

  double compareEmbeddings(List<double> e1, List<double> e2) {
    if (e1.length != e2.length) return 1.0;
    double sum = 0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow(e1[i] - e2[i], 2);
    }
    return sqrt(sum);
  }

  void dispose() {
    _faceDetector.close();
  }
}
