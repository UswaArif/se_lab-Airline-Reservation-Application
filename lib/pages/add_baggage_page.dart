import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_lab/classes/baggage_model.dart';
import 'package:se_lab/repository/baggage_repository.dart';

class AddBaggage extends StatefulWidget {
  const AddBaggage({super.key});

  @override
  State<AddBaggage> createState() => _AddBaggageState();
}

class _AddBaggageState extends State<AddBaggage> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _bagcounts = TextEditingController();
  final TextEditingController _sizerestriction = TextEditingController();
  final TextEditingController _excessbaggagefee = TextEditingController();
  String? selectedSeatType; 
  bool isLoading = false;
  List<Map<String, dynamic>> BaggageDataList = [];
  bool isMatchFound = false;

  @override
  void initState() {
    super.initState();
    // Call the function to get flight data from Firebase when the widget is initialized
    getBaggagedata();
  }

  Future<void> getBaggagedata() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Baggage")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve and store flight data in the list
        BaggageDataList = querySnapshot.docs.map((baggageSnapshot) {
        final data = baggageSnapshot.data() as Map<String, dynamic>;
        final documentId = baggageSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();      
        setState(() {});
      } else {
        print("No baggage data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
    }
  }

  addBaggage() {
    try {
      setState(() {
        isLoading = true;
      });

      // Add Baggage object using your class
      final baggage = BaggageModel(
        seat_type_class: selectedSeatType ?? "Economy",
        weight_per_kg: int.parse(_weight.text),
        bag_counts: int.parse(_bagcounts.text),
        size_restriction: _sizerestriction.text,
        excess_baggage_fee_per_kg: int.parse(_excessbaggagefee.text),
        created_at: Timestamp.now(),
        updated_at: Timestamp.now(),
        active: true,
      );

      

      // Call the createFlight method from FightRepository to store flight data
      final baggageRepository = BaggageRepository();
      baggageRepository.createBaggage(context, baggage);
      print("Baggage added Successfully.");

      setState(() {
        isLoading = false;
      });  
    } 
    catch (e) {
      setState(() {
        isLoading = false;
        print("Not done");
      });
      print("here is error");
      print(e);
    }
  }

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
                "Add Baggage",
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
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      //Seat Type Class
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.airline_seat_recline_normal_outlined, color: Colors.white),
                                labelText: 'Seat Type',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              value: selectedSeatType,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSeatType = newValue!;
                                  //print(selectedSeatType);
                                });
                              },
                              items: <String>['Economy', 'Business Class', 'First Class']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a seat type';
                                }
                                return null;
                              },
                            ),                
                          ],
                        ),
                      ),
                      //Baggage weight
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _weight,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                          ],
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Baggage weight is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.monitor_weight, color: Colors.white,),
                            labelText: "Baggage Weight in Kgs",
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
                      //Bag Counts
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _bagcounts,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                          ],
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Bags count is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.numbers, color: Colors.white,),
                            labelText: "Number of Bag counts",
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
                      //Size Restrictions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _sizerestriction,                          
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Size Restrictions is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.width_normal, color: Colors.white,),
                            labelText: "Size Restrictions in lengthxwidthxheight cm",
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
                      //Excess Baggage fee
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _excessbaggagefee,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                          ],
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Excess Baggage Fee is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.money_off, color: Colors.white,),
                            labelText: "Excess Baggage Fee in Kgs",
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
                      const SizedBox(height: 12),
                      //Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                             
                            onPressed: () {
                              if (_formKey2.currentState!.validate()) {
                                //addFlight();  
                                for (Map<String, dynamic> baggageData in BaggageDataList) {     
                                  if (baggageData['SeatTypeClass'] == selectedSeatType) {
                                    isMatchFound = true;
                                    break;
                                  }
                                  else{
                                    isMatchFound = false;
                                  }
                                }  
                                if(isMatchFound)
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text('The Seat Type already exist in Baggage Data. You can only update this Seat Type Data.'),
                                      );
                                    },
                                  );
                                } 
                                else
                                {                                 
                                  addBaggage();
                                }                              
                              } 
                            },
                            
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                            )
                            : const Text('Add Baggage'),
                          ),
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}