//import 'dart:collection';
//import 'package:excel/excel.dart';
//import 'dart:math';
import 'package:flutter/material.dart';
import '../../settings/anal_rectmoment_state.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'widget_rectmoment.dart';

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

  late ScrollController _scrollController;
  late TextEditingController inputNumberOne;
  late TextEditingController inputNumberTwo;
  late TextEditingController inputNumberThree;

  double? one;
  double? two;
  double? three;

  double? sum;

  bool showResults = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    inputNumberOne = TextEditingController(text: widget.state.inputNumberOne);
    inputNumberTwo = TextEditingController(text: widget.state.inputNumberTwo);
    inputNumberThree = TextEditingController(text: widget.state.inputNumberThree);

    // listeners
    inputNumberOne.addListener(_updateState);
    inputNumberTwo.addListener(_updateState);
    inputNumberThree.addListener(_updateState);
  }

  @override
  void didUpdateWidget(AnalRectMomentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if we need to scroll to top
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

  void _updateState() {
    setState(() {
      widget.state.inputNumberOne = inputNumberOne.text;
      widget.state.inputNumberTwo = inputNumberTwo.text;
      widget.state.inputNumberThree = inputNumberThree.text;

      widget.onStateChanged(widget.state);

    });
  }

  void addNumbers() {
    one = double.tryParse(inputNumberOne.text);
    two = double.tryParse(inputNumberTwo.text);
    three = double.tryParse(inputNumberThree.text);

    // Check if all numbers are entered
    if (one == null || two == null || three == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all numbers before proceeding.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop execution if any number is missing
    }

    // Check if an operation is selected
    if (selectedOperation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an operation before proceeding.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop execution if no operation is selected
    }

    // Perform the calculation
    if (selectedOperation == 'Addition') {
      sum = one! + two! + three!;
    } else {
      sum = one! * two! * three!;
    }

    // Only show the result if all inputs are valid and an operation is selected
    setState(() {
      showResults = true;
    });
  }
 // addNumbers

  String? selectedOperation;
  final List<String> operations = [
    'Addition',
    'Multiplication',
  ];

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

                //Dito ko na ilagay mga widgets (imported from widget_rectmoment.dart)
                    children: [
                      RectMomentWidgets.row1(
                        context: context,
                        inputNumberOne: inputNumberOne,
                      ),
                      RectMomentWidgets.row2(
                        context: context,
                        inputNumberTwo: inputNumberTwo,
                      ),
                      RectMomentWidgets.row3(
                        context: context,
                        inputNumberThree: inputNumberThree,
                      ),
                      RectMomentWidgets.row4(
                        context: context,
                        selectedOperation: selectedOperation,
                        operations: operations,
                        onOperationChanged: (newValue) {
                          setState(() {
                            selectedOperation = newValue;
                          });
                        },
                      ),
                      RectMomentWidgets.submitButton(
                        addNumbers: addNumbers,
                        updateShowResults: (value) {
                          setState(() {
                            showResults = value;
                          });
                        },
                      ),
                      if (showResults)
                      Text(
                        '${selectedOperation == "Multiplication" ? "Product" : "Sum"} = $sum',
                        style: TextStyle(color: Colors.white),
                      ),
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
} // _AnalRectMomentPageState

