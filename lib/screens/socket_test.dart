import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:camerax/camerax.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;


class SocketScreen extends StatefulWidget {
  const SocketScreen({super.key});

  @override
  State<SocketScreen> createState() => _SocketScreenState();
}

class _SocketScreenState extends State<SocketScreen> {


  late Io.Socket socket;

  late CameraController controller;
  late List<CameraDescription> _cameras;

  late var frame;

  var msg = '';
  String left = '0';
  String right = '0';


  void initCameras()async{
    _cameras = await availableCameras();
    controller = CameraController(_cameras[1], ResolutionPreset.low);
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
    controller.setFocusMode(FocusMode.locked);
  }

  void testSocket(){
    print('Connecting...');
    socket = Io.io("http://192.168.0.97:8000/",<String,dynamic>{
      'autoConnect':false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('connect');
      // socket.emit('send_frame', 'test');
    });
    socket.onConnectError((data) => print(data.toString()));
    socket.on("connect", (data) => print('connected'));
  }

  void testEmit(){
    socket.emit('send_frame','hi');
    socket.on('message', (data) {
      setState(() {
        msg = data;
      });
      print(data);
    });
  }

  void connectSocket(){
    print('Connecting...');
    socket = Io.io("https://d7bz6z99-8000.inc1.devtunnels.ms/",<String,dynamic>{
      'autoConnect':false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('connect');
      // socket.emit('send_frame', 'test');
    });
    socket.onConnectError((data) => print(data.toString()));
    socket.on("connect", (data) => print('connected'));
  }

  Future<void> take_picture()async {
    XFile temp=await controller.takePicture();
    setState(() {
      frame = base64Encode(File(temp.path).readAsBytesSync() as List<int>);
      emitFrame(frame);

    });
  }

  void emitFrame(String imgFrame){
    // print(imgFrame);
    socket.emit('send_frame',imgFrame);
    socket.on('message', (data) {
      setState(() {
        // msg = jsonDecode(data);
        // left = msg['left_count'];
        // right = msg['right_count'];
      });
      print(jsonDecode(data));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // connectSocket();
    initCameras();
    testSocket();
    // socket.on('message', (data) {
    //   print(data);
    //
    // });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // CameraPreview(controller),
            Text(msg),
            TextButton(
              onPressed: (){
                // take_picture();
                Timer.periodic(Duration(milliseconds: 5), (timer) {
                  // take_picture();
                  // print(DateTime.now());
                  testEmit();
                });
              },
              child: Text("Send"),
            )
          ],
        ),
      ),
    );
  }
}
