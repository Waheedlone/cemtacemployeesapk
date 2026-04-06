import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cnattendance/screen/dashboard/dashboard_screen.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/utils/face_service.dart';
import 'package:cnattendance/utils/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

class FaceRegistrationScreen extends StatefulWidget {
  final String username;
  final String? password;

  FaceRegistrationScreen({required this.username, this.password});

  @override
  _FaceRegistrationScreenState createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  CameraController? _cameraController;
  late FaceService _faceService;
  FirestoreService _firestoreService = FirestoreService();
  bool _isBusy = false;
  String _status = "Align your face within the frame";

  @override
  void initState() {
    super.initState();
    _faceService = Provider.of<FaceService>(context, listen: false);
    _initializeCamera();
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

  Future<void> _captureAndRegister() async {
    print("DEBUG: _captureAndRegister triggered");
    if (_isBusy || _cameraController == null || !_cameraController!.value.isInitialized) {
      print("DEBUG: _captureAndRegister: Bailing out - busy: $_isBusy, null: ${_cameraController == null}, initialized: ${_cameraController?.value.isInitialized}");
      return;
    }

    setState(() {
      _isBusy = true;
      _status = "Capturing...";
    });

    try {
      print("DEBUG: Taking picture...");
      final image = await _cameraController!.takePicture();
      print("DEBUG: Picture taken: ${image.path}");
      
      setState(() => _status = "Processing image...");
      
      // Fix orientation and decode image
      print("DEBUG: Decoding and fixing orientation...");
      final decodedImage = await _faceService.processImage(image.path);
      
      if (decodedImage == null) {
        print("DEBUG: decodedImage is NULL");
        setState(() {
          _status = "Failed to process image format.";
          _isBusy = false;
        });
        return;
      }
      print("DEBUG: Image decoded. Size: ${decodedImage.width}x${decodedImage.height}");

      print("DEBUG: Creating InputImage for ML Kit...");
      final inputImage = InputImage.fromFilePath(image.path);
      
      // Small delay to ensure file is accessible
      await Future.delayed(Duration(milliseconds: 200));

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

      setState(() => _status = "Extracting features...");
      print("DEBUG: Extracting embeddings...");
      final embeddings = _faceService.extractEmbedding(decodedImage, faces.first);

      if (embeddings.isEmpty) {
        print("DEBUG: Embeddings are empty");
        setState(() {
          _status = "Failed to extract features. Ensure good lighting.";
          _isBusy = false;
        });
        return;
      }
      print("DEBUG: Embeddings extracted successfully. Length: ${embeddings.length}");

      setState(() => _status = "Saving to Firestore...");
      print("DEBUG: Saving embeddings to Firestore for user: ${widget.username}");
      await _firestoreService.saveUserFace(widget.username, widget.password, embeddings);
      print("DEBUG: Firestore save successful");

      Provider.of<PrefProvider>(context, listen: false).saveFaceRegistered(true);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Face Registered Successfully!")));
      
      Navigator.of(context).pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);

    } catch (e, stacktrace) {
      print("DEBUG: CRITICAL ERROR during capture/registration: $e");
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Face Registration")),
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
                Text(_status, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (!_isBusy) _captureAndRegister();
                  },
                  child: _isBusy ? CircularProgressIndicator(color: Colors.white) : Text("Register Face"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.red,
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
