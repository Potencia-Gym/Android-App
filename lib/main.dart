import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:potencia/screens/home_screen.dart';
import 'package:potencia/screens/login_screen.dart';
import 'package:potencia/screens/splash_screen.dart';
import 'package:potencia/screens/testing_screen.dart';
import 'package:potencia/screens/video_stream.dart';
import 'package:potencia/screens/workout_details.dart';
import 'package:potencia/services/routes.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potencia',
      home:const SplashScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: myTheme,
    );
  }
}

