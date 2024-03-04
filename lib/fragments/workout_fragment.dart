import 'package:flutter/material.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/datasets.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/components/exercise_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WorkoutFragment extends StatefulWidget {
  const WorkoutFragment({super.key});

  @override
  State<WorkoutFragment> createState() => _WorkoutFragmentState();
}

class _WorkoutFragmentState extends State<WorkoutFragment> {

  int selectedDay = 0;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(24))
          ),
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
        Expanded(
          child: FutureBuilder<List?>(
            future: getData(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data?[selectedDay].length,

                  itemBuilder: (context, index) {
                    var exercise = snapshot.data?[selectedDay][index];
                    return ExerciseContainer(
                        name:snapshot.data?[selectedDay][index]['name']
                    );
                  },
                );
              }
              else{
                return (Text("Loading", style: appTitleStyle,));
              }
            },

          ),
        )
      ],
    );
  }

  Future<List> getData() async{

    List<String> target_muscle = [];
    target_muscle.add(targetMuscles[2]);
    target_muscle.add(targetMuscles[6]);
    target_muscle.add(targetMuscles[4]);

    String level = levels[1];

    List<String> type = [];
    type.add(types[0]);
    type.add(types[2]);
    type.add(types[3]);

    print("Sending request");


    var response = await http.post(
      Uri.parse('${devML}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'uid': 'uid',
        'target_muscle': target_muscle,
        'level': level,
        'type': type,
      }),
    );
    print(response.statusCode);
    var body = jsonDecode(response.body);
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
}
