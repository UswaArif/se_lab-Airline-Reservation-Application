import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: ()async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.login),
            ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column( // Wrap ListView and Center with a Column
          children: [
            ListView(
              shrinkWrap: true, // Set shrinkWrap to true to make it fit the content
              children: [
                Text("Heading", style: Theme.of(context).textTheme.headline2),
                Text("Sub-heading", style: Theme.of(context).textTheme.subtitle2),
                Text("Paragraph", style: Theme.of(context).textTheme.bodyText1),
                ElevatedButton(onPressed: () {}, child: const Text("Elevated Button")),
                OutlinedButton(onPressed: () {}, child: const Text("Outlined Button")),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  //child: Image(image: AssetImage("assets/images/your_image.png")), // Make sure to replace with your actual image path
                ),
              ],
            ),
            Center(
              child: Text(user!.email.toString()),
            ),
          ],
        ),
      ),

    );
  }
}
