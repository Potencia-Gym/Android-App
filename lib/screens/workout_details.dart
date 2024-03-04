import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/datasets.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/routes.dart';

class WorkoutDetails extends StatefulWidget {
  const WorkoutDetails({super.key});

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {

  int step = 0;

  List<String> phases = ['Level', 'Target Muscles', 'Workout Types'];

  String phase = '';

  List<String> selectedData = [];

  List <String> data = [];

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
    step = 0;
    loadData();
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
                            Navigator.pushReplacementNamed(context, '/home', arguments: RouteArguments(0));
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


