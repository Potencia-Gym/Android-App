import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;
import 'package:image/image.dart' as imglib;

class VideoStream extends StatefulWidget {
  const VideoStream({super.key});

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late CameraImage image;
  bool isCameraInitialized = false;

  String img = '';
  late Uint8List imgU8;

  late Io.Socket socket;

  int frames = 0;

  String base64String = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initSocket();
    // initCamera();
    //getImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();

  }

  void initSocket(){
    socket = Io.io("http://192.168.0.104:8000",<String,dynamic>{
    'autoConnect':false,
    'transports':['websocket'],
    });
    socket.connect();
    socket.onConnect((_){
      print("Connection established");
    });
    socket.onDisconnect((_)=>print("connection Disconnection"));
    socket.onConnectError((err)=>print(err));
    socket.onError((err)=>print(err));
  }

  // void initCamera() async{
  //   if(await Permission.camera.request().isGranted){
  //     cameras = await availableCameras();
  //     cameraController = CameraController(cameras[0],ResolutionPreset.max);
  //     await cameraController.initialize().then((value) {
  //
  //       print('hello');
  //       cameraController.startImageStream((image) {
  //
  //         print('hi');
  //
  //         var bytes = image.planes.map((plane) {
  //           return plane.bytes;
  //         }).toList();
  //
  //         final mergedList = [
  //           for (var sublist in bytes)
  //             ...sublist,
  //         ];
  //
  //         setState(() {
  //           base64String = base64Encode(mergedList);
  //         });
  //
  //       });
  //     });
  //
  //   }
  //   else{
  //     print("Camera Permission Denied");
  //   }
  // }

  // void initCamera() async{
  //   if(await Permission.camera.request().isGranted){
  //     cameras = await availableCameras();
  //     cameraController = CameraController(cameras[0], ResolutionPreset.low);
  //     await cameraController.initialize().then((value) {
  //       print('hi');
  //       cameraController.startImageStream((image) {
  //         print('Hello');
  //         // if(socket.connected){
  //         //   print('isConnected');
  //         //   socket.emit('send_frame',imgb64);
  //         // }
  //         // print(image.toString());
  //
  //       });
  //     });
  //     await cameraController.initialize();
  //     setState(() {
  //       isCameraInitialized = true;
  //     });
  //     //getImage();
  //   }
  // }

  // void getImage() async{
  //   while(isCameraInitialized) {
  //     XFile temp = await cameraController.takePicture();
  //
  //     var imgFile = File(temp.path);
  //     List<int> bytes = imgFile.readAsBytesSync();
  //     setState(() {
  //       base64String = base64Encode(bytes);
  //     });
  //     debugPrint(base64String);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: (isCameraInitialized)?
          Column(
            children: [
              // CameraPreview(cameraController),

              // Container(
              //   child: TextFormField(
              //     initialValue: base64String,
              //   ),
              // ),
              //
              // TextButton(
              //   onPressed: (){
              //     // getImage();
              //   },
              //   child: Text('Click'),
              // )

            ],
          ):
          Column(
            children: [
              TextFormField(
                initialValue: base64String,
              ),

              // CameraPreview(cameraController),
              Container(
                child: TextButton(
                  onPressed: (){
                    initSocket();

                    socket.emit('send_frame','test message');
                  },
                  child: Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
