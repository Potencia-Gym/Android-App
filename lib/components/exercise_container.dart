import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';

class ExerciseContainer extends StatefulWidget {
  String uid;
  int id;
  String day;
  String name;
  String level;
  String targetMuscle;
  String type;
  String desc;
  bool completed;
  ExerciseContainer({super.key,required this.uid, required this.id, required this.day, required this.name, required this.level, required this.targetMuscle, required this.type, required this.desc, required this.completed});

  @override
  State<ExerciseContainer> createState() => _ExerciseContainerState();
}

class _ExerciseContainerState extends State<ExerciseContainer> {
  late String uid;
  late int id;
  late String day;
  late String name;
  late String level;
  late String targetMuscle;
  late String type;
  late String desc;
  late bool completed;

  Future<int> markDone() async{
    var response = await http.post(
      Uri.parse(markExerciseRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // TODO: replace uid
      body: jsonEncode(<String, dynamic>{
        'uid': uid,
        'id': id,
        'day': day,
      }),
    );

    return(response.statusCode);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid;
    id = widget.id;
    day = widget.day;
    name = widget.name;
    level = widget.level;
    targetMuscle = widget.targetMuscle;
    type = widget.type;
    desc = widget.desc;
    completed = widget.completed;
  }

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
              Text('${widget.name}', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: tertiaryColor)),),

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
                        child: Text(widget.level, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
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
                        child: Text(widget.targetMuscle, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
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
                        child: Text(widget.type, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                      ),
                    ),
                  ),
                ],
              ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                    widget.desc,
                    style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18, color: Colors.white70))
                ),
              ),

              // Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Reps: 3 x 10", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: yellowColor))),

                  IconButton(
                    onPressed: () async{
                      print(widget.uid+':'+widget.id.toString()+':'+widget.day);
                      int status = await markDone();
                      if(status == 200) {
                        setState(() {
                          completed = !completed;
                          print(completed);
                        });
                      }
                    },
                    style: (completed)?selectedButtonStyle:flatButtonStyle,
                    icon: Icon(Icons.check_rounded,  color: tertiaryColor,),
                    //child: Text("Done", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: Colors.white70))),
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
