import 'package:flutter/material.dart';

class NutritionTab extends StatelessWidget {
  const NutritionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.restaurant, size: 80, color: Colors.deepOrange),
          SizedBox(height: 20),
          Text(
            'Your Nutrition',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Plan and track your meals.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
