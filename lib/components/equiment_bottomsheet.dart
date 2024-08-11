import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potencia/components/equipment_container.dart';
import 'package:potencia/components/streak_container.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/styles.dart';

class EquipmentBottomsheet extends StatelessWidget {
  String name;
  String desc;
  String cooldown;
  String warmup;
  List exercises;
  EquipmentBottomsheet({super.key, required this.name, required this.desc, required this.cooldown, required this.warmup, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            title: Text(
              name,
              maxLines: 2,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: tertiaryColor
                )
                ,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.black
                ),
                // child:
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index == 0) {
                return Text(
                  desc,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: tertiaryColor
                    )
                    ,
                  ),
                );
              }
              if(index==1){
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Warm Up',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: primaryColor
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      warmup,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: tertiaryColor
                        ),
                      ),
                    ),
                  ],
                );

              }
              if(index==2){
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Cooldown',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: primaryColor
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      cooldown,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: tertiaryColor
                        ),
                      ),
                    ),
                  ],
                );
              }
              if(index==3){
                return  Container(
                  height: MediaQuery.of(context).size.height*0.35,
                  child: ListView.builder(
                    // scrollDirection: Axis.horizontal,
                    itemCount: exercises.length,
                    // shrinkWrap: true,
                    itemBuilder: (context, index){
                      List<String> tm = exercises[index]['target_muscles'].toString().split(',');
                      return
                        EquipmentContainer(title: exercises[index]['exercise'], reps: '${exercises[index]['reps']} x ${exercises[index]['cycles']}', targetMuscles: tm, desc: '',);
                    },

                  ),
                );
              }
            },
              childCount: 4
            ),
          )
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     // Title
          //     Text('Dumbbells',
          //       style: GoogleFonts.poppins(
          //         textStyle: TextStyle(
          //             fontSize: 32,
          //             fontWeight: FontWeight.w300,
          //             color: tertiaryColor
          //         )
          //         ,
          //       ),
          //     ),
          //
          //     // Desc
          //     Text("This workout plan targets all major muscle groups using dumbbells. It's suitable for all fitness levels, and you can adjust the weight to challenge yourself.",
          //       style: GoogleFonts.poppins(
          //         textStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w300,
          //             color: tertiaryColor
          //         )
          //         ,
          //       ),
          //     ),
          //
          //     // Warm Up
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Warm Up',
          //           style: GoogleFonts.poppins(
          //             textStyle: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w300,
          //                 color: primaryColor
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     Text(
          //       '5 minutes of light cardio, such as jogging in place or jumping jacks. Follow this with dynamic stretching, like arm circles and leg swings.',
          //       style: GoogleFonts.poppins(
          //         textStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w300,
          //             color: tertiaryColor
          //         ),
          //       ),
          //     ),
          //
          //     // Cooldown
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Cooldown',
          //           style: GoogleFonts.poppins(
          //             textStyle: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w300,
          //                 color: primaryColor
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     Text(
          //       '5 minutes of static stretching, holding each stretch for 30 seconds.',
          //       style: GoogleFonts.poppins(
          //         textStyle: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w300,
          //             color: tertiaryColor
          //         ),
          //       ),
          //     ),
          //
          //     // Exercises
          //     Container(
          //       height: MediaQuery.of(context).size.height*0.35,
          //       child: ListView.builder(
          //         // scrollDirection: Axis.horizontal,
          //         itemCount: 5,
          //         // shrinkWrap: true,
          //         itemBuilder: (context, index){
          //           return
          //             EquipmentContainer(title: 'Dumbbell Bench Press', reps: '8-10 x 3', targetMuscles: ["Chest, shoulders, triceps"],);
          //         },
          //
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
