import 'package:flutter/material.dart';
import 'tab_home.dart'; // Import the TabbedHomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foundation Calculator', // Add a title for your app
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can customize your theme further
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: TabbedHomePage(), // Use TabbedHomePage as the home screen
    );
  }
}
