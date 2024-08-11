import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/routes.dart';

class EquipmentContainer extends StatelessWidget {

  String title;
  String reps;
  String desc;
  List<String> targetMuscles;

  EquipmentContainer({super.key, required this.title, required this.reps, required this.desc ,required this.targetMuscles});

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
              Text('$title', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 24, color: tertiaryColor)),),

              // Tags
              Container(
                height: MediaQuery.of(context).size.height*0.05,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: targetMuscles.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: blackColor,
                                borderRadius: BorderRadius.all(Radius.circular(16))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(targetMuscles[index], style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                            ),
                          ),
                        ],
                      ),
                    );
                  },

                ),
              ),

              //Text('$desc', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: tertiaryColor)),),

              // Status
              Container(
                child: Text(
                  "Reps: $reps",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: yellowColor)),
                  maxLines: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
