import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/pages/add_baggage_page.dart';
import 'package:se_lab/pages/add_flight_page.dart';
import 'package:se_lab/pages/add_seat_page.dart';
import 'package:se_lab/pages/customer_home_page.dart';
import 'package:se_lab/pages/hotel_recommendation_page.dart';
import 'package:se_lab/pages/llogin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/pages/profile_page.dart';
import 'package:se_lab/pages/view_flight_page.dart';
import 'package:se_lab/pages/view_seat_page.dart';
import 'package:se_lab/widgets/drawer.dart';

class HomePage extends StatefulWidget  {
   HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: ()async {
              try {
                await FirebaseAuth.instance.signOut();
                print("DOne");
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()), // Replace with the actual name of your sign-up page class
                        );
                // Redirect or perform other actions after successful sign-out.
              } catch (e) {
                print("Error during sign out: $e");
                // Handle the error as needed.
              }
            },
            icon: const Icon(Icons.login),
            ),
        ],
      ),
      drawer: MyDrawer(
        user: user,
        onProfileTap: () {
          // Handle profile tap
          Navigator.of(context).pop(); 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFlight()), // Replace with the actual name of your sign-up page class
          );// Close the drawer
        },
        onMenuItem2Tap: () {
          Navigator.of(context).pop(); 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ViewFlight()), 
          );
        },
        onMenuItem3Tap: () {
          Navigator.of(context).pop(); 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSeat()), 
          );
        },
        onMenuItem4Tap: () {
          Navigator.of(context).pop(); 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ViewSeat()), 
          );
        },
        onMenuItem5Tap: () {
          Navigator.of(context).pop(); 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HotelRecommendation()), 
          );
        },
        onMenuItem6Tap: () {
          Navigator.of(context).pop(); 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBaggage()), 
          );
        },
      ),
      /*drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade900,
              ),
              accountName: Text(user!.displayName ?? ""), // Display name of the user
              accountEmail: Text(user!.email ?? ""), // Email of the user
              currentAccountPicture: const CircleAvatar( 
                radius: 50.0,             
                child: Icon(Icons.person), // Placeholder icon if no profile picture
              ),         
              
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                // Handle menu item 1 tap
              },
            ),
            ListTile(
              title: Text("Menu Item 2"),
              onTap: () {
                // Handle menu item 2 tap
              },
            ),
            // Add more menu items as needed
          ],
        ),
      ),*/

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


  

