import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/combined_footing_state.dart';
import 'dart:math';
import 'dart:io';

class DesignPage extends StatefulWidget {
  final String title;
  final CombinedFootingState state;
  final Function(CombinedFootingState) onStateChanged;


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

  late ScrollController _scrollController;

  late TextEditingController inputLength_a;
  late TextEditingController inputLength_b;
  late TextEditingController inputLength_c;
  late TextEditingController inputLength_e;
  late TextEditingController inputLength_H;

  late TextEditingController inputDepth;

  late TextEditingController inputShear_f;
  late TextEditingController inputShear_g;
  late TextEditingController inputShear_h;
  late TextEditingController inputShear_i;

  late TextEditingController inputFactorShear;
  late TextEditingController inputFactorMoment;

  late TextEditingController inputOtherDia;

  late TextEditingController inputFc;
  late TextEditingController inputFy;
  
  // solvar (solution variables)

  double? length_a;
  double? length_b;
  double? length_c;
  double? length_e;
  double? length_H;

  double? shear_f;
  double? shear_g;
  double? shear_h;
  double? shear_i;

  double? factorShear;
  double? factorMoment;

  double? otherDia;

  double? fc;
  double? fy;

  // toggles
  bool showSolution = false;

  // string getters
  String? barDia;
  final List<String> diameters = [
    '10 mm',
    '12 mm',
    '16 mm',
    '16 mm',
    '20 mm',
    '25 mm',
    '28 mm',
    '32 mm',
    '36 mm',
    'Others',
  ];

  String? side;
  final List<String> sideOptions = [
    'Left side (within Column A)',
    'Right side (within Column B)',
  ];

  String get solutionButtonLabel {
    if (widget.state.showSolution) {
      return 'Hide solution';
    } else {
      return 'View solution';
    }
  }

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    // Initialize controllers with saved state
    inputLength_a = TextEditingController(text: widget.state.inputLength_a);
    inputLength_b = TextEditingController(text: widget.state.inputLength_b);
    inputLength_c = TextEditingController(text: widget.state.inputLength_c);
    inputLength_e = TextEditingController(text: widget.state.inputLength_e);
    inputLength_H = TextEditingController(text: widget.state.inputLength_H);

    inputDepth = TextEditingController(text: widget.state.inputDepth);

    inputShear_f = TextEditingController(text: widget.state.inputShear_f);
    inputShear_g = TextEditingController(text: widget.state.inputShear_g);
    inputShear_h = TextEditingController(text: widget.state.inputShear_h);
    inputShear_i = TextEditingController(text: widget.state.inputShear_i);

    inputFactorShear = TextEditingController(text: widget.state.inputFactorShear);
    inputFactorMoment = TextEditingController(text: widget.state.inputFactorMoment);

    inputOtherDia = TextEditingController(text: widget.state.inputOtherDia);

    inputFc = TextEditingController(text: widget.state.inputFc);
    inputFy = TextEditingController(text: widget.state.inputFy);

    // for dropdowns

    barDia = widget.state.barDia;
    side = widget.state.side;

    // listeners

    inputLength_a.addListener(_updateState);
    inputLength_b.addListener(_updateState);
    inputLength_c.addListener(_updateState);
    inputLength_e.addListener(_updateState);
    inputLength_H.addListener(_updateState);

    inputDepth.addListener(_updateState);

    inputShear_f.addListener(_updateState);
    inputShear_g.addListener(_updateState);
    inputShear_h.addListener(_updateState);
    inputShear_i.addListener(_updateState);

    inputFactorShear.addListener(_updateState);
    inputFactorMoment.addListener(_updateState);

    inputOtherDia.addListener(_updateState);

    inputFc.addListener(_updateState);
    inputFy.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      widget.state.inputLength_a = inputLength_a.text;
      widget.state.inputLength_b = inputLength_b.text;
      widget.state.inputLength_c = inputLength_c.text;
      widget.state.inputLength_e = inputLength_e.text;
      widget.state.inputLength_H = inputLength_H.text;

      widget.state.inputDepth = inputDepth.text;

