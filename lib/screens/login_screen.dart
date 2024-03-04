import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/google_accounts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:potencia/services/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  void getCurrentUser() async{
    User? user = await FirebaseAuth.instance.currentUser;
    print(user?.displayName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();

  }

  void test() async{
    var response = await http.get(
      Uri.parse('${api}health-check'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.statusCode);
    print(response.body);
  }

  void redirect(String? uid, String? name, String? email) async{
    var response = await http.post(
      Uri.parse('${api}user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'uid': uid,
        'name': (name!=null)?name:'User',
        'email': email
      }),
    );
    print(response.statusCode);
    print(response.body);
    var body = jsonDecode(response.body);
    if (response.statusCode==200){
      Navigator.pushReplacementNamed(context, '/home', arguments: RouteArguments(0));
    }
    else if(response.statusCode==201){
      RouteArguments args = RouteArguments(0);
      args.uid = body['uid'];
      args.name = body['name'];
      args.email = body['email'];
      Navigator.pushReplacementNamed(context, '/personDetails', arguments: args);
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scaffold(
          backgroundColor: blackColor,
          body: Center(
            child: Stack(
              children: [
                Center(child: Image.asset('assets/ManPunch.png', fit: BoxFit.cover,)),
                Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo Text
                  Row(
                    children: [
                      Hero(
                          tag:'Logo',
                          child: Image.asset("assets/logo.png", scale: 16,)
                      ),
                      Text(
                        "otencia.Ai",
                        style: GoogleFonts.syne(
                          textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w800 ,color: tertiaryColor)
                        ),
                      )
                    ],
                  ),


                  // Login Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Sign in to your account",
                        style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 24, color: primaryColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: primaryColor,
                        ),
                      ),

                      TextButton(
                          onPressed: ()async {
                            await signInWithGoogle();
                            User? user = FirebaseAuth.instance.currentUser;
                            redirect(user?.uid, user?.displayName, user?.email);
                          },
                          style: flatButtonStyle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Brand(Brands.google),
                              ),
                              Text(
                                "Login with Google",
                                style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor, fontSize: 24)),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),

                ],
              ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
