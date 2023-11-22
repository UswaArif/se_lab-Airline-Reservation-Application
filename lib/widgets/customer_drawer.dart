import 'package:flutter/material.dart';

class CustomerDrawer extends StatelessWidget {
  final Map<String, dynamic>? user;
  final VoidCallback? onProfileTap;

  const CustomerDrawer({this.user, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (user != null && user!["FullName"] != null && user!["Email"] != null)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
              color: Colors.deepPurple.shade900,
            ),
            accountName: Text(user!["FullName"] ?? ""), // Display name of the user
            accountEmail: Text(user!["Email"] ?? ""), // Email of the user
            currentAccountPicture: const CircleAvatar( 
              radius: 50.0,             
              child: Icon(Icons.person), // Placeholder icon if no profile picture
            ), 
            ),
          ListTile(
            title: const Text("View Profile"),
            onTap: () {
              if (onProfileTap != null) {
                onProfileTap!();
              }
            },
          ),
          
          // Add more menu items as needed
        ],
      ),
    );
  }
}