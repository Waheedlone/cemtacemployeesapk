import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cnattendance/screen/dashboard/dashboard_screen.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/utils/face_service.dart';
import 'package:cnattendance/utils/firestore_service.dart';
import 'package:flutter/foundation.dart';
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
  String _status = kIsWeb ? "Face Registration not supported on Web" : "Align your face within the frame";

  @override
  void initState() {
    super.initState();
    _faceService = Provider.of<FaceService>(context, listen: false);
    if (!kIsWeb) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _status = "No cameras detected.");
        return;
      }
      
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() => _status = "Camera Error: $e");
      }
    }
  }

  Future<void> _captureAndRegister() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Face verification is only available on Mobile.")));
      return;
    }
    
    print("DEBUG: _captureAndRegister triggered");
    if (_isBusy || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isBusy = true;
      _status = "Capturing...";
    });

    try {
      final image = await _cameraController!.takePicture();
      
      setState(() => _status = "Processing image...");
      
      final decodedImage = await _faceService.processImage(image.path);
      
      if (decodedImage == null) {
        setState(() {
          _status = "Failed to process image format.";
          _isBusy = false;
        });
        return;
      }

      final inputImage = InputImage.fromFilePath(image.path);
      await Future.delayed(const Duration(milliseconds: 200));

      setState(() => _status = "Detecting faces...");
      final faces = await _faceService.detectFaces(inputImage);
      
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
      final embeddings = _faceService.extractEmbedding(decodedImage, faces.first);

      if (embeddings.isEmpty) {
        setState(() {
          _status = "Failed to extract features. Ensure good lighting.";
          _isBusy = false;
        });
        return;
      }

      setState(() => _status = "Saving to Firestore...");
      await _firestoreService.saveUserFace(widget.username, widget.password, embeddings);

      Provider.of<PrefProvider>(context, listen: false).saveFaceRegistered(true);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Face Registered Successfully!")));
      
      Navigator.of(context).pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);

    } catch (e) {
      if (mounted) {
        setState(() {
          _status = "Error: $e";
          _isBusy = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text("Face Registration")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phonelink_erase_rounded, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "Feature Not Supported",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Face registration is currently only supported on Android and iOS devices. Please use the mobile app to register your face.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Go Back"),
              )
            ],
          ),
        ),
      );
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Face Registration")),
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
                Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (!_isBusy) _captureAndRegister();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.red,
                  ),
                  child: _isBusy ? const CircularProgressIndicator(color: Colors.white) : const Text("Register Face"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

