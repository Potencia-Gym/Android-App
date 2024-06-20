import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:potencia/screens/home_screen.dart';
import 'package:potencia/screens/login_screen.dart';
import 'package:potencia/screens/socket_test.dart';
import 'package:potencia/screens/splash_screen.dart';
import 'package:potencia/screens/testing_screen.dart';
import 'package:potencia/screens/video_stream.dart';
import 'package:potencia/screens/workout_details.dart';
import 'package:potencia/services/routes.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;

late Io.Socket socket;


void main() async {
  runApp( MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potencia',
      home:const SocketScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: myTheme,
    );
  }
}

