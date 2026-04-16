import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cnattendance/utils/face_service.dart';
import 'package:cnattendance/utils/firestore_service.dart';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:cnattendance/services/tflite_service.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

class FaceVerificationScreen extends StatefulWidget {
  final Function() onSuccess;

  FaceVerificationScreen({required this.onSuccess});

  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  CameraController? _cameraController;
  late FaceService _faceService;
  FirestoreService _firestoreService = FirestoreService();
  bool _isBusy = false;
  String _status = "Look at the camera";
  List<double>? _storedEmbeddings;

  @override
  void initState() {
    super.initState();
    final tfliteService = Provider.of<TfliteService>(context, listen: false);
    _faceService = FaceService(interpreter: tfliteService.interpreter);
    _loadUserData();
    _initializeCamera();
  }

  Future<void> _loadUserData() async {
    try {
      final pref = Preferences();
      final user = await pref.getUser();
      print("DEBUG: Loading face data for user: ${user.username}");
      final faceData = await _firestoreService.getUserFace(user.username);
      if (faceData != null) {
        setState(() {
          _storedEmbeddings = List<double>.from(faceData['embeddings']);
          print("DEBUG: Face data loaded successfully");
        });
      } else {
        setState(() {
          _status = "No face registered. Please register first.";
          print("DEBUG: No face data found in Firestore");
        });
      }
    } catch (e) {
      print("DEBUG: Error loading user data: $e");
      setState(() {
        _status = "Error loading data. Check Firestore rules.";
      });
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _verifyFace() async {
    print("DEBUG: _verifyFace triggered");
    if (_isBusy || _cameraController == null || !_cameraController!.value.isInitialized || _storedEmbeddings == null) {
      print("DEBUG: _verifyFace: Bailing out - busy: $_isBusy, null: ${_cameraController == null}, initialized: ${_cameraController?.value.isInitialized}, embeddings: ${_storedEmbeddings != null}");
      return;
    }

    setState(() {
      _isBusy = true;
      _status = "Verifying...";
    });

    try {
      print("DEBUG: Taking verification picture...");
      final image = await _cameraController!.takePicture();
      print("DEBUG: Picture taken: ${image.path}");

      setState(() => _status = "Processing image...");
      
      // Fix orientation and decode image
      print("DEBUG: Decoding and fixing orientation...");
      final decodedImage = await _faceService.processImage(image.path);
      
      if (decodedImage == null) {
        print("DEBUG: decodedImage is NULL");
        setState(() {
          _status = "Failed to process image.";
          _isBusy = false;
        });
        return;
      }
      print("DEBUG: Image decoded. Size: ${decodedImage.width}x${decodedImage.height}");

      print("DEBUG: Creating InputImage for ML Kit...");
      final inputImage = InputImage.fromFilePath(image.path);
      
      setState(() => _status = "Detecting faces...");
      print("DEBUG: Detecting faces...");
      final faces = await _faceService.detectFaces(inputImage);
      print("DEBUG: Faces detected: ${faces.length}");
      
      if (faces.isEmpty) {
        setState(() {
          _status = "No face detected. Try again.";
          _isBusy = false;
        });
        return;
      }

      if (faces.length > 1) {
        setState(() {
          _status = "Multiple faces detected. Ensure only one person is in frame.";
          _isBusy = false;
        });
        return;
      }

      setState(() => _status = "Comparing faces...");
      print("DEBUG: Extracting current embeddings...");
      final currentEmbeddings = _faceService.extractEmbedding(decodedImage, faces.first);

      if (currentEmbeddings.isEmpty) {
        print("DEBUG: currentEmbeddings are empty");
        setState(() {
          _status = "Failed to extract features.";
          _isBusy = false;
        });
        return;
      }
      print("DEBUG: currentEmbeddings extracted successfully. Length: ${currentEmbeddings.length}");

      print("DEBUG: Comparing embeddings...");
      double distance = _faceService.compareEmbeddings(_storedEmbeddings!, currentEmbeddings);
      print("DEBUG: Face Match Distance: $distance");

      if (distance < 0.8) { // Threshold for MobileFaceNet
        print("DEBUG: Face matched successfully!");
        widget.onSuccess();
        Navigator.of(context).pop();
      } else {
        print("DEBUG: Face recognition failed. Distance: $distance");
        setState(() {
          _status = "Face Not Recognized!";
          _isBusy = false;
        });
      }

    } catch (e, stacktrace) {
      print("DEBUG: CRITICAL ERROR during face verification: $e");
      print("DEBUG: Stacktrace: $stacktrace");
      setState(() {
        _status = "Error: $e";
        _isBusy = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Face Verification")),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(_cameraController!),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(125),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(_status, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: _status.contains("Recognized") ? Colors.red : Colors.black)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("DEBUG: Verify Button Tapped");
                    if (!_isBusy) _verifyFace();
                  },
                  child: _isBusy ? CircularProgressIndicator(color: Colors.white) : Text("Verify Face"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
