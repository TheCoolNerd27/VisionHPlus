import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera,ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }
  void onCaptureButtonPressed() async {  //on camera button press
    try {

      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        '${DateTime.now()}.png',
      );
      ImagePath = path;
      await _controller.takePicture(path); //take photo

      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
        appBar: AppBar(title: Text('Take a picture')),
    // Wait until the controller is initialized before displaying the
    // camera preview. Use a FutureBuilder to display a loading spinner
    // until the controller has finished initializing.
    body:FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Transform.scale(
              scale: _controller.value.aspectRatio / deviceRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller), //cameraPreview
                ),
              ));
        } else {
          return Center(
              child:
              CircularProgressIndicator()); // Otherwise, display a loading indicator.
        }
      },
    ),
     floatingActionButton: FloatingActionButton(
    child: Icon(Icons.camera_alt),
    onPressed: () async{
    await onCaptureButtonPressed();

    },
     ),
    );
  }
}
