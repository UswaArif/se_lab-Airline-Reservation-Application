import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/classes/feedback_model.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/repository/feedback_repository.dart';
import 'package:se_lab/repository/logtable_repository.dart';

class FeedbackCustomer extends StatefulWidget {
  final Map<String, dynamic> user;
  const FeedbackCustomer({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  State<FeedbackCustomer> createState() => _FeedbackCustomerState();
}

class _FeedbackCustomerState extends State<FeedbackCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  bool isLoading = false;

  addFeedback() {
    try {
      setState(() {
        isLoading = true;
      });

      // Add Feedback object using your class
      final feedback = FeedbackModel(
        feedback_text: _feedbackController.text,
        user_id: widget.user['documentID'],
        created_at: Timestamp.now(),
      );

      final feedbackRepository = FeedbackRepository();
      feedbackRepository.createFeedback(context, feedback);

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

      //log table
      final log = LogTable(
        page_name: "feedback_page",
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
        title: const Text("Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _feedbackController,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your feedback';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your feedback here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addFeedback();
                  }
                },
                child: const Text('Send Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}