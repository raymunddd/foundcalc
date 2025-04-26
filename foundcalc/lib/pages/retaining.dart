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

  late TextEditingController inputIncline;
  late TextEditingController input_g;
  late TextEditingController input_yPassive;
  late TextEditingController inputBaseFriction;
  late TextEditingController inputPassiveSoilFrictionAngle;
  late TextEditingController inputPassiveEarthPressure;
  late TextEditingController inputPassiveCohesion;

  double? incline;
  double? g;

  double? answer;

  @override
  bool get wantKeepAlive => true;

  // string getters
  String get displayTitle {
    if (widget.title.startsWith('RetWall')) {
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

    inputIncline = TextEditingController(text: widget.state.inputIncline);
    input_g = TextEditingController(text: widget.state.input_g);
    input_yPassive = TextEditingController(text: widget.state.input_yPassive);
    inputBaseFriction = TextEditingController(text: widget.state.inputBaseFriction);
    inputPassiveSoilFrictionAngle = TextEditingController(text: widget.state.inputPassiveSoilFrictionAngle);
    inputPassiveEarthPressure = TextEditingController(text: widget.state.inputPassiveEarthPressure);
    inputPassiveCohesion = TextEditingController(text: widget.state.inputPassiveCohesion);

    // for dropdowns
    
    /*
    xsection = widget.state.xsection;
    
    calculation = "Factor of safety"; // Set default value here
    widget.state.calculation = calculation;
    */

    // listeners

    inputIncline.addListener(_updateState); 
    input_g.addListener(_updateState); 
    input_yPassive.addListener(_updateState); 
    inputBaseFriction.addListener(_updateState); 
    inputPassiveSoilFrictionAngle.addListener(_updateState); 
    inputPassiveEarthPressure.addListener(_updateState); 
    inputPassiveCohesion.addListener(_updateState); 

    }

  void _updateState() {
    setState(() {
      // solve();

      widget.state.inputIncline = inputIncline.text;
      widget.state.input_g = input_g.text;
      widget.state.input_yPassive = input_yPassive.text;
      widget.state.inputBaseFriction = inputBaseFriction.text;
      widget.state.inputPassiveSoilFrictionAngle = inputPassiveSoilFrictionAngle.text;
      widget.state.inputPassiveEarthPressure = inputPassiveEarthPressure.text;
      widget.state.inputPassiveCohesion = inputPassiveCohesion.text;

      widget.onStateChanged(widget.state);
    });
  }
  void dispose() {
    _scrollController.dispose();

    inputIncline.dispose();
    input_g.dispose();
    input_yPassive.dispose();
    inputBaseFriction.dispose();
    inputPassiveSoilFrictionAngle.dispose();
    inputPassiveEarthPressure.dispose();
    inputPassiveCohesion.dispose();

    super.dispose();
  }
  void solve() {

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
                      if (widget.state.resultantPa && !widget.state.passiveSoil && !widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel1-1.png'),
                        ),
                      if (!widget.state.resultantPa && !widget.state.passiveSoil && !widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel2-1.png'),
                        ),
                      if (widget.state.resultantPa && !widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel3-1.png'),
                        ),
                      if (!widget.state.resultantPa && !widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel4-1.png'),
                        ),
                      if (widget.state.resultantPa && widget.state.passiveSoil && !widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel5-1.png'),
                        ),
                      if (!widget.state.resultantPa && widget.state.passiveSoil && !widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel6-1.png'),
                        ),
                      if (widget.state.resultantPa && widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel7-1.png'),
                        ),
                      if (!widget.state.resultantPa && widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retModel8-1.png'),
                        ),

                      switchResultantPa(),
                      switchSlopedSoil(),
                      switchPassive(),

                      if (widget.state.resultantPa)
                        entryInclinePa(),
                      if (widget.state.slopedSoil)
                        entry_g(),
                      if (!widget.state.passiveSoil)
                        entryBaseFriction(),
                      if (widget.state.passiveSoil)
                        entryGammaPassive(),
                      if (widget.state.passiveSoil)
                        entryPassiveEarthPressure(),
                      if (widget.state.passiveSoil)
                        entryPassiveCohesion(),
                      if (widget.state.passiveSoil)
                        entryPassiveSoilFrictionAngle(),
                      
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
  Widget switchResultantPa() {
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
                  'Resultant Pₐ',
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
                  child: Switch(
                    value: widget.state.resultantPa,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.resultantPa = newValue;
                        widget.onStateChanged(widget.state);
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 10, 131, 14),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color.fromARGB(255, 201, 40, 29),
                  )
                )
              )
            ),
          ],
        ),
      ),
    );
  } // switchResultantPa
  Widget switchSlopedSoil() {
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
                  'Sloped active soil',
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
                  child: Switch(
                    value: widget.state.slopedSoil,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.slopedSoil = newValue;
                        widget.onStateChanged(widget.state);
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 10, 131, 14),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color.fromARGB(255, 201, 40, 29),
                  )
                )
              )
            ),
          ],
        ),
      ),
    );
  } // switchSlopedSoil
  Widget switchPassive() {
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
                  'Passive soil',
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
                  child: Switch(
                    value: widget.state.passiveSoil,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.passiveSoil = newValue;
                        widget.onStateChanged(widget.state);
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 10, 131, 14),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color.fromARGB(255, 201, 40, 29),
                  )
                )
              )
            ),
          ],
        ),
      ),
    );
  } // switchPassive
  
  // resultant on
  Widget entryInclinePa() {
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
                  'Angle of incline of Pₐ, θ (in degrees):',
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
                  height: 40,
                  child: TextField(
                    controller: inputIncline,
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
                          inputIncline.clear();
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
  } // entryInclinePa
  
  // sloped on
  Widget entry_g() {
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
                  'g (in m):',
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
                  height: 40,
                  child: TextField(
                    controller: input_g,
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
                          input_g.clear();
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
  } // entry_g
  
  // passive on
  Widget entryGammaPassive() {
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
                  'Unit weight of passive soil, γp (in kN/m³):',
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
                  height: 40,
                  child: TextField(
                    controller: input_yPassive,
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
                          input_yPassive.clear();
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
  } // entryGammaPassive
  Widget entryPassiveSoilFrictionAngle() {
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
                  'Passive soil friction angle, θ₂ (in degrees):',
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
                  height: 40,
                  child: TextField(
                    controller: inputPassiveSoilFrictionAngle,
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
                          inputPassiveSoilFrictionAngle.clear();
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
  } // entryPassiveSoilFrictionAngle
  Widget entryPassiveEarthPressure() {
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
                  'Passive earth pressure coefficient, k₂ (in degrees):',
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
                  height: 40,
                  child: TextField(
                    controller: inputPassiveEarthPressure,
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
                          inputPassiveEarthPressure.clear();
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
  } // entryPassiveEarthPressure
  Widget entryPassiveCohesion() {
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
                  'Passive soil cohesion, c₂ (in kPa):',
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
                  height: 40,
                  child: TextField(
                    controller: inputPassiveCohesion,
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
                          inputPassiveCohesion.clear();
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
  } // entryPassiveCohesion
 
  // passive off
  Widget entryBaseFriction() {
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
                  'Coefficient of friction at the base:',
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
                  height: 40,
                  child: TextField(
                    controller: inputBaseFriction,
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
                          inputBaseFriction.clear();
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
  } // entryBaseFriction

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