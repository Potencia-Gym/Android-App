import 'package:flutter/material.dart';

const String devDB = "http://172.16.150.10:3000/api/";

const String devML = "https://potencia-backend.netlify.app/api/exercises";

const String prod = "https://potencia-backend.netlify.app/api/";

const String api = "https://potencia-backend.netlify.app/api/";

const String exc = "https://potencia-backend.netlify.app/api/exercises";

const String detailsRoute = "${api}user/details";

const String userRoute = "${api}user";

const String markExerciseRoute = "${api}exercises/mark";

const String uploadProfileRoute = "${api}user/uploadprofile";

const String uploadBannerRoute = "${api}user/uploadbanner";

// firebase signup
// check for user and get existing data --> api/user  (200 if exercises exists or else 201)
// personal+workout details and get updated data --> api/user/details
// mark exercise done --> day, exid, userid --> api/exercises/mark
// upload profilepic /api/user/upload