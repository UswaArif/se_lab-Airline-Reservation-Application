import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:se_lab/classes/user_model.dart';

class MyDrawer extends StatelessWidget {
  final User? user;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuItem2Tap;

  MyDrawer({required this.user, this.onProfileTap, this.onMenuItem2Tap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade900,
            ),
            accountName: Text(user?.displayName ?? ""), // Display name of the user
            accountEmail: Text(user?.email ?? ""), // Email of the user
            currentAccountPicture: const CircleAvatar( 
              radius: 50.0,             
              child: Icon(Icons.person), // Placeholder icon if no profile picture
            ),         
          ),
          ListTile(
            title: Text("Add Flight"),
            onTap: () {
              if (onProfileTap != null) {
                onProfileTap!();
              }
            },
          ),
          ListTile(
            title: Text("Your trips"),
            onTap: () {
              if (onMenuItem2Tap != null) {
                onMenuItem2Tap!();
              }
            },
          ),
          // Add more menu items as needed
        ],
      ),
    );
  }
}

