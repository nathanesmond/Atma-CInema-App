import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Future<void>? _initializeCameraFuture;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeCameraFuture = _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeCameraFuture == null || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeCameraFuture;

            final image = await _cameraController.takePicture();

            final imagePath = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return DisplayPictureScreen(
                    imagePath: image.path,
                  );
                },
              ),
            );

            // Return the confirmed image path back to the profile screen
            if (imagePath != null && imagePath is String) {
              Navigator.pop(context, imagePath);
            }
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pop(context, imagePath);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
