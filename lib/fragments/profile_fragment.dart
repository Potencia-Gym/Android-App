import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/services/routes.dart';

import '../services/google_accounts.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text(
            'Profile Screen',
            style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: primaryColor)),
          ),

          Center(
            child: TextButton(
              onPressed: () async{
                await signOutWithGoogle();
                RouteArguments arg = RouteArguments(0);
                Navigator.pushReplacementNamed(context, '/login', arguments: arg);
              },
              child: Text("Signout"),
            ),
          ),
        ],
    );
  }
}
