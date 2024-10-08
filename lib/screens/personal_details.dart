import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:potencia/components/input_details.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/routes.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class PersonDetailsScreen extends StatefulWidget {

  String uid ;
  String name ;
  String email ;

  PersonDetailsScreen({super.key, required this.uid, required this.name, required this.email});

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {

  String uid = '';
  String name = '';
  String email = '';

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  int step = 0;

  String phase = '';

  List<String> phases = ['Height', 'Weight', 'Age'];

  List<String> units = ['cms', 'kgs', 'yrs'];

  // Load the detail header (Height, Weight, Age)
  void loadData(){
    print(step);
    phase = phases[step];

  }

  // Load the detail widget (Height, Weight, Age)
  Widget loadWidget(){
    phase = units[step];
    switch (step){
      case 0:
        return ValueContainer(value: phase, controller: heightController);
      case 1:
        return ValueContainer(value: phase, controller: weightController);
      case 2:
        return ValueContainer(value: phase, controller: ageController);
      default:
        return ValueContainer(value: phase, controller: heightController);
    }
  }

  // Send Personal Details to server
  void sendData(String height, String weight, String age) async{
    print("Posting Personal details");
    var response = await http.post(
      Uri.parse(detailsRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'uid': uid,
        'height': height,
        'weight' : weight,
        'age' : age,
      }),
    );
    print(response.statusCode);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid;
    name = widget.name;
    email = widget.email;
    loadData();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Headers
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
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
                      'Enter your ${phase}',
                      style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 24, color: Colors.white54)),
                    ),

                  ],
                ),

                // Input Field
                Expanded(child: loadWidget()),

                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // Reverse
                    (step>0)?IconButton(
                      onPressed: (){
                        setState(() {
                          if(step>0) {
                            step--;
                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                            loadData();
                          }
                        });
                      },
                      icon: Icon(Icons.navigate_before_outlined, size: 48,),
                      style: roundButtonStyle,
                    ) : SizedBox(),

                    // Forward
                    IconButton(
                      onPressed: (){
                        setState(() {
                          switch(step){
                            case 0:
                              if(heightController.text.isNotEmpty){
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                step++;
                                loadData();
                              }
                              break;
                            case 1:
                              if(weightController.text.isNotEmpty){
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                step++;
                                loadData();
                              }
                              break;
                            case 2:
                              if(ageController.text.isNotEmpty){
                                SystemChannels.textInput.invokeMethod('TextInput.hide');

                                // send data
                                sendData(heightController.text, weightController.text, ageController.text);
                                // navigate
                                RouteArguments args = RouteArguments(0);
                                args.uid = uid;
                                Navigator.pushReplacementNamed(context, '/workoutDetails', arguments: args);
                              }
                              break;
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
        ),
      ),
    );
  }
}





