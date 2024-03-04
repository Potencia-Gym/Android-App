import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';

class ExerciseContainer extends StatelessWidget {
  String name;
  ExerciseContainer({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text('${name}', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: tertiaryColor)),),

              // Tags
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Easy', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Abdomen', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Cardio', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                      ),
                    ),
                  ),
                ],
              ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                    'This is  pushup  desc. Lie down. \nCome up using arsm and toes',
                    style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18, color: Colors.white70))
                ),
              ),

              // Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Reps: 3 x 10", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: Colors.white70))),
                  TextButton(
                    onPressed: () {},
                    style: flatButtonStyle,
                    child: Text("Done", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: Colors.white70))),
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
