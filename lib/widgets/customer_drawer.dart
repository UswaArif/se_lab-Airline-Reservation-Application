import 'package:flutter/material.dart';

class CustomerDrawer extends StatelessWidget {
  final Map<String, dynamic>? user;
  final VoidCallback? onProfileTap;
  final VoidCallback? onTap2;
  final VoidCallback? onTap3;
  final VoidCallback? onTap4;
  final VoidCallback? onTap5;

  const CustomerDrawer({this.user, this.onProfileTap, this.onTap2, this.onTap3, this.onTap4, this.onTap5});

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
          ListTile(
            title: const Text("View Tickets"),
            onTap: () {
              if (onTap2 != null) {
                onTap2!();
              }
            },
          ),
          ListTile(
            title: const Text("Feedback"),
            onTap: () {
              if (onTap3 != null) {
                onTap3!();
              }
            },
          ),
          ListTile(
            title: const Text("Offers"),
            onTap: () {
              if (onTap4 != null) {
                onTap4!();
              }
            },
          ),
          ListTile(
            title: const Text("About Us"),
            onTap: () {
              if (onTap5 != null) {
                onTap5!();
              }
            },
          ),
          
          // Add more menu items as needed
        ],
      ),
    );
  }
}