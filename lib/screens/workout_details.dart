import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/datasets.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class WorkoutDetails extends StatefulWidget {
  String uid;

  WorkoutDetails({super.key, required this.uid});

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {

  int step = 0;

  List<String> phases = ['Level', 'Target Muscles', 'Workout Types'];

  String phase = '';

  String uid = '';

  List<String> selectedData = [];

  List <String> data = [];

  String level = '';
  List<String> goals = [];
  List<String> muscles = [];

  void loadData(){
    print(step);
    phase = phases[step];
    switch (step){
      case 0:
        data = levels;
        break;
      case 1:
        data = targetMuscles;
        break;
      case 2:
        data = types;
      default:
        data = levels;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid;
    step = 0;
    loadData();
  }

  void sendData() async{
    print("Posting Workout details");
    for(String x in selectedData){
      if(levels.contains(x)) level = x;
      if(targetMuscles.contains(x)) muscles.add(x);
      if(types.contains(x)) goals.add(x);
    }

    var response = await http.post(
      Uri.parse(detailsRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic?>{
        'uid': uid,
        'workoutLevel': level,
        'workoutGoal' : goals,
        'targetMuscle' : muscles,
      }),
    );
    print(response.statusCode);
    if(response.statusCode == 200) fetchRecommendation();

  }

  void fetchRecommendation() async{
    var response = await http.post(
      Uri.parse('${newExerciseRoute}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // TODO: replace uid
      body: jsonEncode(<String, dynamic>{
        'uid': uid,
      }),
    );
    var body = jsonDecode(response.body);
    print(body.toString());

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: blackColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workout Details',
                      style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: primaryColor)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: (step>=0)?primaryColor:secondaryColor,
                            child: SizedBox(),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: (step>=1)?primaryColor:secondaryColor,
                            child: SizedBox(),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: (step>=2)?primaryColor:secondaryColor,
                            child: SizedBox(),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Select your ${phase}',
                      style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 24, color: Colors.white54)),
                    ),

                  ],
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: SingleChildScrollView(
                              child: ListBody(
                                children:
                                data.map((item) =>
                                    CheckboxListTile(
                                      value: selectedData.contains(item),
                                      onChanged: (value){
                                        setState(() {
                                          if(step!=0) {
                                            if (selectedData.contains(item)) {
                                              selectedData.remove(item);

                                            }
                                            else {
                                              selectedData.add(item);
                                            }
                                          }
                                          else{
                                            selectedData.clear();
                                            selectedData.add(item);
                                          }
                                          print(selectedData);
                                        });
                                      },
                                      title: Text(item, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: tertiaryColor)),),
                                      activeColor: primaryColor,

                                    )
                                ).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (step>0)?IconButton(
                      onPressed: (){
                        setState(() {
                          if(step>0) {
                            step--;
                            loadData();
                          }
                        });
                      },
                      icon: Icon(Icons.navigate_before_outlined, size: 48,),
                      style: roundButtonStyle,
                    ):SizedBox(),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          if(step<2) {
                            step++;
                            loadData();
                          }
                          else{
                            sendData();
                            RouteArguments args = RouteArguments(0);
                            args.uid = uid;
                            Navigator.pushReplacementNamed(context, '/home', arguments: args);
                          }
                        });
                      },
                      icon: Icon(Icons.navigate_next_outlined, size: 48,),
                      style: roundButtonStyle,
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


