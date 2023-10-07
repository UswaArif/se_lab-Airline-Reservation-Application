import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/pages/home_page.dart';
import 'package:se_lab/pages/llogin_page.dart';


//import 'home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            //Show a loading indicator while checking the authentication state
            return const CircularProgressIndicator();
          }
          else{
            if(snapshot.hasData){
              //User is logged in, navigate tothe home page
              return HomePage();
            }
            else{
              //User is not logged in, navigate to the login page
              return const LoginPage();
            }
          }          
        },
      ),
    );
  }
}