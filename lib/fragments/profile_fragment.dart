import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potencia/constants/api.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/constants/datasets.dart';
import 'package:potencia/constants/styles.dart';
import 'package:potencia/services/routes.dart';

import '../services/google_accounts.dart';

class ProfileFragment extends StatefulWidget {
  String uid;
  String? name;
  String? email;
  ProfileFragment({super.key, required this.uid, this.name, this.email});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  bool p1 = false;
  bool p2 = false;

  String uid = '';
  String name =  '';
  String email = '';

  var image1;
  var image2;

  String weight = '';
  String height = '';
  String age = '';

  List selectedLevels = [];
  List selectedTypes = [];
  List selectedMuscles = [];

  String level = '';
  String type = '';
  String muscle = '';

  TextEditingController controller = TextEditingController();

  void getImage(var img, bool p) async{
    var temp = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(temp!=null) {
      setState(() {
        p = true;
        img = File(temp.path);
      });
    }
  }

  void getData() async{
    var response = await http.post(
      Uri.parse(signInRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // TODO: replace uid
      body: jsonEncode(<String, dynamic>{
        'uid': uid,
      }),
    );
    var body = jsonDecode(response.body);
    print(response.statusCode);
    print(body['information'].toString());
    setState((){
      weight = body['information']['weight'];
      height = body['information']['height'];
      age = body['information']['age'];

      level = body['information']['workoutLevel'];
      selectedLevels.add(level);
      print(body['information']['workoutGoal'].toString());
      // Map<String, dynamic> map;

      //
      // for(var tm in body['information']['targetMuscle']){
      //   muscles += tm.toString() + ', ';
      // }
    });
  }

  void personalDetailsDialog(String param, String value){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Update $param', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 24, color: primaryColor))),
            backgroundColor: secondaryColor,
            content: TextField(
              textAlign: TextAlign.center,
              controller: controller..text=value,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 24, color: primaryColor)),
              cursorColor: Colors.white70,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                focusColor: primaryColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){},
                style: flatButtonStyle,
                child: Text('Update',
                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: tertiaryColor)),
                ),
              )
            ],
          );
        }
    );
  }

  Future workOutDetailsDialog(String param, List data, List selectedData) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>StatefulBuilder(
            builder:(context, setState)=> AlertDialog(
              title: Text('Update $param', style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 24, color: primaryColor))),
              backgroundColor: secondaryColor,
              content: SingleChildScrollView(
                child: ListBody(
                  children:
                  data.map((item) =>
                      CheckboxListTile(
                        value: selectedData.contains(item),
                        onChanged: (value) {
                          setState(() {
                            if (param != 'level') {
                              if (selectedData.contains(item)) {
                                selectedData.remove(item);
                              }
                              else {
                                selectedData.add(item);
                              }
                            }
                            else {
                              selectedData.clear();
                              selectedData.add(item);
                            }
                            print(selectedData);
                          });
                        },
                        title: Text(
                          item, style: GoogleFonts.poppins(textStyle: TextStyle(
                            fontSize: 16, color: tertiaryColor)),),
                        activeColor: primaryColor,

                      )
                  ).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    this.setState(() {});
                    Navigator.pop(context);
                  },
                  style: flatButtonStyle,
                  child: Text('Update',
                    style: GoogleFonts.poppins(textStyle: TextStyle(
                        fontSize: 16, color: tertiaryColor)),
                  ),
                )
              ],
            )
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 245,
          backgroundColor: blackColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        var temp = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if(temp!=null) {
                          setState(() {
                            p2 = true;
                            image2 = File(temp.path);
                          });
                        }
                      },
                      child: Container(
                        color: primaryColor,
                        width: double.infinity,
                        height: 140,
                        child: (p2)?Image.file(image2, fit: BoxFit.fitWidth,):Icon(Icons.photo_camera_back, size: 64,),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 16,
                      child: GestureDetector(
                        onTap: () async{
                          var temp = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if(temp!=null) {
                            setState(() {
                              p1 = true;
                              image1 = File(temp.path);
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: (p1)?Padding(
                            padding: const EdgeInsets.all(0),
                            child: CircleAvatar(backgroundImage: FileImage(image1), radius: 46,),
                          ):Icon(Icons.camera_alt_outlined, size: 48),
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 32),
                      child: Text(
                        (name!=null)? name!:'Your Name',
                        style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: primaryColor)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                      child: Text(
                        email!,
                        style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: secondaryColor)),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index){

            // Personal Details
            if(index==0){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text('Personal Details', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 22, color: tertiaryColor)),),

                        GestureDetector(
                          onTap: (){personalDetailsDialog('Weight',weight);},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Weight: $weight kgs', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){personalDetailsDialog('Height',height);},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Height: $height cms', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){personalDetailsDialog('Age',age);},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Age: $age yrs', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Workout Details
            else if(index ==1){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Workout Details', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 22, color: tertiaryColor)),),
                            // IconButton(
                            //   onPressed: (){},
                            //   icon: Icon(Icons.edit),
                            // )
                          ],
                        ),

                        GestureDetector(
                          onTap: () async{
                            await workOutDetailsDialog('level', levels, selectedLevels);
                            setState(() {});
                            print(selectedLevels[0]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Level: ${selectedLevels[0]}', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: () async{
                            await workOutDetailsDialog('Workout Goals', types, selectedTypes);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Workout Goal: $type', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: () async{
                            await workOutDetailsDialog('Target Muscles', targetMuscles, selectedMuscles);
                            setState(() {});
                            print(selectedLevels[0]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Target Muscles: $muscle',overflow: TextOverflow.visible,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Signout
            else{
              return Center(
                child: TextButton(
                  onPressed: () async{
                    await signOutWithGoogle();
                    RouteArguments arg = RouteArguments(0);
                    Navigator.pushReplacementNamed(context, '/login', arguments: arg);
                  },
                  style: flatButtonStyle,
                  child: Text('Sign Out',
                    style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: tertiaryColor)
                    ),
                  ),
                ),
              );
            }
          },
              childCount: 3
          ),
        )
      ],
    );
  }
}
