import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      appBar: AppBar(
        title: Text("About",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "About the Foundation Engineering Calculator",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "This app was developed by...", // Replace with your info
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}