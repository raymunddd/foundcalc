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

  @override
  bool get wantKeepAlive => true;

  String get displayTitle {
    if (widget.title.startsWith('Mat')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Mat Foundation $index";
    }

    return widget.title; 
  }

  int selectedCalc = 1; // FS
  // scroll bar
  late ScrollController _scrollController;
  // inputs

  late TextEditingController inputCu;
  late TextEditingController inputB;
  late TextEditingController inputL;
  late TextEditingController inputDf;
  late TextEditingController inputTheta;

  late TextEditingController inputQ;
  late TextEditingController inputGamma;

  late TextEditingController inputN60;
  late TextEditingController inputSe;

  // variables
  double? cu;
  double? b;
  double? l;
  double? df;
  double? theta;
  
  double? Q;
  double? y;

  double? n60;
  double? se;
  // solvar (solution variables)
  double? nc;
  double? nq;
  double? ny;
  double? fcs;
  double? fcd;

  double? q;
  double? fs;

  double? qnetu;
  
  double? fd;
  double? fdFinal;
  double? qneta;
  // rounded
  double? roundedFcs;
  double? roundedFcd;
  double? roundedQ;
  double? roundedFdFinal;

  // string getters
  String get headerTitle {
    if (selectedCalc == 1) {
      return 'Factor of safety';
    } else if (selectedCalc == 2) {
      return 'Net ultimate bearing capacity';
    } else {
      return 'Net allowable bearing capacity';
    }
  }

  String get buttonTitle {
    if (selectedCalc == 1) {
      return 'Calculate F.S.';
    } else if (selectedCalc == 2) {
      return 'Solve qnet(u)';
    } else {
      return 'Solve qnet(a)';
    }
  }

  String get solutionButtonLabel {
    if (widget.state.showSolution) {
      return 'Hide solution';
    } else {
      return 'View solution';
    }
  }

  String? angle;
  final List<String> angleValues = List<String>.generate(51, (index) => index.toString());

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    // for input
    
    inputCu = TextEditingController(text: widget.state.inputCu);
    inputB = TextEditingController(text: widget.state.inputB);
    inputL = TextEditingController(text: widget.state.inputL);
    inputDf = TextEditingController(text: widget.state.inputDf);
    inputTheta = TextEditingController(text: widget.state.inputTheta);
    
    inputQ = TextEditingController(text: widget.state.inputQ);
    inputGamma = TextEditingController(text: widget.state.inputGamma);

    inputN60 = TextEditingController(text: widget.state.inputN60);
    inputSe = TextEditingController(text: widget.state.inputSe);

    // for dropdowns

    /*
    loadingCase = widget.state.loadingCase; (no default value)

    calculation = "Factor of safety"; // Set default value here
    widget.state.calculation = calculation;
    */

    // listeners

    inputCu.addListener(_updateState);
    inputB.addListener(_updateState);
    inputL.addListener(_updateState);
    inputDf.addListener(_updateState);
    inputTheta.addListener(_updateState);

    inputQ.addListener(_updateState);
    inputGamma.addListener(_updateState);

    inputN60.addListener(_updateState);
    inputSe.addListener(_updateState);
  }
  void _updateState() {
    setState(() {
      widget.state.inputCu = inputCu.text;
      widget.state.inputB = inputB.text;
      widget.state.inputL = inputL.text;
      widget.state.inputDf = inputDf.text;
      widget.state.inputTheta = inputTheta.text;

      widget.state.inputQ = inputQ.text;
      widget.state.inputGamma = inputGamma.text;
      
      widget.state.inputN60 = inputN60.text;
      widget.state.inputSe = inputSe.text;
      //calcQ();

      widget.onStateChanged(widget.state);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    inputCu.dispose();
    inputB.dispose();
    inputL.dispose();
    inputDf.dispose();
    inputTheta.dispose();

    inputQ.dispose();
    inputGamma.dispose();
    
    inputN60.dispose();
    inputSe.dispose();

    super.dispose();
  }

  List<Map<String, dynamic>> localShear = [
    {"theta": 0, "nc": 5.14, "nq": 1, "ny": 0},
    {"theta": 1, "nc": 5.38, "nq": 1.09, "ny": 0.07},
    {"theta": 2, "nc": 5.63, "nq": 1.2, "ny": 0.15},
    {"theta": 3, "nc": 5.9, "nq": 1.31, "ny": 0.24},
    {"theta": 4, "nc": 6.19, "nq": 1.43, "ny": 0.34},
    {"theta": 5, "nc": 6.49, "nq": 1.57, "ny": 0.45},
    {"theta": 6, "nc": 6.81, "nq": 1.72, "ny": 0.57},
    {"theta": 7, "nc": 7.16, "nq": 1.88, "ny": 0.71},
    {"theta": 8, "nc": 7.53, "nq": 2.06, "ny": 0.86},
    {"theta": 9, "nc": 7.92, "nq": 2.25, "ny": 1.03},
    {"theta": 10, "nc": 8.35, "nq": 2.47, "ny": 1.22},
    {"theta": 11, "nc": 8.8, "nq": 2.71, "ny": 1.44},
    {"theta": 12, "nc": 9.28, "nq": 2.97, "ny": 1.69},
    {"theta": 13, "nc": 9.81, "nq": 3.26, "ny": 1.97},
    {"theta": 14, "nc": 10.37, "nq": 3.59, "ny": 2.29},
    {"theta": 15, "nc": 10.98, "nq": 3.94, "ny": 2.65},
    {"theta": 16, "nc": 11.63, "nq": 4.34, "ny": 3.06},
    {"theta": 17, "nc": 12.34, "nq": 4.77, "ny": 3.53},
    {"theta": 18, "nc": 13.1, "nq": 5.26, "ny": 4.07},
    {"theta": 19, "nc": 13.93, "nq": 5.8, "ny": 4.68},
    {"theta": 20, "nc": 14.83, "nq": 6.4, "ny": 5.39},
    {"theta": 21, "nc": 15.82, "nq": 7.07, "ny": 6.2},
    {"theta": 22, "nc": 16.88, "nq": 7.82, "ny": 7.13},
    {"theta": 23, "nc": 18.05, "nq": 8.66, "ny": 8.2},
    {"theta": 24, "nc": 19.32, "nq": 9.6, "ny": 9.44},
    {"theta": 25, "nc": 20.72, "nq": 10.66, "ny": 10.88},
    {"theta": 26, "nc": 22.25, "nq": 11.85, "ny": 12.54},
    {"theta": 27, "nc": 23.94, "nq": 13.2, "ny": 14.47},
    {"theta": 28, "nc": 25.8, "nq": 14.72, "ny": 16.72},
    {"theta": 29, "nc": 27.86, "nq": 16.44, "ny": 19.34},
    {"theta": 30, "nc": 30.14, "nq": 18.4, "ny": 22.4},
    {"theta": 31, "nc": 32.67, "nq": 20.63, "ny": 25.99},
    {"theta": 32, "nc": 35.49, "nq": 23.18, "ny": 30.22},
    {"theta": 33, "nc": 38.64, "nq": 26.09, "ny": 35.19},
    {"theta": 34, "nc": 42.16, "nq": 29.44, "ny": 41.06},
    {"theta": 35, "nc": 46.12, "nq": 33.3, "ny": 48.03},
    {"theta": 36, "nc": 50.59, "nq": 37.75, "ny": 56.31},
    {"theta": 37, "nc": 55.63, "nq": 42.92, "ny": 66.19},
    {"theta": 38, "nc": 61.35, "nq": 48.93, "ny": 78.03},
    {"theta": 39, "nc": 67.87, "nq": 55.96, "ny": 92.25},
    {"theta": 40, "nc": 75.31, "nq": 64.2, "ny": 109.41},
    {"theta": 41, "nc": 83.86, "nq": 73.9, "ny": 130.22},
    {"theta": 42, "nc": 93.71, "nq": 85.38, "ny": 155.55},
    {"theta": 43, "nc": 105.11, "nq": 99.02, "ny": 186.54},
    {"theta": 44, "nc": 118.37, "nq": 115.31, "ny": 224.64},
    {"theta": 45, "nc": 133.88, "nq": 134.88, "ny": 271.76},
    {"theta": 46, "nc": 152.1, "nq": 158.51, "ny": 330.35},
    {"theta": 47, "nc": 173.64, "nq": 187.21, "ny": 403.67},
    {"theta": 48, "nc": 199.26, "nq": 222.31, "ny": 496.01},
    {"theta": 49, "nc": 229.93, "nq": 265.51, "ny": 613.16},
    {"theta": 50, "nc": 266.89, "nq": 319.07, "ny": 762.89},
  ];

  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
  }
  double roundToTwoDecimalPlaces(double value) {
    return (value * 100).round() / 100;
  }

  void solve() {
    cu = double.tryParse(inputCu.text);
    b = double.tryParse(inputB.text);
    l = double.tryParse(inputL.text);
    df = double.tryParse(inputDf.text);
    theta = double.tryParse(inputTheta.text);

    Q = double.tryParse(inputQ.text);
    y = double.tryParse(inputGamma.text);

    n60 = double.tryParse(inputN60.text);
    se = double.tryParse(inputSe.text);

    
    if (selectedCalc == 1) { // F.S.
      widget.state.solvedCalc = 1;
    } else if (selectedCalc == 2) { // qnet(u)
      widget.state.solvedCalc = 2;
    } else {  // qnet(a)
      widget.state.solvedCalc = 3;
    }

    if (selectedCalc == 1) { // F.S. calculation
      if (cu != null && b != null && l != null && df != null && 
      theta != null && Q != null && y != null) {
        if (theta! > 0 && theta! <= 50) {
          var shearData = localShear.firstWhere(
            (element) => element['theta'] == theta,
            orElse: () => {"nc": null, "nq": null, "ny": null}, // Default values if not found
          );
          setState(() {
            nc = shearData['nc'];
            nq = shearData['nq'];
            ny = shearData['ny'];  
          });
        } else if (theta == 0) {
          setState(() {
            nc = 5.14;
            nq = 1;
            ny = 0;
          });
        } else {
          showSnackBarTheta(context);
          setState(() {
              widget.state.showResults = false;
              widget.state.showSolution = false;
              widget.state.solutionToggle = true;
          });
          nc = nq = ny = null; // or set to some default values
        }

        if (nc != null && nq != null && ny != null) {
          if (l! < b!) {
            qnetu = null;
            widget.state.qnetu = null;
            showSnackBarDimension(context);
            setState(() {
              widget.state.showResults = false;
              widget.state.showSolution = false;
              widget.state.solutionToggle = true;
            });
            fs = 0.01;
            return;
          } else { // L ≥ B
            fcs = (1 + (b! * nq!) / (l! * nc!));
            fcd = 1 + (0.4 * df!) / b!;
            qnetu = cu! * nc! * fcs! * fcd!;

            roundedFcs = roundToFourDecimalPlaces(fcs!);
            roundedFcd = roundToFourDecimalPlaces(fcd!);
            widget.state.qnetu = roundToFourDecimalPlaces(qnetu!);
          }
        } else {
          showSnackBarIncorrect(context);
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          fs = 0.02;
        }

        if (qnetu != null) {
          q = (Q! / (b! * l!)) - y! * df!;
          fs = qnetu! / ((Q! / (b! * l!)) - y! * df!);

          roundedQ = roundToFourDecimalPlaces(q!);
          widget.state.fs = roundToFourDecimalPlaces(fs!);
          setState(() {
            widget.state.showResults = true;
          });
        } else {
          q = null;

          roundedQ = null;
          widget.state.fs = null;
          showSnackBarIncorrect(context);
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          fs = 0.03;
        }
      } else { // all inputs are null
        showSnackBarIncorrect(context);
        setState(() {
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
        fcs = null;
        fcd = null;
        qnetu = null;

        roundedFcs = null;
        roundedFcd = null;
        widget.state.qnetu = null;

        fs = 0.04;
      }
    } else if (selectedCalc == 2) { // qnet(u) calculation
      if (cu != null && b != null && l != null && df != null && 
      theta != null) {
        if (theta! > 0 && theta! <= 50) {
          var shearData = localShear.firstWhere(
            (element) => element['theta'] == theta,
            orElse: () => {"nc": null, "nq": null, "ny": null}, // Default values if not found
          );
          setState(() {
            nc = shearData['nc'];
            nq = shearData['nq'];
            ny = shearData['ny'];  
          });
        } else if (theta == 0) {
          setState(() {
            nc = 5.14;
            nq = 1;
            ny = 0;
          });
        } else {
          showSnackBarTheta(context);
          setState(() {
              widget.state.showResults = false;
              widget.state.showSolution = false;
              widget.state.solutionToggle = true;
          });
          nc = nq = ny = null; // or set to some default values
        }

        if (nc != null && nq != null && ny != null) {
          if (l! < b!) {
            qnetu = null;
            widget.state.qnetu = null;
            showSnackBarDimension(context);
            setState(() {
              widget.state.showResults = false;
              widget.state.showSolution = false;
              widget.state.solutionToggle = true;
            });
            fs = 0.01;
            return;
          } else { // L ≥ B
            fcs = (1 + (b! * nq!) / (l! * nc!));
            fcd = 1 + (0.4 * df!) / b!;
            qnetu = cu! * nc! * fcs! * fcd!;

            roundedFcs = roundToFourDecimalPlaces(fcs!);
            roundedFcd = roundToFourDecimalPlaces(fcd!);
            widget.state.qnetu = roundToFourDecimalPlaces(qnetu!);
            setState(() {
            widget.state.showResults = true;
          });
          }
        } else {
          showSnackBarIncorrect(context);
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          fs = 0.02;
        }
      } else { // all inputs are null
        showSnackBarIncorrect(context);
        setState(() {
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
        fcs = null;
        fcd = null;
        qnetu = null;

        roundedFcs = null;
        roundedFcd = null;
        widget.state.qnetu = null;

        fs = 0.04;
      }
    } else { // qnet(a) calculation
      if (df != null && b != null && n60 != null && se != null) {
        fd = 1 + (0.33 * df!) / b!;

        if (fd != null) {
          if (fd! <= 1.33) {
            fdFinal = fd;
            roundedFdFinal = roundToTwoDecimalPlaces(fdFinal!);
          } else { // Fd > 1.33
            fdFinal = 1.33;
            roundedFdFinal = roundToTwoDecimalPlaces(fdFinal!);
          }
        } else {
          fdFinal = null;
          roundedFdFinal = null;
        }

        if (fdFinal != null) {
          qneta = (n60! * fdFinal! * se!) / (0.08 * 25);
          widget.state.qneta = roundToFourDecimalPlaces(qneta!);
          setState(() {
            widget.state.showResults = true;
          });
        } else {
          qneta = null;
          widget.state.qneta = null;
        }

      } else {
        fd = null;
        fdFinal = null;
        qneta = null;
        widget.state.qneta = null;
        showSnackBarIncorrect(context);
        setState(() {
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
      }
    }

    print('nc = $nc, nq = $nq, ny = $ny, qnetu = $qnetu, F.S. = $fs, qneta = $qneta');
  }

  void showSnackBarTheta(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("The angle of internal friction must be from the specified range."),
        backgroundColor: const Color.fromARGB(255, 201, 40, 29),
        duration: Duration(seconds: 3),
      ),
    );
    setState(() {
      widget.state.showResults = false;
    });
  }
  void showSnackBarIncorrect(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please provide input for all parameters."),
        backgroundColor: const Color.fromARGB(255, 201, 40, 29),
        duration: Duration(seconds: 3),
      ),
    );
    setState(() {
      widget.state.showResults = false;
    });
  }
  void showSnackBarDimension(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("L must be greater than B."),
        backgroundColor: const Color.fromARGB(255, 201, 40, 29),
        duration: Duration(seconds: 3),
      ),
    );
    setState(() {
      widget.state.showResults = false;
    });
  }

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
                      SizedBox(height: 5),
                      radioCalc(),
                      headerMain(),

                      if (selectedCalc == 1 || selectedCalc == 2)
                        entryCu(),

                      entryB(),

                      if (selectedCalc == 1 || selectedCalc == 2)
                        entryL(),

                      entryDf(),

                      if (selectedCalc == 1 || selectedCalc == 2)
                        entryTheta(),
                      if (selectedCalc == 1 || selectedCalc == 2)
                        subtextTheta(),

                      if (selectedCalc == 1)
                        entryQ(),
                      if (selectedCalc == 1)
                        entryGamma(),

                      if (selectedCalc == 3)
                        entryN60(),
                      if (selectedCalc == 3)
                        entrySe(),

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
  } // headerCalc
  Widget radioCalc() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxWidth: 450),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: selectedCalc,
                  onChanged: (val) {
                    setState(() {
                      selectedCalc = val!;
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
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 2,
                  groupValue: selectedCalc,
                  onChanged: (val) {
                    setState(() {
                      selectedCalc = val!;
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
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 3,
                  groupValue: selectedCalc,
                  onChanged: (val) {
                    setState(() {
                      selectedCalc = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Net allowable bearing capacity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ), 
        ],
      ),
    );    
  }
  Widget headerMain() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        headerTitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerrr
  Widget entryCu() {
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
                  'Undrained cohesion, cᵤ (in kPa):',
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
                    controller: inputCu,
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
                          inputCu.clear();
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
  } 
  Widget entryB() {
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
                  'Width of foundation, B (in m):',
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
                    controller: inputB,
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
                          inputB.clear();
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
  } // entryB
  Widget entryL() {
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
                  'Length of foundation, L (in m):',
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
                    controller: inputL,
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
                          inputL.clear();
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
  } // entryL
  Widget entryDf() {
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
                  'Depth of foundation, Df (in m):',
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
                    controller: inputDf,
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
                          inputDf.clear();
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
  } // entryDf
  Widget entryTheta() {
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
                'Angle of internal friction, θ (in degrees):',
                style: TextStyle(color: Colors.white),
              ),
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
                    controller: inputTheta,
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
                          inputTheta.clear();
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
  } // entryTheta
  Widget subtextTheta() {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Centers row children horizontally
          children: [
            Container(
              width: 179, // Set the same width as the text field in entryTheta
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0), // Add space to the right
                child: Text(
                  '(input an integer within \nthis range: 0 ≤ θ ≤ 50)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center, // Center the text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } // subtextTheta
  
  Widget entryQ() {
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
                'Total load, Q (in kN):',
                style: TextStyle(color: Colors.white),
              ),
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
                    controller: inputQ,
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
                          inputQ.clear();
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
  } // entryQ
  Widget entryGamma() {
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
                'Unit weight of soil, γ (in kN/m³):',
                style: TextStyle(color: Colors.white),
              ),
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
                    controller: inputGamma,
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
                          inputGamma.clear();
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
  } // entryGamma

  Widget entryN60() {
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
                  'Standard penetration resistance, N₆₀:',
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
                    controller: inputN60,
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
                          inputN60.clear();
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
  } // entryN60
  Widget entrySe() {
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
                  'Settlement, Sₑ (in mm):',
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
                    controller: inputSe,
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
                          inputSe.clear();
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
  } // entrySe

  Widget buttonSubmit() {
    return ElevatedButton(
      onPressed: () {
        solve();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(buttonTitle),
    );
  }
  Widget resultText() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            if (widget.state.solvedCalc == 1)
              Text(
                'F.S. = ${widget.state.fs}',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 2)
              Text(
                'qnet(u) = ${widget.state.qnetu}',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 3)
              Text(
                'qnet(a) = ${widget.state.qneta}',
                style: TextStyle(color: Colors.white),
              ),
          ],
        )
      )
    );
  }
  
  Widget clearButton() {
    return ElevatedButton(
      onPressed: () {        
        inputCu.clear();
        inputB.clear();
        inputL.clear();
        inputDf.clear();
        inputTheta.clear();

        inputQ.clear();
        inputGamma.clear();

        inputN60.clear();
        inputSe.clear();
        setState(() {
          widget.state.showResults = false;
          widget.state.solutionToggle = true;
          widget.state.showSolution = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text("Clear all values"),
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

  Widget solutionButton() {
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
            children: [
              textSolution(),
            ],
          ),
        ),
      ),
    );
  }
  Widget textSolution() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            if (widget.state.solvedCalc == 1 || widget.state.solvedCalc == 2)
              Text(
                'Nc = $nc',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 1 || widget.state.solvedCalc == 2)
              Text(
                'Nc = $nq',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 1 || widget.state.solvedCalc == 2)
              Text(
                'Ny = $ny',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 1 || widget.state.solvedCalc == 2)
              Text(
                'Fcs = $roundedFcs',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 1 || widget.state.solvedCalc == 2)
              Text(
                'Fcd = $roundedFcd',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 1 || widget.state.solvedCalc == 2)
              Text(
                'qnet(u) = ${widget.state.qnetu}',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 1)
              Text(
                'Q/A - γDf = $roundedQ',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 1)
              Text(
                'F.S. = ${widget.state.fs}',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 3)
              Text(
                'Fd = $roundedFdFinal',
                style: TextStyle(color: Colors.white),
              ),
            if (widget.state.solvedCalc == 3)
              Text(
                'qnet(a) = ${widget.state.qneta}',
                style: TextStyle(color: Colors.white),
              ),
          ],
        )
      )
    );
  }
  
// for FAB to scroll to top
  @override
  void didUpdateWidget(MatFoundationPage oldWidget) {
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

} // _MatFoundationState