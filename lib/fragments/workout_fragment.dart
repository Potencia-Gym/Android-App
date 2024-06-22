import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/datasets.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/components/exercise_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WorkoutFragment extends StatefulWidget {
  String uid;
  WorkoutFragment({super.key, required this.uid});

  @override
  State<WorkoutFragment> createState() => _WorkoutFragmentState();
}

class _WorkoutFragmentState extends State<WorkoutFragment> {

  int selectedDay = 0;
  late String uid;
  ScrollController scrollController = ScrollController();

  List<String> days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

  List<List<dynamic>> data = [];
  List<dynamic> mon = [];
  List<dynamic> tue = [];
  List<dynamic> wed = [];
  List<dynamic> thu = [];
  List<dynamic> fri = [];
  List<dynamic> sat = [];
  List<dynamic> sun = [];

  String getDay(int day){
    switch(day){
      case 0: return 'monday';
      case 1: return 'tuesday';
      case 2: return 'wednesday';
      case 3: return 'thursday';
      case 4: return 'friday';
      case 5: return 'saturday';
      case 6: return 'sunday';
      default: return 'monday';
    }
  }

  Future<List> getData() async{

    List<String> target_muscle = [];
    target_muscle.add(targetMuscles[5]);

    String level = levels[0];

    List<String> type = [];
    type.add(types[1]);
    type.add(types[2]);
    type.add(types[3]);
    type.add(types[4]);

    print("Sending request");

    User? user = await FirebaseAuth.instance.currentUser;

    print(user?.uid.toString());
    var response = await http.post(
      Uri.parse('${devML}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // TODO: replace uid
      body: jsonEncode(<String, dynamic>{
        'uid': 'CZkzL2ox5nVqZ7QIsnxwUY7ISKJ3',
      }),
    );
    var body = jsonDecode(response.body);
    print(body.toString());
    mon = body['monday'];
    tue = body['tuesday'];
    wed = body['wednesday'];
    thu = body['thursday'];
    fri = body['friday'];
    sat = body['saturday'];
    sun = body['sunday'];

    data.add(mon);
    data.add(tue);
    data.add(wed);
    data.add(thu);
    data.add(fri);
    data.add(sat);
    data.add(sun);

    return data;

  }

  @override
  void initState() {
    // TODO: implement initState
    uid = widget.uid;
    DateTime date = DateTime.now();
    setState(() {
      selectedDay = (date.weekday +6)%7;
    });
    print(selectedDay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: blackColor,
        shape: CircleBorder(side: BorderSide(color: primaryColor),),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera, color: yellowColor,)
          ],
        ),
      ),
      backgroundColor: blackColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(24))
            ),

            // Days
            child: ListView.builder(
              itemCount: days.length,
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              itemBuilder: (BuildContext context, index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedDay = index;

                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (index==selectedDay) ?primaryColor: secondaryColor,
                        borderRadius: (index==0) ?
                        BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)) :
                        (index == 6)?
                        BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)):
                        BorderRadius.zero
                      ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(days[index], style: bodyTextStyle),
                    ),
                  ),
                );
              },
            )
          ),

          // Exercises data
          Expanded(
            child: FutureBuilder<List?>(
              future: getData(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                  int n = snapshot.data?[selectedDay].length;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: n+1,

                    itemBuilder: (context, index) {
                      if(index<n){
                        //Exercise exercise = Exercise.fromJson(snapshot.data?[selectedDay][index]);
                        int id = snapshot.data?[selectedDay][index]['id'];
                        String name = snapshot.data?[selectedDay][index]['name'];
                        String level = snapshot.data?[selectedDay][index]['level'];
                        String targetMuscle = snapshot.data?[selectedDay][index]['target_muscle'];
                        String type = snapshot.data?[selectedDay][index]['type'];
                        String desc = snapshot.data?[selectedDay][index]['desc'];
                        bool completed;
                        if (snapshot.data?[selectedDay][index]['completed'] != null) {
                          completed = snapshot.data?[selectedDay][index]['completed'];
                        }
                        else completed = false;

                        return ExerciseContainer(
                          uid: uid,
                          day: getDay(selectedDay),
                          id: id,
                          name: name,
                          level: level,
                          targetMuscle: targetMuscle,
                          type: type,
                          desc: desc,
                          completed: completed,
                        );
                      }

                      else{
                        return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 32),
                            child: OutlinedButton(
                              onPressed: (){
                                // TODO: Fetch new exercises
                                print("Fetching New Recommendations");
                              },
                              child: Center(child: Text('Tap to Fetch new Suggestions', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18, color: Colors.white70),)),
                              ),
                            )
                        );
                      }
                    },
                  );
                }
                else{
                  return Center(child: (Text("Loading", style: appTitleStyle,)));
                }
              },

            ),
          )
        ],
      ),
    );
  }




}
