import 'package:flutter/material.dart';
import 'meal_plan_screen.dart';
// Import statements

void main() {
  runApp(MyApp());
}
// Launch app function

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracking App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MealPlanScreen()),
            );
          },
          child: Text('View Meal Plan'),
        ),
      ),
    );
  }
}
// Formating for main page
