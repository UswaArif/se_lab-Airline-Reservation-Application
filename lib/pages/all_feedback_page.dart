import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/repository/logtable_repository.dart';

class AllFeedback extends StatefulWidget {
  const AllFeedback({super.key});

  @override
  State<AllFeedback> createState() => _AllFeedbackState();
}

class _AllFeedbackState extends State<AllFeedback> {
  List<Map<String, dynamic>> FeedbackDataList = [];
  @override
  void initState() {
    super.initState();
    getFeedbackData();
  }
  
  Future<void> getFeedbackData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Feedback")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        FeedbackDataList = querySnapshot.docs.map((feedbackSnapshot) {
        final data = feedbackSnapshot.data() as Map<String, dynamic>;
        final documentId = feedbackSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();

        setState(() {});
      } else {
        print("No Feedback data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
      //Log Tables
      final log = LogTable(
        page_name: "all_feedback_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("View Feedbacks"),
      ),
      body: ListView(
        children: [
          Container(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: FeedbackDataList.length,
                  itemBuilder: (context, index) {
                    final feedbackData = FeedbackDataList[index];
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color:Colors.white,                            
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Customer Id: ${feedbackData['UserId']}",  
                                  style: const TextStyle(
                                    fontSize: 12, 
                                  ),                        
                                ),
                                const SizedBox(height: 10,),
                                Text("Feedback Message: ${feedbackData['Text']}",
                                  style: const TextStyle(
                                    fontSize: 12, 
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            const Divider(
                              color: Colors.grey, // You can set the color of the line
                              thickness: 2.0, // You can set the thickness of the line
                            ),
                          ],
                        ),

                      ),
                    );
                  },
                ),
            ),
          ),
        ],
      ),
    );
  }
}