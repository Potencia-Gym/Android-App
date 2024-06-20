import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 3),
            ()
        {
          print("Trying to change");
          User? user = FirebaseAuth.instance.currentUser;
          if(user!=null) {
            print("User Found");
            RouteArguments args = RouteArguments(0);
            args.uid = user.uid;
            Navigator.pushReplacementNamed(
                context, '/home', arguments: args);
          }
          else{
            print("User not found");
            Navigator.pushReplacementNamed(
                context, '/login', arguments: RouteArguments(0));
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: blackColor,
          body: Center(
            child: Row(
              children: [
                Hero(tag: 'Logo', child: Image.asset('assets/logo.png',scale: 10,)),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                        'otencia.AI',
                        textStyle: appTitleStyle,
                        speed: Duration(milliseconds: 100)
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
