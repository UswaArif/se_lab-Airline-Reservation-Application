import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/classes/user_model.dart';
import 'package:se_lab/pages/llogin_page.dart';
import 'package:se_lab/repository/user_repository.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  final String _role = "customer";

  DateTime _updated_at = DateTime.now(); // Initialize with the current time.

  // When something changes, update _updated_at.
  void updateSomething() {
    // Perform the update operation here.

    // Update _updated_at with the current time.
    _updated_at = DateTime.now();
  }


  // Get an instance of your UserRepository
  final UserRepository userRepository = UserRepository();


  createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Create user in Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      // Create a User object using your class
      final user = UserModel(
        id: userCredential.user!.uid, // Use the UID from Firebase Authentication
        fullName: _name.text,
        phone: int.parse(_phone.text),
        address: _address.text,
        email: _email.text,
        password: _password.text,
        role: _role,
        created_at: DateTime.now().toString(),
        updated_at: _updated_at.toString(),
        active: true,
      );
      // Call the createUser method from UserRepository to store user data
      userRepository.createUser(context, user);

      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      print("Done");
    } catch (e) {
      setState(() {
        isLoading = false;
        print("Not done");
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: OverflowBar(
              overflowSpacing: 20,
              children: [
                TextFormField(
                  controller: _name,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Name is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                TextFormField(
                  controller: _phone,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Phone Number is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Phone Number"),
                ),
                TextFormField(
                  controller: _address,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Address is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Address"),
                ),
                TextFormField(
                  controller: _email,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: _password,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        createUserWithEmailAndPassword();
                      }
                    },
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Sign Up"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with the actual name of your login page class
                      );
                    },
                    child: const Text("Login"),
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
