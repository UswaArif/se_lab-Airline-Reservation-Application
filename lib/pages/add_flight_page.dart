import 'package:flutter/material.dart';

class AddFlight extends StatefulWidget {
  const AddFlight({super.key});

  @override
  State<AddFlight> createState() => _addFlightState();
}

class _addFlightState extends State<AddFlight> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flightnumber = TextEditingController();
  final TextEditingController _source = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _availableseats = TextEditingController();
  final TextEditingController _flightstatus = TextEditingController();
  bool isLoading = false;


  DateTime? selectedDateTime; // Store the selected date and time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment:  Alignment.centerLeft, // Align "Add Flight" text to the left
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Add Flight",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Curved top shape SizedBox
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent, // Background color
                border: Border.all(color: Colors.deepPurple, width: 2.0), // Add a border
              ),
              child: SizedBox(
                height: 500, // Adjust the height as needed
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _flightnumber,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Flight Number is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.flight, color: Colors.white,),
                            labelText: "Flight No.",
                            labelStyle: TextStyle(
                              color: Colors.white, // Set the text color to white
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when focused
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when enabled
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _source,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Source Place is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.flight_takeoff, color: Colors.white,),
                            labelText: "From",
                            labelStyle: TextStyle(
                              color: Colors.white, // Set the text color to white
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when focused
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when enabled
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _destination,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Destination Place is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.flight_land, color: Colors.white,),
                            labelText: "To",
                            labelStyle: TextStyle(
                              color: Colors.white, // Set the text color to white
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when focused
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when enabled
                            ),
                          ),
                        ),
                      ),
                      
                      //Datetime fields to be continue
                      
                      // Add more TextFormField widgets as needed
                    ],
                  ),
                ),
              ),
            ),
          )
          // Add the rest of your content here
        ],
      ),
    );
  }
}