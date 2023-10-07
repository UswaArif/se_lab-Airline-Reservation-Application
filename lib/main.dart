import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:se_lab/pages/llogin_page.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Create a custom MaterialColor for deepPurple
  static const MaterialColor customDeepPurple = MaterialColor(
    0xFF311B92, // Primary color value
    <int, Color>{
      50: Color(0xFFEDE7F6),
      100: Color(0xFFD1C4E9),
      200: Color(0xFFB39DDB),
      300: Color(0xFF9575CD),
      400: Color(0xFF7E57C2),
      500: Color(0xFF673AB7), // Primary color
      600: Color(0xFF5E35B1),
      700: Color(0xFF512DA8),
      800: Color(0xFF4527A0),
      900: Color(0xFF311B92),
    },
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aeroplane System',
      theme: ThemeData(),
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: customDeepPurple),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      //const AuthPage(),
    );
  }
}

