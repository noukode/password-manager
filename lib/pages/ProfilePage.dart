import 'package:flutter/material.dart';
import 'package:password_manager/helpers/DatabaseHelper.dart';
import 'package:password_manager/pages/LoginPage.dart';

class ProfilePage extends StatelessWidget {
  final int userId;

  ProfilePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: DatabaseHelper.instance.getUserProfile(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text('Failed to load profile'));
        } else {
          final profile = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
            ),
            body: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(140),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 120,
                        backgroundImage: AssetImage("assets/image/user.png"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      profile['full_name'],
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(profile['username']),
                    ElevatedButton(
                      onPressed: () {
                      // Clear the stack and navigate to the Login screen
                      Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false, // Remove all previous routes
                      );
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
