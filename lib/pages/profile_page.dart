import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile",style: TextStyle(color: Color.fromARGB(255, 89, 44, 167),),),
        backgroundColor: Colors.white, 
         iconTheme: IconThemeData(
          color: Colors.black, 
        ),
      ),
    );
  }
}