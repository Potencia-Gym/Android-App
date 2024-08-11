import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potencia/components/streak_container.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';
import 'package:http/http.dart' as http;

class DailyGoalsFragment extends StatefulWidget {
  String uid;
  DailyGoalsFragment({super.key, required this.uid});

  @override
  State<DailyGoalsFragment> createState() => _DailyGoalFragmentState();
}

class _DailyGoalFragmentState extends State<DailyGoalsFragment> {

  late String uid;
  late int streakCount = 0;

  late int ex1 = 0;
  late int ex2 = 0;
  late int ex3 = 0;

  void getStreak() async{
    var response = await http.get(
      Uri.parse('${updateStreakRoute}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'uid': uid,
      },
    );
    var body = jsonDecode(response.body);
    print(body.toString());
    setState(() {
      streakCount = body['streakCount'];
      ex1 = body['exercise1'];
      ex2 = body['exercise2'];
      ex3 = body['exercise3'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    uid = widget.uid;
    getStreak();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: blackColor,
        shape: CircleBorder(side: BorderSide(color: primaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$streakCount', style: TextStyle(color: yellowColor),),
            Icon(CupertinoIcons.flame, color: yellowColor,)
          ],
        ),
      ),
      body: Column(
        children: [
          StreakContainer(uid: uid, title:'Bicep Curls', reps:'$ex1/10'),
          StreakContainer(uid: uid, title:'Jumping Jacks', reps:'$ex2/10'),
          StreakContainer(uid: uid, title:'DeadLifts', reps:'$ex3/10')
        ],

      ),
    );
  }
}
