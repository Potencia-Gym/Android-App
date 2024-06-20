import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:potencia/constants/colors.dart';
import 'package:potencia/fragments/dailygoals_fragment.dart';
import 'package:potencia/fragments/profile_fragment.dart';
import 'package:potencia/fragments/workout_fragment.dart';
import 'package:potencia/services/google_accounts.dart';
import 'package:potencia/services/routes.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class HomeScreen extends StatefulWidget {
  String uid;
  HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int pageIndex = 0;
  User? user;
  late String uid;

  PageController controller = PageController();

  void getCurrentUser() async{
    user = await FirebaseAuth.instance.currentUser;
    print(user!.uid);
    uid = user!.uid;
  }

  Widget getFragment(){
    switch(pageIndex){
      case 0:
        return WorkoutFragment(uid: 'CZkzL2ox5nVqZ7QIsnxwUY7ISKJ3');
      case 1:
        return DailyGoalsFragment();
      case 2:
        return ProfileFragment(uid: user!.uid, name: user!.displayName, email: user!.email,);
      default:
        return Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async{
                      await signOutWithGoogle();
                      RouteArguments arg = RouteArguments(0);
                      arg.uid = "";

                      Navigator.pushReplacementNamed(context, '/login', arguments: arg);
                    },
                    child: Text("Signout"),
                  ),
                ],
              ),

        );
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid;
    // getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          backgroundColor: blackColor,

          bottomNavigationBar: CurvedNavigationBar(
            animationDuration: Duration(milliseconds: 200),
            animationCurve: Curves.bounceOut,
            backgroundColor: blackColor,
            color: primaryColor,
            index: pageIndex,
            buttonBackgroundColor: primaryColor,
            items: const [
              CurvedNavigationBarItem(
                child: Icon(LineAwesome.dumbbell_solid, size: 32),
                label: 'Workouts',
              ),
              CurvedNavigationBarItem(
                child: Icon(LineAwesome.bullseye_solid, size: 32,),
                label: 'Daily Goals',

              ),
              CurvedNavigationBarItem(
                child: Icon(Icons.person_2_outlined, size: 32),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              setState(() {
                pageIndex = index;
              });
              controller.animateToPage(pageIndex, duration: Duration(milliseconds: 200), curve: Curves.bounceOut);
            },
          ),

          // body: getFragment(),
          body: PageView(
            controller: controller,
            onPageChanged: (index){
              setState(() {
                pageIndex = index;
              });
            },
            children: [
              WorkoutFragment(uid: uid),

              DailyGoalsFragment(),

              // ProfileFragment(uid: uid, name: user!.displayName, email: user!.email,),

            ],
          ),
        )
    );
  }

  void logout()async{
    await signOutWithGoogle();
    RouteArguments arg = RouteArguments(0);
    Navigator.pushReplacementNamed(context, '/login', arguments: arg);
  }


}
