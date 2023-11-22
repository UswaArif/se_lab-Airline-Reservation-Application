import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/pages/rules_baggage_page.dart';
import 'package:se_lab/pages/update_baggage_page.dart';

class ViewBaggage extends StatefulWidget {
  const ViewBaggage({super.key});

  @override
  State<ViewBaggage> createState() => _ViewBaggageState();
}

class _ViewBaggageState extends State<ViewBaggage> {
  List<Map<String, dynamic>> BaggageDataList = [];

  @override
  void initState() {
    super.initState();
    getBaggageData();
  }
  
  Future<void> getBaggageData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Baggage")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        BaggageDataList = querySnapshot.docs.map((baggageSnapshot) {
        final data = baggageSnapshot.data() as Map<String, dynamic>;
        final documentId = baggageSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();

        setState(() {});
      } else {
        print("No Baggage data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("View Baggage"),
      ),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0), 
                  child: Text(
                    "View Baggage",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0), // Margin from the right side
                  child: Column(
                    children: [                     
                      Material(
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RulesBaggage()), 
                            );

                          },
                          child: const SizedBox(
                            width: 100, 
                            height: 43, 
                            child: Center(
                              child: Text(
                                "Rules and Regulations",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                child: ListView.builder(
                  itemCount: BaggageDataList.length,
                  itemBuilder: (context, index) {
                    final baggageData = BaggageDataList[index];
                    return GestureDetector(                      
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color:Colors.white,                            
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Text("Baggage Details For Seat",                                  
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text("${baggageData['SeatTypeClass']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, // You can apply any styling you want
                                  ),
                                ),
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Baggage Weight",  
                                    style: TextStyle(
                                      fontSize: 10, 
                                    ),                        
                                  ),
                                  Icon(
                                    Icons.airline_seat_recline_normal_sharp, 
                                    size: 25, 
                                    color: Colors.red,
                                  ),
                                  Text("Bag Counts",
                                    style: TextStyle(
                                      fontSize: 10, 
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${baggageData['WeightperKg']} Kg",  
                                    style: const TextStyle(
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold,
                                    ),                        
                                  ),                                 
                                  Text("${baggageData['BagCounts']}",
                                    style: const TextStyle(
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Size Restrictions: ${baggageData['SizeRestriction']}",  
                                    style: const TextStyle(
                                      fontSize: 12,                                      
                                    ),
                                  ), 
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [                                
                                  Text("Excess Baggage Fee: Rs.${baggageData['ExcessBaggageFeePerKg']}",
                                    style: const TextStyle(
                                      fontSize: 12,                                      
                                    ),
                                  ),
                                  IconButton(onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateBaggage(
                                          updatebaggageData: baggageData,
                                        ),
                                      ),
                                    );
                                    //print(baggageData);
                                  }, 
                                  icon: const Icon(Icons.update)),
                                ],
                              ),
                            ],
                          ),
                        ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}