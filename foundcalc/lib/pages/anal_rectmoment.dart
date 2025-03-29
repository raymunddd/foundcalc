//import 'dart:collection';
//import 'package:excel/excel.dart';
//import 'dart:math';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import '../settings/anal_rectmoment_state.dart';
=======
import '../../settings/anal_rectmoment_state.dart';
>>>>>>> Stashed changes


class AnalRectMomentPage extends StatefulWidget {
  final String title;
  final AnalRectMomentState state;
  final Function(AnalRectMomentState) onStateChanged;

  AnalRectMomentPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _AnalRectMomentPageState createState() => _AnalRectMomentPageState();
}

class _AnalRectMomentPageState extends State<AnalRectMomentPage> 
with AutomaticKeepAliveClientMixin<AnalRectMomentPage> {
  // You can add state variables and methods here

@override
  bool get wantKeepAlive => true; // 2. Override wantKeepAlive and return true

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build
    return Scaffold(
      backgroundColor: Color(0xFF363434),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Color(0xFF363434),
      ),
      body: Center(
        child: Text(
          'Details for ${widget.title}',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

