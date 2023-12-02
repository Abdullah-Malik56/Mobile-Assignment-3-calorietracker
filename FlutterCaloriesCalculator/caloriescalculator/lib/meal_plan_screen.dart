import 'package:flutter/material.dart';
import 'food_database.dart';

class MealPlanScreen extends StatefulWidget {
  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  List<MealEntry> mealEntries = [];
  List<MealPlan> savedMealPlans = [];
  int targetCalories = 2000;

  void _addFoodItem(String foodItem) {
    setState(() {
      mealEntries
          .add(MealEntry(foodItem, FoodDatabase.foodItems[foodItem] ?? 0));
    });
  }
  // Add food function calls back to database for adding food items

  void _editMealEntry(int index) async {
    String? editedFoodItem = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Food Item'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: FoodDatabase.foodItems.keys.map((foodItem) {
                return ListTile(
                  title: Text(foodItem),
                  onTap: () {
                    Navigator.pop(context, foodItem);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    // Edit/update database entry function

    if (editedFoodItem != null) {
      setState(() {
        mealEntries[index] = MealEntry(
            editedFoodItem, FoodDatabase.foodItems[editedFoodItem] ?? 0);
      });
    }
  }

  void _deleteMealEntry(int index) {
    setState(() {
      mealEntries.removeAt(index);
    });
  }
  // Delete database entry function

  int _calculateTotalCalories() {
    return mealEntries.fold(0, (sum, entry) => sum + entry.calorieAmount);
  }

  void _saveMealPlan() {
    int totalCalories = _calculateTotalCalories();

    if (totalCalories > targetCalories) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Total calories exceed the target calories!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      DateTime currentDate = DateTime.now();
      final savedMealPlan =
          MealPlan(date: currentDate, entries: List.from(mealEntries));
      setState(() {
        savedMealPlans.add(savedMealPlan);
      });
    }
  }
  // Function for saving meal plans and their times/date at save time

  void _viewSavedMealPlans() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SavedMealPlanScreen(savedMealPlans: savedMealPlans)),
    );
  }
  // Function allows the viewing of meal plans in a list

  void _showAddFoodItemDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Food Item'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: FoodDatabase.foodItems.keys.map((foodItem) {
                return ListTile(
                  title: Text(foodItem),
                  onTap: () {
                    Navigator.pop(context);
                    _addFoodItem(foodItem);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _setTargetCalories(String input) {
    setState(() {
      targetCalories = int.tryParse(input) ?? 0;
    });
  }
  // Allows target calories to be input

  @override
  Widget build(BuildContext context) {
    int totalCalories = _calculateTotalCalories();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveMealPlan,
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _viewSavedMealPlans,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Target Calories: '),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: _setTargetCalories,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mealEntries.length,
              itemBuilder: (context, index) {
                var mealEntry = mealEntries[index];

                return ListTile(
                  title: Text(mealEntry.foodItem),
                  subtitle: Text('${mealEntry.calorieAmount} calories'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editMealEntry(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteMealEntry(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddFoodItemDialog(context);
                  },
                  child: Text('Add Food Item'),
                ),
                Text('Total Calories: $totalCalories'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SavedMealPlanScreen extends StatelessWidget {
  final List<MealPlan> savedMealPlans;

  SavedMealPlanScreen({required this.savedMealPlans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Meal Plans'),
      ),
      body: ListView.builder(
        itemCount: savedMealPlans.length,
        itemBuilder: (context, index) {
          var savedMealPlan = savedMealPlans[index];
          return ListTile(
            title: Text('Date: ${savedMealPlan.date}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: savedMealPlan.entries.map((entry) {
                return Text(
                    '${entry.foodItem}: ${entry.calorieAmount} calories');
              }).toList(),
            ),
          );ts
        },
      ),
    );
  }
}

class MealEntry {
  final String foodItem;
  final int calorieAmount;

  MealEntry(this.foodItem, this.calorieAmount);
}

class MealPlan {
  final DateTime date;
  final List<MealEntry> entries;

  MealPlan({required this.date, required this.entries});
}
// Classes to set entries and combined meal plan entries (with dates)
