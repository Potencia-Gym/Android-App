import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potencia/components/streak_container.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';

class DailyGoalsFragment extends StatefulWidget {
  const DailyGoalsFragment({super.key});

  @override
  State<DailyGoalsFragment> createState() => _DailyGoalFragmentState();
}

class _DailyGoalFragmentState extends State<DailyGoalsFragment> {
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
            Text('14', style: TextStyle(color: yellowColor),),
            Icon(CupertinoIcons.flame, color: yellowColor,)
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index){
            return StreakContainer();
          },
        ),

      ),
    );
  }
}
