import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;
import 'package:http/http.dart' as http;

class VideoStream extends StatefulWidget {

  String uid;
  String title;
  VideoStream({super.key, required this.uid, required this.title});

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {

  late Io.Socket socket;

  late CameraController controller;
  late List<CameraDescription> _cameras;

  late var frame;
  bool isCameraInitialized = false;
  var msg = '';

  String uid = '';
  String title = '';
  String route = '';
  int ex = 0;
  String val1 = '0';
  String val2 = '0';
  String val3 = '0';
  int cam = 0;
  bool flash = false;

  bool start = false;

  void initCameras(int cam)async{
    _cameras = await availableCameras();
    controller = CameraController(_cameras[cam], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
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
    controller.setFocusMode(FocusMode.locked);

  }

  void connectSocket(){
    print('Connecting...');
    socket = Io.io("http://192.168.71.59:8000/",<String,dynamic>{
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
    socket.emit(route,imgFrame);
    socket.on('message', (data) {
      setState(() {
        msg = data;
        val1 = msg.split(' ')[0];
        val2 = msg.split(' ')[1];
        val3 = msg.split(' ')[3];
      });
      print(data);
      if(int.parse(val1)>10 && int.parse(val2)>10){
        // update Streak
        updateStreak();
      }
    });

  }

  // 172.17.177.183:8000
  void updateStreak() async{

    int ex1 = ((int.parse(val1)+int.parse(val2))/2) as int;
    int ex2 = (int.parse(val2)) as int;
    int ex3 = (int.parse(val3)) as int;
    // val = (val>10)?10:val;
    var response = await http.post(
      Uri.parse('${updateStreakRoute}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid': uid,
      },
      body: jsonEncode(<String, dynamic>{
        'exercise1': (title=='Bicep Curls')?ex1:0,
        'exercise2': (title=='Jumping Jacks')?ex2:0,
        'exercise3': (title=='DeadLifts')?ex3:0,
      }),
    );
    var body = jsonDecode(response.body);
    print(body.toString());

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid;
    title = widget.title;
    if(title=='Bicep Curls') {
      ex = 0;
      route = 'send_frame';
    }
    else if(title=='Jumping Jacks') {
      ex = 1;
      route = 'jump_frame';
    }
    else if(title=='DeadLifts') {
      ex = 2;
      route = 'deadlift_frame';
    }
    connectSocket();
    initCameras(0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    updateStreak();
    controller.dispose();
    socket.disconnect();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$title', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: tertiaryColor)),),
                  // Status
                  Text("Reps: 10", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: yellowColor))),
                ],
              ),
            ),
            (isCameraInitialized)?
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: (){
                    controller.setFocusMode(FocusMode.auto);
                    controller.setFocusMode(FocusMode.locked);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 1),
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 10,
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        initCameras((++cam)%2);
                      });
                    },
                    icon: Icon(Icons.flip_camera_ios_outlined),
                    style: roundButtonStyle,
                  ),
                ),

                // (socket.connected)?Text('Connecting...'):Text('Connected...')
              ],
            ):
            Center(child: (Text('Loading...', style: appTitleStyle,))),
            // Text(msg),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (ex==0)?Text('Left:$val1 Right:$val2', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: yellowColor))):
                    (ex==1)?Text('Counter:$val2', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: yellowColor))):
                    Text('Counter:$val3 \nLeg Distance:$val2 ', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: yellowColor)))
                    ,
                  ],
                ),

                // Start-Stop Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: TextButton(
                    onPressed: (){
                      if(!start) {
                        connectSocket();
                        Timer.periodic(Duration(microseconds: 100), (timer) {
                          take_picture();
                          // if(socket.disconnected) timer.cancel();
                        });
                        setState(() {
                          start = true;
                        });
                      }
                      else{
                        setState(() {
                          start = false;
                        });
                        socket.disconnect();
                      }
                    },
                    style: flatButtonStyle,
                    child: Text((start)?"Stop":"Start", style: bodyTextStyle,),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


// void testSocket(){
//   print('Connecting...');
//   socket = Io.io("http://192.168.0.97:8000/",<String,dynamic>{
//     'autoConnect':false,
//     'transports': ['websocket'],
//   });
//   socket.connect();
//   socket.onConnect((_) {
//     print('connect');
//     // socket.emit('send_frame', 'test');
//   });
//   socket.onConnectError((data) => print(data.toString()));
//   socket.on("connect", (data) => print('connected'));
// }
//
// void testEmit(){
//   socket.emit('send_frame','hi');
//   socket.on('message', (data) => print(data));
// }