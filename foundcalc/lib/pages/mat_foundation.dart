import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/mat_foundation_state.dart';
import 'dart:math';

class MatFoundationPage extends StatefulWidget {
  final String title;
  final MatFoundationState state;
  final Function(MatFoundationState) onStateChanged;

  MatFoundationPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _MatFoundationState createState() => _MatFoundationState();
}

class _MatFoundationState extends State<MatFoundationPage> 
with AutomaticKeepAliveClientMixin<MatFoundationPage>{

  String get displayTitle {
    if (widget.title.startsWith('Mat')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Mat Foundation $index";
    }

    return widget.title; 
  }

  // scroll bar
  late ScrollController _scrollController;
  // inputs

  // late TextEditingController inputEte;

  // string getters

  /*
  String? calculation;
  final List<String> calcOptions = [
    'Factor of safety',
    'Net ultimate bearing capacity',
  ];
  */

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    // for input
    
    // inputEte = TextEditingController(text: widget.state.inputEte);

    // for dropdowns

    // loadingCase = widget.state.loadingCase;

    // calculation = "Factor of safety"; // Set default value here
    // widget.state.calculation = calculation;

    // listeners

    // inputEte.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      // widget.state.inputEte = inputEte.text;
      
      //calcQ();

      widget.onStateChanged(widget.state);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }


  @override
  bool get wantKeepAlive => true;

  @override
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
                      headerCalc(),
                      rowWithContainers(),
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
  Widget headerCalc() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        'Value to calculate:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget rowWithContainers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio<bool>(
                value: true,
                groupValue: widget.state.toggleCalc,
                onChanged: (bool? newValue) {
                  setState(() {
                    widget.state.toggleCalc = newValue ?? false;
                    widget.onStateChanged(widget.state);
                  });
                },
                activeColor: Color(0xFF1F538D),
              ),
              const Flexible(
                child: Text(
                  'Factor of safety',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 150,
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio<bool>(
                value: false,
                groupValue: widget.state.toggleCalc,
                onChanged: (bool? newValue) {
                  setState(() {
                    widget.state.toggleCalc = newValue ?? false;
                    widget.onStateChanged(widget.state);
                  });
                },
                activeColor: Color(0xFF1F538D),
              ),
              const Flexible(
                child: Text(
                  'Net ultimate bearing capacity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}