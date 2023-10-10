import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/classes/user_model.dart';
import 'package:se_lab/pages/customer_home_page.dart';
import 'package:se_lab/pages/forget_password.dart';
import 'package:se_lab/pages/home_page.dart';
import 'package:se_lab/pages/sign_up_page.dart';
import 'package:se_lab/repository/user_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false; // Define and initialize isLoading as false
  bool _passwordVisible = false; // Initially, the password is hidden
  // Store the ScaffoldMessengerState
  late ScaffoldMessengerState _scaffoldMessengerState;
  String? role;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the ScaffoldMessengerState
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,     
        
      );
      print("Valid");

     // Check if the userCredential.user is not null before accessing it
    if (userCredential.user != null) {
      User user = userCredential.user!;

      // Get the authenticated user's email
      String? authUserEmail = user.email;

      // Query Firestore to find a document with the matching email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("Email", isEqualTo: authUserEmail)
          .get();

      // Check if there is a matching document
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming there's only one match)
        DocumentSnapshot userDataSnapshot = querySnapshot.docs.first;

        // Access user data from Firestore
        Map<String, dynamic> userData = userDataSnapshot.data() as Map<String, dynamic>;

        // Now you can access user data like this:
        String username = userData['FullName'];
        String email = userData['Email'];
        String userRole = userData['Role'];
        role = userRole;
        // ... (access other fields as needed)

        print("Full Name: $username");
        print("Email: $email");
        print("ROle: $userRole ");
      } else {
        // No matching document found in Firestore
        print("User data not found in Firestore for email: $authUserEmail");
      }
    } else {
      // Handle the case where userCredential.user is null
      print("User authentication failed");
    }

    
  
      
      // If signInWithEmailAndPassword is successful, the user is signed in.
      // You can navigate to the next screen or perform other actions here.
  } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication exceptions
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        _scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content: Text("Invalid email or password."),
          ),
        );
      } else {
        // Handle other Firebase Authentication exceptions
        print("Firebase Authentication Exception: ${e.code}");
      }
    } catch (e) {
      // Handle other exceptions (not FirebaseAuthException)
      print("An unexpected error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;    //Responsive
    return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign In"),
        /*actions: [
          IconButton(
            onPressed: ()async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.login),
            ),
        ],*/
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/signin.png'),height: size.height*0.05,),
              Text("My AirLine", style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.deepPurple),),
              Text("Welcome Back", style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.deepPurpleAccent),),
              Form(
                key: _formKey,
              child: OverflowBar(
                overflowSpacing: 20,
                children: [
                  TextFormField(
                    controller: _email,
                    validator: (text){
                      if(text == null || text.isEmpty){
                        return 'Email is empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline_outlined),
                    labelText: "Email",
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _password,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Password is empty';
                      }
                      return null;
                    },
                    obscureText: !_passwordVisible, // Set obscureText based on _passwordVisible
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.fingerprint),
                      labelText: "Password",
                      hintText: "Enter your Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible; // Toggle _passwordVisible
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  TextButton(onPressed: (){
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgetPassword()), // Replace with the actual name of your sign-up page class
                        );*/
                        showModalBottomSheet(context: context, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Make Selection!",style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black),),
                              Text("Select the option below to reset your password.",style: Theme.of(context).textTheme.bodyText2,),
                              const SizedBox(height: 25.0,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ForgetPassword()), // Replace with the actual name of your sign-up page class
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.mail_outline_rounded,size: 40.0,),
                                      const SizedBox(width: 10.0,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("E-Mail",style: Theme.of(context).textTheme.bodyText1,),
                                          Text("Reset via E-Mail Verification.",style: Theme.of(context).textTheme.bodyText2,),
                                        ],
                                      ),
                                    ],                          
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ), 
                        );
                    }, 
                    child: const Text("Forget Password?", style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                  ),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: ()async{
                        if (_formKey.currentState!.validate()){
                          signInWithEmailAndPassword(); 
                          if(role == "admin")
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            ); 
                          }
                          else if(role == "customer")
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CustomerHomePage()),
                            ); 
                          }
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()), // Replace with the actual name of your login page class
                          );                           
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Adjust the value for the desired curve
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                     
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()), // Replace with the actual name of your sign-up page class
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an Account? ",
                              style: TextStyle(
                                color: Colors.black, // Set the color of the first part of the text
                              ),
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Colors.deepPurple, // Set the color of the "Sign Up" portion
                                decoration: TextDecoration.underline, // Underline the "Sign Up" text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
                
              ),
              ),
            ],
        ),
        ),
      ),
    ),
    );
  }
}
