//import 'dart:collection';
//import 'package:excel/excel.dart';
//import 'dart:math';
import 'package:flutter/material.dart';
import '../settings/anal_rectmoment_state.dart';
import 'package:flutter/services.dart';
import 'dart:math';


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

//ITO ANG SALARIN ng title
  String get displayTitle {
if (widget.title.startsWith('RectMoment')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Analysis of Rectangular Footing with Moment $index"; // Shorter for tab
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
  
} // _AnalRectMomentPageState

