import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
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
  String bannerImage = '';
  String profileImage = '';

  var image1;
  var image2;

  var weight = '';
  var height = '';
  var age = '';

  List selectedLevels = [];
  List selectedTypes = [];
  List selectedMuscles = [];

  String level = '';
  String type = '';
  String muscle = '';

  TextEditingController controller = TextEditingController();

  void getImage(var img, bool p) async{
    var temp = await ImagePicker().pickImage(source: ImageSource.gallery);
    print('hello');
    if(temp!=null) {
      setState(() async{
        p = true;
        img = File(temp.path);
      });
    }
  }

  void getData() async{
    var response = await http.post(
      Uri.parse(detailsRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'uid': uid,
      }),
    );
    var body = jsonDecode(response.body);
    print(response.statusCode);
    print(body.toString());
    setState((){
      email = body['email'];
      name = body['name'];
      bannerImage = body['bannerImage'];
      profileImage = body['profileImage'];
      weight = body['information']['weight'];
      height = body['information']['height'];
      age = body['information']['age'];

      level = body['information']['workoutLevel'][0];
      selectedLevels.add(level);

      selectedTypes = body['information']['workoutGoal'];
      for(var tm in selectedTypes){
        type += tm.toString() + ', ';
      }
      type = type.substring(0,type.length-2);

      selectedMuscles = body['information']['targetMuscle'];
      for(var tm in selectedMuscles){
        muscle += tm.toString() + ', ';
      }
      muscle = muscle.substring(0,muscle.length-2);
    });
  }

  void listToString(String param, List value){

    setState(() {
      if (param == 'workoutGoal') {
        selectedTypes = value;
        type = ' ';
        for(var tm in selectedTypes){
          type += tm.toString() + ', ';
        }
        type = type.substring(0,type.length-2);
      }
      else{
        selectedMuscles = value;
        muscle = ' ';
        for(var tm in selectedMuscles){
          muscle += tm.toString() + ', ';
        }
        muscle = muscle.substring(0,muscle.length-2);
      }

    });

  }

  void sendData(String param, dynamic value) async{
    print("Posting:$param->$value");
    var response = await http.post(
      Uri.parse(detailsRoute),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'uid': uid,
        param: value,
      }),
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 200) {
      setState(() {
        if (param == 'weight') weight = jsonDecode(response.body)['information']['weight'];
        if (param == 'height') height = jsonDecode(response.body)['information']['height'];
        if (param == 'age') age = jsonDecode(response.body)['information']['age'];
        if (param == 'workoutLevel') level = value[0];
        else listToString (param, value);
      });
    }
  }

  Future personalDetailsDialog(String param, String value) async{
    showDialog(
        context: context,
        builder: (BuildContext context) =>StatefulBuilder(
          builder:(context, setState)=>  AlertDialog(
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
                onPressed: (){
                  sendData(param.toLowerCase(), controller.text);
                  this.setState(() {});
                  Navigator.pop(context);
                  this.setState(() {});
                },
                style: flatButtonStyle,
                child: Text('Update',
                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, color: tertiaryColor)),
                ),
              )
            ],
          )
        )
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
                            if (param != 'Level') {
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
                  onPressed: ()async {
                    this.setState(() {});
                    if(param=='Level') {
                      sendData('workoutLevel', selectedData);
                    }
                    if(param=='Workout Goals') {
                      sendData('workoutGoal', selectedData);
                    }
                    if(param=='Target Muscles') {
                      sendData('targetMuscle', selectedData);
                    }
                    Navigator.pop(context);
                    this.setState(() {});
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
                    // Profile Banner
                    GestureDetector(
                      onTap: () async{
                        var temp = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if(temp!=null) {
                          setState(() {
                            p2 = true;
                            image2 = File(temp.path);
                          });

                          String fileName = image2.path.split('/').last;
                          FormData data = FormData.fromMap({
                            "banner": await MultipartFile.fromBytes(
                              File(temp.path).readAsBytesSync(),
                              filename: fileName,
                              contentType: new MediaType('image', 'jpeg')
                            ),
                            'uid': uid
                          });

                          Dio dio = new Dio();

                          await dio.post(uploadBannerRoute, data: data).then((response) {
                            var jsonResponse = jsonDecode(response.toString());
                            // print(jsonResponse);
                            setState(() {
                              imageCache.clear();
                              imageCache.clearLiveImages();
                              bannerImage = jsonResponse['banner'];
                              print(bannerImage);
                            });

                          }).catchError((error) => print(error));

                        }
                      },
                      child: Container(
                        color: primaryColor,
                        width: double.infinity,
                        height: 140,
                        child: (bannerImage!='')?Image.network(bannerImage, fit: BoxFit.fitWidth, key: ValueKey(new Random().nextInt(100)),):(p2)?Image.file(image2, fit: BoxFit.fitWidth,):Icon(Icons.photo_camera_back, size: 64,),
                      ),
                    ),

                    // Profile Pic
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

                            String fileName = image1.path.split('/').last;
                            FormData data = FormData.fromMap({
                              "profile": await MultipartFile.fromBytes(
                                  File(temp.path).readAsBytesSync(),
                                  filename: fileName,
                                  contentType: new MediaType('image', 'jpeg')
                              ),
                              'uid': uid
                            });

                            Dio dio = new Dio();

                            dio.post(uploadProfileRoute, data: data).then((response) {
                              var jsonResponse = jsonDecode(response.toString());
                              imageCache.clear();
                              imageCache.clearLiveImages();
                              setState(() {
                                profileImage = jsonResponse['profile'];
                              });

                              print(jsonResponse);
                            }).catchError((error) => print(error));

                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: (profileImage!='')?Padding(
                            padding: const EdgeInsets.all(0),
                            child: CircleAvatar(backgroundImage: NetworkImage(profileImage+'#'+ DateTime.now().millisecondsSinceEpoch.toString(),), radius: 46,),
                          ):(p1)?Padding(
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
                    // Name
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 32),
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, color: primaryColor)),
                      ),
                    ),

                    // Email
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                      child: Text(
                        email,
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
            if(index ==0){
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

                        // Weight
                        GestureDetector(
                          onTap: () async{
                            await personalDetailsDialog('Weight',weight);
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
                                child: Text('Weight: $weight kgs', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),

                        // Height
                        GestureDetector(
                          onTap: () async{
                            await personalDetailsDialog('Height',height);
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
                                child: Text('Height: $height cms', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),

                        // Age
                        GestureDetector(
                          onTap: () async{
                            await personalDetailsDialog('Age',age);
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

                        // Level
                        GestureDetector(
                          onTap: () async{
                            await workOutDetailsDialog('Level', levels, selectedLevels);
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
                                child: Text('Level: ${level}', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, color: primaryColor)),),
                              ),
                            ),
                          ),
                        ),

                        // Workout Goal
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

                        // Target Muscle
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

            // SignOut
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
