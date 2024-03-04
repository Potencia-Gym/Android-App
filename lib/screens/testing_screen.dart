import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/components/exercise_container.dart';
import 'package:potencia/constants/colors.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  child: Text(index.toString()),
                );
              },
            ),
          ),
          // body: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //         height: 150,
          //         child: ListView.builder(
          //           itemCount: 3,
          //           scrollDirection: Axis.horizontal,
          //           itemBuilder: (BuildContext context, index){
          //             return ListTile(
          //               title: Text('${index}'),
          //             );
          //           },
          //         )
          //     ),
          //     //Expanded(child: ExerciseContainer()),
          //   ],
          // ),
        )
    );
  }
}
