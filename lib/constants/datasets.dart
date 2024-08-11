import 'dart:convert';

import 'package:flutter/material.dart';

const List<String> levels = ['Beginner', 'Intermediate', 'Expert'];

const List<String> types = ['Strength', 'Plyometrics', 'Stretching', 'Powerlifting', 'Strongman', 'Cardio', 'Olympic Weightlifting'];

const List<String> targetMuscles = ['Abdominal', 'Abductors','Adductors', 'Biceps', 'Calves', 'Chest', 'Forearms', 'Glutes', 'Hamstrings', 'Lats', 'Lower Back', 'Middle Back', 'Traps', 'Quadriceps', 'Shoulders', 'Triceps'];

const List<String> equipments = ['Bands', 'Barbell', 'Kettlebells', 'Dumbbell', 'Cable', 'Machine', 'Body Only', 'Medicine Ball', 'Exercise Ball', 'Foam Roll', 'E-Z Curl Bar', 'Other'];

// {
// "workout_plan": {"name": "Dumbbell Full Body Workout",
// "description": "This workout plan targets all major muscle groups using dumbbells. It's suitable for all fitness levels, and you can adjust the weight to challenge yourself. ","warm_up": "5 minutes of light cardio, such as jogging in place or jumping jacks. Follow this with dynamic stretching, like arm circles and leg swings.",
// "exercises": [{
// "exercise": "Dumbbell Squats","reps": "10-12",
// "cycles": "3",
// "target_muscles": "Quads, glutes, hamstrings"},
// {"exercise": "Dumbbell Bench Press",
// "reps": "8-10","cycles": "3",
// "target_muscles": "Chest, shoulders, triceps"},
// {"exercise": "Dumbbell Rows",
// "reps": "10-12","cycles": "3",
// "target_muscles": "Back, biceps"},
// {"exercise": "Dumbbell Shoulder Press",
// "reps": "8-10","cycles": "3",
// "target_muscles": "Shoulders, triceps"},
// {
// "exercise": "Dumbbell Bicep Curls","reps": "10-12",
// "cycles": "3","target_muscles": "Biceps"
// }],
// "cooldown": "5 minutes of static stretching, holding each stretch for 30 seconds."}
// }
