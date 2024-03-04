import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';

class StreakContainer extends StatelessWidget {
  const StreakContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Push Ups', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: tertiaryColor)),),
                      // Status
                      Text("Reps: 3 x 10", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: Colors.white70))),
                    ],
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.camera_alt_outlined),
                    style: roundButtonStyle,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
