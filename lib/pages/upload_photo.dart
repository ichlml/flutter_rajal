import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:fastmu_rajal/controllers/pemeriksaan_controller.dart';

import 'package:fastmu_rajal/config/colors.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({
    super.key,
    required this.camera,
  });

  final List<CameraDescription> camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _flashMode = false;
  bool _switchCamera = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initCamera(widget.camera[0]);
  }

  Future initCamera(CameraDescription cameraDescription) async{
    _controller = CameraController(
      imageFormatGroup: ImageFormatGroup.jpeg,
      cameraDescription, 
      ResolutionPreset.high,
    );
    
    try {
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
    on CameraException catch(e) {
      throw Exception('Camera Error : $e');
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: CameraPreview(_controller)
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            !_switchCamera
                              ? ElevatedButton(
                                onPressed: () async{
                                  setState(() {
                                    _flashMode = !_flashMode;
                                  });
                                  try {
                                    await _controller.setFlashMode(
                                      _flashMode 
                                        ? FlashMode.torch
                                        : FlashMode.off
                                    );
                                  }
                                  catch (e) {
                                    print(e);
                                    throw Exception(e);
                                  }
                                },
                                child: Icon(
                                  _flashMode 
                                  ? Icons.flash_on 
                                  : Icons.flash_off,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: const CircleBorder(),
                                ),
                              )
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                ),
                            ElevatedButton(
                              onPressed: () async{
                                try {
                                  final image = await _controller.takePicture();
                                  await _controller.setFlashMode(FlashMode.off);
                                  if (!mounted) return;
                                  // If the picture was taken, display it on a new screen.
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DisplayPictureScreen(
                                        picture: image,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  // If an error occurs, log the error to the console.
                                  print(e);
                                }
                              },
                              child: Icon(
                                Icons.camera_alt,
                                size: 25,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white54,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(17.0)
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  _switchCamera = !_switchCamera;
                                  initCamera(widget.camera[_switchCamera ? 1 : 0]);
                                });
                              },
                              child: Icon(
                                Icons.cameraswitch,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final XFile picture;

  DisplayPictureScreen({super.key, required this.picture});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final FocusNode searchFocus = FocusNode();
  final captionController = TextEditingController();
  final PemeriksaanController pemeriksaanController = Get.put(PemeriksaanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('upload photo'),
        centerTitle: true,
        backgroundColor: MyColor.primary,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(32.0),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.clear),
          )
        )
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(widget.picture.path)),
            fit: BoxFit.contain,
            alignment: Alignment.topCenter
          )
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 10
                      : MediaQuery.of(context).viewInsets.bottom
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 6,
                              right: 10,
                              bottom: 6,
                              left: 5 
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(35.0),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.25),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4.0
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  // vertical: 2.0
                                ),
                                child: TextField(
                                  onEditingComplete: () => pemeriksaanController.uploadPhoto(widget.picture, captionController.text),
                                  focusNode: searchFocus,
                                  controller: captionController,
                                  onTapOutside: (event) => searchFocus.unfocus(),
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                  ),
                                  cursorColor: Colors.indigo,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500]
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Masukkan caption ...',
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.primary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.25),
                                offset: const Offset(0, 2),
                                blurRadius: 4.0),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () => pemeriksaanController.uploadPhoto(widget.picture, captionController.text),
                              child: const Padding(
                                padding: EdgeInsets.all(13.0),
                                child: Icon(Icons.send,
                                  size: 23,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}