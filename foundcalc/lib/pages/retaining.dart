import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/retaining_state.dart';
import 'dart:math';

class RetainingPage extends StatefulWidget {
  final String title;
  final RetainingState state;
  final Function(RetainingState) onStateChanged;

  RetainingPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _RetainingState createState() => _RetainingState();
}

class _RetainingState extends State<RetainingPage> 
with AutomaticKeepAliveClientMixin<RetainingPage>{

  // scrollbar
  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  // string getters
  String get displayTitle {
    if (widget.title.startsWith('Retaining')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Retaining Wall $index";
    }

    return widget.title; 

  }

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    // for input
    
    // inputPdim = TextEditingController(text: widget.state.inputPdim);

    // for dropdowns
    
    /*
    xsection = widget.state.xsection;
    
    calculation = "Factor of safety"; // Set default value here
    widget.state.calculation = calculation;
    */

    // listeners

    // inputPdim.addListener(_updateState);

  }

  void _updateState() {
    setState(() {
      // widget.state.inputPdim = inputPdim.text;
      
      // solve();

      widget.onStateChanged(widget.state);
    });
  }
  void dispose() {
    _scrollController.dispose();

    // inputPdim.dispose();
    
    super.dispose();
  }

  Widget build(BuildContext context) {   
    super.build(context); // Call super.build   
    return Scaffold(
      backgroundColor: Color(0xFF363434),
      appBar: AppBar(
        title: Text(
          displayTitle,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF363434),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child:  ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.grey[800]), // Set the thumb color to white
            trackColor: WidgetStateProperty.all(Colors.grey[800]), // Optional: Set the track color
          ),
        child: Scrollbar(
          controller: _scrollController,
          thickness: 4,
          radius: Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ensures it takes only necessary height
                    // row managerrrr
                    children: [
                      /*
                      SizedBox(height: 10),
                      buttonSubmit(),

                      if (widget.state.showResults)
                        SizedBox(height: 10),
                      if (widget.state.showResults)
                        resultText(),

                      if (widget.state.showResults)
                        SizedBox(height: 10),
                      if (widget.state.showResults)
                        solutionButton(),

                      if (widget.state.showSolution)
                        SizedBox(height: 10),
                      if (widget.state.showSolution)
                        containerSolution(),
                      
                      SizedBox(height: 10),
                      clearButton(),
                      */        
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  } // build (main widget)

  // for FAB to scroll to top
  @override
  void didUpdateWidget(RetainingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state.scrollToTop) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });

      // Reset the flag
      widget.state.scrollToTop = false;
      widget.onStateChanged(widget.state);
    }
  }


}