import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/onboarding/pathSelection.dart';

class CoachSetupScreen extends StatefulWidget {
  const CoachSetupScreen({Key? key}) : super(key: key);

  @override
  _CoachSetupScreenState createState() => _CoachSetupScreenState();
}

class _CoachSetupScreenState extends State<CoachSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _certificationsController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedActivityId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PathSelectionScreen()),
            );
          },
        ), // Removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Coach Setup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _certificationsController,
                  decoration: const InputDecoration(
                    labelText: 'Certifications',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your certifications';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pricingController,
                  decoration: const InputDecoration(
                    labelText: 'Pricing',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pricing';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age <= 0) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // You may want to implement a dropdown or other selection for Activity ID
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Activity',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedActivityId,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedActivityId = newValue;
                    });
                  },
                  items: ['vZtdHL54Ma8Bz9BlXNxP', 'AnotherActivityID']
                      .map((activityId) => DropdownMenuItem(
                    value: activityId,
                    child: Text(activityId),
                  ))
                      .toList(),
                  validator: (value) =>
                  value == null ? 'Please select an activity ID' : null,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final coachData = {
        'createdAt': Timestamp.now(),
        'email': _emailController.text,
        'fullName': _fullNameController.text,
        'status': 'active',
        'updatedAt': Timestamp.now(),
        'userID': user.uid,
        'age': int.tryParse(_ageController.text) ?? 0,
        'activityID': _selectedActivityId, // Reference to the activity
        'bio': _bioController.text,
        'certifications': _certificationsController.text,
        'pricing': _pricingController.text,
        'emailRef': user.uid, // Reference to the user document
        'fullnameRef': user.uid, // Reference to the user document
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('coaches')
          .doc(user.uid)
          .set(coachData);

      Navigator.of(context).pop(); // Navigate back or to another screen
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while saving your data: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
