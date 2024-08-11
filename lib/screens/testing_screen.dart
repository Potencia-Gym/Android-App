import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:potencia/components/exercise_container.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {


  late CameraController controller;
  late List<CameraDescription> _cameras;

  void initCameras()async{
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
    controller.setFlashMode(FlashMode.off);
    controller.setFocusMode(FocusMode.auto);
  }

  Future<void> take_picture()async {
    XFile temp=await controller.takePicture();
    var image = File(temp.path);

    String fileName = image.path.split('/').last;
    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromBytes(
          File(temp.path).readAsBytesSync(),
          filename: fileName,
          contentType: new MediaType('image', 'jpeg')
      ),
    });

    Dio dio = new Dio();

    await dio.post(uploadEquipmentRoute, data: data).then((response) {
      var jsonResponse = jsonDecode(response.toString());
      print(jsonResponse);

    }).catchError((error) => print(error));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCameras();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CameraPreview(controller),

            TextButton(
              onPressed: (){
                take_picture();

              },
              child: Text("Send"),
            )
          ],
        ),
      ),
    );
  }
}
