import 'package:flutter/material.dart';
import 'package:potencia/components/streak_container.dart';

class DailyGoalsFragment extends StatefulWidget {
  const DailyGoalsFragment({super.key});

  @override
  State<DailyGoalsFragment> createState() => _DailyGoalFragmentState();
}

class _DailyGoalFragmentState extends State<DailyGoalsFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreakContainer(),
        ],
      ),

    );
  }
}
