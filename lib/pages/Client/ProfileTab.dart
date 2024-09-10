import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  User? _currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      _currentUser = FirebaseAuth.instance.currentUser;
      if (_currentUser == null) {
        setState(() {
          _errorMessage = "User not logged in";
          _isLoading = false;
        });
        return;
      }

      final email = _currentUser!.email;
      print('Current user email: $email'); // Debug log

      final userDocs = await FirebaseFirestore.instance
          .collection('clients') // Ensure this matches your Firestore structure
          .where('email', isEqualTo: email)
          .get();

      if (userDocs.docs.isNotEmpty) {
        setState(() {
          _userData = userDocs.docs.first.data();
          _isLoading = false;
        });
        print('User data: $_userData'); // Debug log
      } else {
        setState(() {
          _errorMessage = "No user data found";
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e'); // Debug log
      setState(() {
        _errorMessage = "Failed to fetch user data";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Picture
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orangeAccent, width: 4),
              ),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: _userData?['profileImageUrl'] != null
                    ? NetworkImage(_userData!['profileImageUrl'])
                    : const AssetImage('assets/images/profile.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              _userData?['fullname'] ?? 'John Doe',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Bio or Goal
            Text(
              _userData?['goal'] ?? 'Your Fitness Goal',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Contact Details (example)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.orangeAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _userData?['email'] ?? 'No email provided',
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
