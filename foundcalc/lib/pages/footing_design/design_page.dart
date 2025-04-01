import 'package:flutter/material.dart';
import 'design_state.dart';

class DesignPage extends StatefulWidget {
  final String title;
  final DesignState state;
  final Function(DesignState) onStateChanged;


  DesignPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });


  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> 
with AutomaticKeepAliveClientMixin<DesignPage> {
  // You can add state variables and methods here

@override
  bool get wantKeepAlive => true; // 2. Override wantKeepAlive and return true
  String get displayTitle {
  if (widget.title.startsWith('Design')) {
        int index = int.tryParse(widget.title.split(' ').last) ?? 0;
        return "Design of Footings $index"; // Shorter for tab
      }

      return widget.title; 
    }


  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build
    return Scaffold(
      backgroundColor: Color(0xFF363434),
      appBar: AppBar(
        title: Text(
          displayTitle,
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Color(0xFF363434),   
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Coming soon!',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

