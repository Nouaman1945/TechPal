import 'package:flutter/material.dart';

class WorkoutsTab extends StatelessWidget {
  const WorkoutsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.fitness_center, size: 80, color: Colors.deepPurple),
          SizedBox(height: 20),
          Text(
            'Your Workouts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Track and manage your workout plans.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
