# potencia

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

App Flow:-

1. Splash Screen -> Check for a firebase user and get the uid if user is signed in 
                 -> If the user is not signed in, redirect to [Login screen]
                 -> If the user is signed in, redirect to [Home screen] with his uid

2. Login Screen  -> Sign in with google account using firebase auth
                 -> Check with backend server if the user exists and his details are complete [userRoute]
                 -> If response status 201, user not registered, redirect to [Personal Details screen]
                 -> If response status 200, user is registered, redirect to [Home screen]

3. Personal Details Screen -> Takes user's personal details in 3 phases: Height, Weight, Age
                           -> Sends uid, height, weight, age to backend server [detailsRoute]
                           -> If response status is 200, redirect to [Workout Details screen]

4. Workout Details Screen  -> Takes user's workout details in 3 phases: Level, Target Muscles, Workout Types
                           -> Sends uid, workoutLevel, workoutGoal, targetMuscle to backend server [detailsRoute]
                           -> If response status is 200, fetch new exercise recommendations [newExerciseRoute] and redirect to [Home screen]

5. Home Screen  -> Contains 3 fragments: Workout Fragment, DailyGoals Fragment, Profile Fragment
                -> Fragments managed by PageView widget
                -> Workout Fragment : Fetch and display weekly schedule of exercises [fetchExerciseRoute]
                                    : Mark the completed exercises [markExerciseRoute]
                                    : Fetch new exercise recommendation [newExerciseRoute]
                -> DailyGoals Fragment : 
                -> Profile Fragment : Fetch and display personal and workout details  