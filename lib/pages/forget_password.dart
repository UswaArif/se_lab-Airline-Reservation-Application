import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  @override
  State<ForgetPassword> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPassword> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false; // Define and initialize isLoading as false
  String errorMessage = ""; // Initialize an empty error message string.


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;    //Responsive
    return Scaffold(
      body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            Image(image: AssetImage('assets/images/forgetPassword.png'),height: size.height*0.2,),
            Text("Forget Password", style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.deepPurple),),
            Text("Enter Email to Reset your password", style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.deepPurpleAccent),),

            const SizedBox(height: 20.0,),
            Form(child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    hintText: "Enter your Email",
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0,),
                SizedBox(width: double.infinity,
                height: 40,
                child: ElevatedButton(onPressed: (){
                  auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                    print("We have sent you an email to recover password, please check email.");
                  }).onError((error, stackTrace){
                      print("Error sending password reset email.");
                  });
                }, child: const Text("Next"),),
                ),
                
              ],
            ),
            ),
          ],
          ),
      ),
      )
    );
  }
}

  