      widget.state.inputShear_f = inputShear_f.text;
      widget.state.inputShear_g = inputShear_g.text;
      widget.state.inputShear_h = inputShear_h.text;
      widget.state.inputShear_i = inputShear_i.text;

      widget.state.inputFactorShear = inputFactorShear.text;
      widget.state.inputFactorMoment = inputFactorMoment.text;

      widget.state.inputOtherDia = inputOtherDia.text;

      widget.state.inputFc = inputOtherDia.text;
      widget.state.inputFy = inputOtherDia.text;

      //calculate();

      widget.onStateChanged(widget.state);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();

    inputLength_a.dispose();
    inputLength_b.dispose();
    inputLength_c.dispose();
    inputLength_e.dispose();
    inputLength_H.dispose();

    inputDepth.dispose();

    inputShear_f.dispose();
    inputShear_g.dispose();
    inputShear_h.dispose();
    inputShear_i.dispose();

    inputFactorShear.dispose();
    inputFactorMoment.dispose();

    inputOtherDia.dispose();

    inputFc.dispose();
    inputFy.dispose();
  }

  double roundUpToNearest25(double value) {
    return (value / 25).ceil() * 25;
  }

  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
  }

  double roundToOneDecimalPlace(double value) {
    return (value * 10).round() / 10;
  }

  void calculate() {

    length_a = double.tryParse(inputLength_a.text);
    length_b = double.tryParse(inputLength_b.text);
    length_c = double.tryParse(inputLength_c.text);
    length_e = double.tryParse(inputLength_e.text);
    length_H = double.tryParse(inputLength_H.text);

    shear_f = double.tryParse(inputShear_f.text);
    shear_g = double.tryParse(inputShear_g.text);
    shear_h = double.tryParse(inputShear_h.text);
    shear_i = double.tryParse(inputShear_i.text);

    factorShear = double.tryParse(inputFactorShear.text);
    factorMoment = double.tryParse(inputFactorMoment.text);

    otherDia = double.tryParse(inputOtherDia.text);

    fc = double.tryParse(inputFc.text);
    fy = double.tryParse(inputFy.text);

    // pang-test ko lang ng submit button ’to, palitan mo na lang
    if (length_a != null) {
      setState(() {
        widget.state.showResults = true;
      });
    } else {
      setState(() {
        widget.state.showResults = false;
      });
    }
    
    print('showResults = ${widget.state.showResults}');
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
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ensures it takes only necessary height
                    // row managerrrr
                    children: [
                      Container(
                        width: 350,
                        height: 350,
                        child: Image.asset('assets/images/combinedFooting.png'),
                      ),
                      entry_lengthA(),
                      entry_lengthB(),
                      entry_lengthC(),
                      entry_lengthE(),
                      entry_lengthH(),

                      entryDepth(),

                      headerShear(),
                      entry_shearF(),
                      entry_shearG(),
                      entry_shearH(),
                      entry_shearI(),

                      headerReduction(),
                      entryFactorShear(),
                      entryFactorMoment(),
                      SizedBox(height: 20),
                      dropdownBarDia(),
                      if (barDia == 'Others')
                        entryOtherDia(),
                      dropdownSide(),
                      entryFc(),
                      entryFy(),

                      SizedBox(height: 10),
                      buttonSubmit(),

                      if (widget.state.showResults)
                        SizedBox(height: 10),
                      if (widget.state.showResults)
                        result(),

                      if (widget.state.showResults)
                        SizedBox(height: 10),
                      if (widget.state.showResults)
                        buttonSolution(),
                                             
                      if (widget.state.showSolution)
                        SizedBox(height: 10),
                      if (widget.state.showSolution)
                        containerSolution(),
                      
                      SizedBox(height: 10),
                      buttonClear(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget entry_lengthA() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "a (in m):",
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
                    controller: inputLength_a,
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
                          inputLength_a.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_lengthA
  Widget entry_lengthB() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "b (in m):",
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
                    controller: inputLength_b,
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
                          inputLength_b.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_lengthB
  Widget entry_lengthC() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "c (in m):",
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
                    controller: inputLength_c,
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
                          inputLength_c.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_lengthC
  Widget entry_lengthE() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "e (in m):",
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
                    controller: inputLength_e,
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
                          inputLength_e.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_lengthE
  Widget entry_lengthH() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "H (in m):",
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
                    controller: inputLength_H,
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
                          inputLength_H.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_lengthH
  
  Widget entryDepth() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "Depth (in mm):",
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
                    controller: inputDepth,
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
                          inputDepth.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entryDepth

  Widget headerShear() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Shear due to factored loads',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerShear
  Widget entry_shearF() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "f (in kN):",
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
                    controller: inputShear_f,
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
                          inputShear_f.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_shearF
  Widget entry_shearG() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "g (in kN):",
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
                    controller: inputShear_g,
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
                          inputShear_g.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_shearG
  Widget entry_shearH() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "h (in kN):",
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
                    controller: inputShear_h,
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
                          inputShear_h.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_shearH
  Widget entry_shearI() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "i (in kN):",
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
                    controller: inputShear_i,
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
                          inputShear_i.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entry_shearF

  Widget headerReduction() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Reduction factors',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerReduction
  Widget entryFactorShear() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "Shear reduction factor:",
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
                    controller: inputFactorShear,
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
                          inputFactorShear.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entryFactorShear
  Widget entryFactorMoment() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "Moment reduction factor:",
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
                    controller: inputFactorMoment,
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
                          inputFactorMoment.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entryFactorMoment

  Widget dropdownBarDia() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
          children: [
            Expanded(
              child: Text(
                'Desired bar diameter:',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              height: 40,
              width: 179,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                isExpanded: true,
                value: barDia,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    barDia = newValue;
                    });
                  },
                items: diameters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  } // dropdownBarDia
  Widget entryOtherDia() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "Please specify:",
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
                    controller: inputOtherDia,
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
                          inputOtherDia.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entryOtherDia

  Widget dropdownSide() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
          children: [
            Expanded(
              child: Text(
                'Side in which the number of bars is computed:',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              height: 40,
              width: 179,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                isExpanded: true,
                value: side,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    side = newValue;
                    });
                  },
                items: sideOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  } // dropdownSide
  Widget entryFc() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "Compressive strength of concrete, fc' (in MPa):",
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
                    controller: inputFc,
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
                          inputFc.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entryFc
  Widget entryFy() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
                  "Yield strength of steel, fy (in MPa):",
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
                    controller: inputFy,
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
                          inputFy.clear();
                        },
                      ),
                    ),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  } // entryFy

  Widget buttonSubmit() {
    return ElevatedButton(
      onPressed: () {
        calculate();
        if (!widget.state.showResults) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please provide input for all parameters."),
              backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Calculate'),
    );
  }

  Widget result() {
    return Visibility(
      visible: widget.state.showResults,
      child: Flexible(
        child: Container(
          width: 445,
          child: Column(
            children: [
              Text(
                "Vp = ?? kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vw = ?? kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "n =",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleSolution() {
    if (widget.state.solutionToggle) {
      widget.state.showSolution = true;
    } else {
      widget.state.showSolution = false;
    }
    setState(() {
      widget.state.solutionToggle = !widget.state.solutionToggle; // Toggle between functions
    });
  }
  Widget buttonSolution() {
    return ElevatedButton(
      onPressed: toggleSolution,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(solutionButtonLabel),
    );
  }
  Widget containerSolution() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF1F538D),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [ // kulang pa ’to
              Text(
                'Punching shear stress, Vp at A = ',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Punching shear stress, Vp at B = ',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Critical shear stress, Vp = ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Wide-beam shear stress, Vw at A =',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Wide-beam shear stress, Vw at B =',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Critical wide-beam shear stress, Vw =",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonClear() {
    return ElevatedButton(
      onPressed: () {        
        barDia = null;
        side = null;

        setState(() {
          widget.state.showResults = false;

          showSolution = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text("Clear all values"),
    );
  }

// for FAB to scroll to top
  @override
  void didUpdateWidget(DesignPage oldWidget) {
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
} // Design Page
