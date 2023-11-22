import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/pages/add_flight_page.dart';
import 'package:se_lab/pages/llogin_page.dart';
import 'package:se_lab/widgets/customer_drawer.dart';

class CustomerHomePage extends StatefulWidget {
  final Map<String, dynamic> UserData;
  const CustomerHomePage({
    Key? key,
    required this.UserData,
  }) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _customerPageState();
}

class _customerPageState extends State<CustomerHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _toController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  void _openDrawer() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Customer Home Page"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          IconButton(
            onPressed: ()async {
              try {
                await FirebaseAuth.instance.signOut();
                print("DOne");
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with the actual name of your sign-up page class
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
      drawer: CustomerDrawer( 
        // Use the CustomerDrawer widget as drawer
        user: widget.UserData,
        onProfileTap: () {
          Navigator.of(context).pop();
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFlight()), // Replace with the actual name of your sign-up page class
          );*/
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _toController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the "To" field';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between text fields
                  Icon(Icons.arrow_circle_right_sharp),
                  SizedBox(width: 10), // Space between text fields
                  Expanded(
                    child: TextFormField(
                      controller: _destinationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the "Destination" field';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Destination',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}