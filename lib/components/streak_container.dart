import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/routes.dart';

class StreakContainer extends StatelessWidget {

  String uid;
  String title;
  String reps;

  StreakContainer({super.key, required this.uid ,required this.title, required this.reps});

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
                      Text(title, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: tertiaryColor)),),
                      // Status
                      Text("Reps: $reps", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: yellowColor))),
                    ],
                  ),
                  IconButton(
                    onPressed: (){
                      RouteArguments args = RouteArguments(0);
                      args.uid = uid;
                      args.name = title;
                      Navigator.pushNamed(
                          context, '/stream', arguments: args);

                    },
                    icon: Icon(Icons.camera_alt_outlined, color: yellowColor,),
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
