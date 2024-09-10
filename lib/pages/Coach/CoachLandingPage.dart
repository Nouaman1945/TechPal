import 'package:flutter/material.dart';

class CoachLandingPage extends StatelessWidget {
  const CoachLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to the Coach Dashboard!'),
      ),
    );
  }
}
