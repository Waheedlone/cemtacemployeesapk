
import 'package:image/image.dart' as img;

class FaceService {
  FaceService({dynamic interpreter});

  Future<List<dynamic>> detectFaces(dynamic inputImage) async {
    print('FaceService: Web stub - detectFaces skipped');
    return [];
  }

  Future<img.Image?> processImage(String path) async {
    print('FaceService: Web stub - processImage skipped');
    return null;
  }

  List<double> extractEmbedding(img.Image image, dynamic face) {
    print('FaceService: Web stub - extractEmbedding skipped');
    return [];
  }

  double compareEmbeddings(List<double> e1, List<double> e2) {
    return 1.0;
  }

  void dispose() {
    print('FaceService: Web stub - dispose skipped');
  }
}
