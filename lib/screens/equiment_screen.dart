import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:potencia/components/equiment_bottomsheet.dart';
import 'package:potencia/components/streak_container.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {

  late CameraController controller;
  late List<CameraDescription> _cameras;
  bool isCameraInitialized = false;

  bool clicked = false;

  String name = "";
  String desc= "";
  String warmup= "";
  String cooldown = "";

  var exercises;

  void initCameras()async{
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }setState(() {
        isCameraInitialized = true;
      });
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
      setState(() {
        name = jsonResponse['workout_plan']['name'];
        desc = jsonResponse['workout_plan']['description'];
        warmup = jsonResponse['workout_plan']['warm_up'];
        cooldown = jsonResponse['workout_plan']['cooldown'];
        // exercises = jsonResponse['workout_plan']['exercises'];
        var ex = jsonResponse['workout_plan']['exercises'];
        exercises = ex != null ? List.from(ex) : null;

        print(exercises);
        // print(jsonDecode(exercises)[0]);

      });

    }).catchError((error) => print(error));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCameras();
  }

  void openBottomSheet(){
    showModalBottomSheet(
      backgroundColor: Colors.black,
      // isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: 0.75,
      constraints: BoxConstraints.loose(
          Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height ,
          )
      ),
      context: context,
      builder: (context){return EquipmentBottomsheet(name: name, desc: desc, cooldown: cooldown, warmup: warmup, exercises: exercises,);},

    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: (isCameraInitialized)?CameraPreview(controller):
              Center(child: (Text('Loading...', style: appTitleStyle,))),
            ),

            IconButton(
              onPressed: () async{
                if(!clicked){
                  setState(() {
                    clicked = true;
                  });
                  await take_picture();
                  openBottomSheet();
                  setState(() {
                    clicked = false;
                  });
                }
              },
              style: roundButtonStyle,
              icon: (!clicked)?Icon(Icons.camera, size: 64, color: Colors.orangeAccent,):Icon(Icons.watch_later_outlined, size: 64, color: Colors.orangeAccent),
            )
          ],
        ),
      ),
    );
  }
}
