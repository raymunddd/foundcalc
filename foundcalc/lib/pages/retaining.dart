import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
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

  late TextEditingController inputCohesion;
  late TextEditingController inputLayerLength;
  late TextEditingController inputN;
  late TextEditingController inputOCR;

  double? cohesion;
  double? layerLength;
  double? n;
  double? OCR;

  double? answer;

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
  String? consolidation;
  final List<String> consValues = [
    'Normally consolidated',
    'Over consolidated',
  ];
  

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    // for input

    inputCohesion = TextEditingController(text: widget.state.inputCohesion);
    inputLayerLength = TextEditingController(text: widget.state.inputLayerLength);
    inputOCR = TextEditingController(text: widget.state.inputOCR);
    inputN = TextEditingController(text: widget.state.inputN);

    // for dropdowns
    
    /*
    xsection = widget.state.xsection;
    
    calculation = "Factor of safety"; // Set default value here
    widget.state.calculation = calculation;
    */

    // listeners

    inputCohesion.addListener(_updateState);
    inputLayerLength.addListener(_updateState);
    inputOCR.addListener(_updateState);
    inputN.addListener(_updateState);

    }

  void _updateState() {
    setState(() {
      // solve();

      widget.onStateChanged(widget.state);
    });
  }
  void dispose() {
    _scrollController.dispose();

    inputCohesion.dispose();
    inputLayerLength.dispose();
    inputOCR.dispose();
    inputN.dispose();
    
    super.dispose();
  }
  void solve() {
    double total = 0.0;



    print("Total: $answer"); // or display it using a Text widget
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      entryNumberOfLayers(),
                      SizedBox(height: 10),
                      submitButton(),
                      testWidget(),
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
  InputDecoration inputDecoration(VoidCallback onClear) {
    return InputDecoration(
      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      filled: true,
      fillColor: Colors.grey[800],
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.white),
      ),
      suffixIcon: IconButton(
        icon: Icon(Icons.clear, color: Colors.white54),
        iconSize: 17,
        onPressed: onClear,
      ),
    );
  }
  Widget entryNumberOfLayers() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
          children: [
            Flexible(
              child: Container(
                width: 150,
                child: Text(
                  'Number of soil layers:',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ),
            Container(
              width: 179,
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.white,
                ),
                child: SizedBox(
                  height: 40, // Adjust height as needed
                  child: TextField(
                    controller: inputN, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Input required",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear, 
                          color: Colors.white54,
                        ),
                        iconSize: 17,
                        onPressed: () {
                          // Clear the text field
                          inputN.clear();
                        },
                      ),
                    ),
                  )
                )
              ),
            ),
          ],
        ),
      ),        
    );
  } // entryNumberOfLayers

  Widget testWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            Text(
              'Layer 1:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
              children: [
                Flexible(
                  child: Container(
                    width: 150,
                    alignment: Alignment.center,
                    child: Text(
                      'Consolidation of soil:',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
                Flexible(
                  child: Container(
                    width: 150,
                    alignment: Alignment.center,
                    child: Text(
                      'Cohesion, C:',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
                Flexible(
                  child: Container(
                    width: 150,
                    alignment: Alignment.center,
                    child: Text(
                      'Length of layer, L:',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
              children: [
                Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey[800],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: consolidation,
                    hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                    dropdownColor: Colors.grey[800],
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.white),
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        consolidation = newValue;
                        });
                      },
                    items: consValues.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 150,
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Colors.white,
                    ),
                    child: SizedBox(
                      height: 40, // Adjust height as needed
                      child: TextField(
                        controller: inputCohesion, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                        ],
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Input required",
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear, 
                              color: Colors.white54,
                            ),
                            iconSize: 17,
                            onPressed: () {
                              // Clear the text field
                              inputCohesion.clear();
                            },
                          ),
                        ),
                      )
                    )
                  ),
                ),
                Container(
                  width: 150,
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Colors.white,
                    ),
                    child: SizedBox(
                      height: 40, // Adjust height as needed
                      child: TextField(
                        controller: inputLayerLength, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                        ],
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Input required",
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear, 
                              color: Colors.white54,
                            ),
                            iconSize: 17,
                            onPressed: () {
                              // Clear the text field
                              inputLayerLength.clear();
                            },
                          ),
                        ),
                      )
                    )
                  ),
                ),
              ],
            ),
            if (consolidation == 'Over consolidated')
              SizedBox(height: 10),
            if (consolidation == 'Over consolidated')
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centers row children horizontally
                children: [
                  Flexible(
                    child: Container(
                      width: 150,
                      alignment: Alignment.center,
                      child: Text(
                        'Over consolidation ratio, OCR:',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                  Container(
                    width: 150,
                    child: TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: Colors.white,
                      ),
                      child: SizedBox(
                        height: 40, // Adjust height as needed
                        child: TextField(
                          controller: inputOCR, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
                          keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                          ],
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Input required",
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear, 
                                color: Colors.white54,
                              ),
                              iconSize: 17,
                              onPressed: () {
                                // Clear the text field
                                inputOCR.clear();
                              },
                            ),
                          ),
                        )
                      )
                    ),
                  ),
                ],
              ),     
          ],
        )
      ),        
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        solve();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1F538D),
          foregroundColor: Colors.white,
        ),
      child: Text('Calculate'),
    );
  }
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