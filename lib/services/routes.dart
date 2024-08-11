import 'package:flutter/material.dart';
import 'package:potencia/screens/equiment_screen.dart';
import 'package:potencia/screens/home_screen.dart';
import 'package:potencia/screens/login_screen.dart';
import 'package:potencia/screens/personal_details.dart';
import 'package:potencia/screens/socket_test.dart';
import 'package:potencia/screens/splash_screen.dart';
import 'package:potencia/screens/video_stream.dart';
import 'package:potencia/screens/workout_details.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments as RouteArguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen(uid: args.uid));
      case '/personDetails':
        return MaterialPageRoute(builder: (_) => PersonDetailsScreen(uid: args.uid, name: args.name, email: args.email));
      case '/workoutDetails':
        return MaterialPageRoute(builder: (_) => WorkoutDetails(uid: args.uid,));
      case '/stream':
        return MaterialPageRoute(builder: (_) => VideoStream(uid: args.uid, title: args.name,),);
      case '/equipment':
        return MaterialPageRoute(builder: (_) => EquipmentScreen());
      default:
        return errorRoute();
    }

  }

  static Route<dynamic> errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });

  }

}


class RouteArguments{
  var arg;
  late String name;
  late String email;
  late String uid;
  RouteArguments(this.arg);

}