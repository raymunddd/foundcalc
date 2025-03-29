/*Copy paste mo nalang yan if need mo template hahaha
Basta need ng 
    1) "_state.dart" file
    2) _page.dart file
    3) Yun mga need sa tab_home
        A) List<String> analysisItems = []; // Initialize empty
          Map<String, AnalysisState> analysisStates = {};
        B) void addItem() at removeItem() chuchu
        C) Yun sa pagname ng tabs (Nakacomment naman yun template sa tab_home hahaha)
  
*/

import 'dart:collection';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/analysis_state.dart';
import 'dart:math';

class AnalysisPage extends StatefulWidget {
  final String title;
  final AnalysisState state;
  final Function(AnalysisState) onStateChanged;

  AnalysisPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late ScrollController _scrollController;

  late TextEditingController inputDepthFoundation;
  late TextEditingController inputDepthWater;
  late TextEditingController inputFootingBase;
  late TextEditingController inputCohesion;
  late TextEditingController inputFootingThickness;
  late TextEditingController inputFactorSafety;

//Soil Properties
  late TextEditingController inputSpecificGravity;
  late TextEditingController inputWaterContent;
  late TextEditingController inputVoidRatio;
//Unit Weights
  late TextEditingController inputGammaDry;
  late TextEditingController inputGammaMoist;
  late TextEditingController inputGammaSat;
  
//Angle of Internal Friction
  late TextEditingController inputAngleFriction;
  late TextEditingController inputFactCohesion;
  late TextEditingController inputFactOverburden;
  late TextEditingController inputFactUnitWeight;

  late TextEditingController inputUnitWeightWater;
  late TextEditingController inputUnitWeightConcrete;
// Result
  double? yw; // Declare yw
  double? yc; // Declare yc

  double? df; 
  double? dw;
  double? c;
  double? fDim;

  double? t;
  double? fs;

  double? gs;
  double? waterContent;
  double? w;
  double? e;

  double? yDry;
  double? y;
  double? ySat;

  double? theta;

  double? nc;
  double? nq;
  double? ny;

//solution variables (shortcut: solvar)
  double? yFinal;
  double? yPrime;
  double? hw;
  double? dfPlusB;
  double? q;
  double? qUlt;
  double? qAll;
  double? qNetAll;
  double? qNet;
  double? af;
  double? p;
  double? a;
  double? b;
  double? pf;
  double? ps;
  double? udl;

  double? sol;
  
  bool showResults = false;
  bool showSolution = false;
  bool isItStrip = true;

  bool isGammaDryEnabled = true;
  bool isGammaMoistEnabled = true;
  bool isGammaSatEnabled = true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    showResults = false;

    // Initialize controllers with saved state
    inputDepthFoundation = TextEditingController(text: widget.state.inputDepthFoundation);
    inputDepthWater = TextEditingController(text: widget.state.inputDepthWater);
    inputFootingBase = TextEditingController(text: widget.state.inputFootingBase);
    inputCohesion = TextEditingController(text: widget.state.inputCohesion);
    inputFootingThickness = TextEditingController(text: widget.state.inputFootingThickness);
    inputFactorSafety = TextEditingController(text: widget.state.inputFactorSafety);
      inputSpecificGravity = TextEditingController(text: widget.state.inputSpecificGravity);
      inputWaterContent = TextEditingController(text: widget.state.inputWaterContent);
      inputVoidRatio = TextEditingController(text: widget.state.inputVoidRatio);
      inputGammaDry = TextEditingController(text: widget.state.inputGammaDry);
      inputGammaMoist = TextEditingController(text: widget.state.inputGammaMoist);
      inputGammaSat = TextEditingController(text: widget.state.inputGammaSat);
        inputAngleFriction = TextEditingController(text: widget.state.inputAngleFriction);
        inputFactCohesion = TextEditingController(text: widget.state.inputFactCohesion);
        inputFactOverburden = TextEditingController(text: widget.state.inputFactOverburden);
        inputFactUnitWeight = TextEditingController(text: widget.state.inputFactUnitWeight);
          inputUnitWeightWater = TextEditingController(text: widget.state.inputUnitWeightWater);
          inputUnitWeightConcrete = TextEditingController(text: widget.state.inputUnitWeightConcrete);
    
    isGammaSatEnabled = widget.state.isGammaSatEnabled;

    selectedShearFailure = widget.state.selectedShearFailure;
    selectedFootingType = widget.state.selectedFootingType;

    // Add listeners to update state when text changes
    inputDepthFoundation.addListener(_updateState);
    inputDepthWater.addListener(_updateState);
    inputFootingBase.addListener(_updateState);
    inputCohesion.addListener(_updateState);
    inputFootingThickness.addListener(_updateState);
    inputFactorSafety.addListener(_updateState);
      inputSpecificGravity.addListener(_updateState);
      inputWaterContent.addListener(_updateState);
      inputVoidRatio.addListener(_updateState);
      inputGammaDry.addListener(_updateState);
      inputGammaMoist.addListener(_updateState);
      inputGammaSat.addListener(_updateState);
        inputAngleFriction.addListener(_updateState);
        inputFactCohesion.addListener(_updateState);
        inputFactOverburden.addListener(_updateState);
        inputFactUnitWeight.addListener(_updateState);
          inputUnitWeightWater.addListener(_updateState);
          inputUnitWeightConcrete.addListener(_updateState);
          
    if (widget.state.selectedFootingType == 'Strip or continuous') {
      isItStrip = true;
    } else {
      isItStrip = false;
    }
  }

  List<String> thetaValues = []; // List to hold values from the "theta" column

  Future<void> searchThetaGeneral() async {

    ByteData data = await rootBundle.load('assets/generalShear.xlsx');
    var bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);

    Sheet sheet = excel.tables.values.first;

    for (var row in sheet.rows.skip(1)) {
      double? thetaValue = double.tryParse(row[0]?.value.toString() ?? '');

      if (thetaValue != null && thetaValue == this.theta) {
        setState(() {
          nc = double.tryParse(row[1]?.value.toString() ?? '');
          nq = double.tryParse(row[2]?.value.toString() ?? '');
          ny = double.tryParse(row[3]?.value.toString() ?? '');
        });
        break;
      }
    }
  }

  Future<void> searchThetaLocal() async {

    ByteData data = await rootBundle.load('assets/localShear.xlsx');
    var bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);

    Sheet sheet = excel.tables.values.first;

    for (var row in sheet.rows.skip(1)) {
      double? thetaValue = double.tryParse(row[0]?.value.toString() ?? '');

      if (thetaValue != null && thetaValue == this.theta) {
        setState(() {
          nc = double.tryParse(row[1]?.value.toString() ?? '');
          nq = double.tryParse(row[2]?.value.toString() ?? '');
          ny = double.tryParse(row[3]?.value.toString() ?? '');
        });
        break;
      }
    }
  }

//Update function
  void _updateState() {
    setState(() {
      widget.state.inputDepthFoundation = inputDepthFoundation.text;
      widget.state.inputDepthWater = inputDepthWater.text;
      widget.state.inputFootingBase = inputFootingBase.text;
      widget.state.inputCohesion = inputCohesion.text;
      widget.state.inputFootingThickness = inputFootingThickness.text;
      widget.state.inputFactorSafety = inputFactorSafety.text;
        widget.state.inputSpecificGravity = inputSpecificGravity.text;
        widget.state.inputWaterContent = inputWaterContent.text;
        widget.state.inputVoidRatio = inputVoidRatio.text;
        widget.state.inputGammaDry = inputGammaDry.text;
        widget.state.inputGammaMoist = inputGammaMoist.text;
        widget.state.inputGammaSat = inputGammaSat.text;
          widget.state.inputAngleFriction = inputAngleFriction.text;
          widget.state.inputFactCohesion = inputFactCohesion.text;
          widget.state.inputFactOverburden = inputFactOverburden.text;
          widget.state.inputFactUnitWeight = inputFactUnitWeight.text;
            widget.state.inputUnitWeightWater = inputUnitWeightWater.text;
            widget.state.inputUnitWeightConcrete = inputUnitWeightConcrete.text;

      widget.state.selectedShearFailure = selectedShearFailure;
      widget.state.selectedFootingType = selectedFootingType;

      widget.state.isGammaSatEnabled = isGammaSatEnabled;

      df = double.tryParse(inputDepthFoundation.text);
      dw = double.tryParse(inputDepthWater.text);

      if (dw != null) {
        if (df != null) {
          if (dw! < df!) {
            widget.state.isGammaSatEnabled = true;
          } else {
            widget.state.isGammaSatEnabled = false;
          }
        } else {
          widget.state.isGammaSatEnabled = true;
        }
      } else {
        widget.state.isGammaSatEnabled = false;
      }

      yDry = double.tryParse(inputGammaDry.text);
      y = double.tryParse(inputGammaMoist.text);

      if (yDry != null) {
        isGammaMoistEnabled = false;
      } else {
        isGammaMoistEnabled = true;
      }

      if (y != null) {
        isGammaDryEnabled = false;
      } else {
        isGammaDryEnabled = true;
      }

      calculateP();

      widget.onStateChanged(widget.state);

    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    inputDepthFoundation.dispose();
    inputDepthWater.dispose();
    inputFootingBase.dispose();
    inputCohesion.dispose();
    inputFootingThickness.dispose();
    inputFactorSafety.dispose();
      inputSpecificGravity.dispose();
      inputWaterContent.dispose();
      inputVoidRatio.dispose();
      inputGammaDry.dispose();
      inputGammaMoist.dispose();
      inputGammaSat.dispose();
        inputAngleFriction.dispose();
        inputFactCohesion.dispose();
        inputFactOverburden.dispose();
        inputFactUnitWeight.dispose();
          inputUnitWeightWater.dispose();
          inputUnitWeightConcrete.dispose();
    super.dispose();
  }


  String get gammaSatHint {
    if (widget.state.isGammaSatEnabled) {
      return 'Input required';
    } else {
      return 'Input not required';
    }
  }

  String get soilPropOffHeader {
    if (widget.state.isGammaSatEnabled) {
      return 'Input only two (2)';
    } else {
      return 'Input only one (1)';
    }
  }

  String get gammaDryHint {
    if (isGammaDryEnabled) {
      return '';
    } else {
      return 'Input not required';
    }
  }

  String get gammaMoistHint {
    if (isGammaMoistEnabled) {
      return '';
    } else {
      return 'Input not required';
    }
  }

  String get footingDetLabel {
    switch (selectedFootingType) {
      case 'Strip or continuous':
        return 'Width of footing, W (in m):';
      case 'Square':
        return 'Base of footing, B (in m):';
      case 'Circular':
        return 'Diameter of footing, D (in m):';
      default:
        return 'Dimension of footing (in m):';
    }
  }

  String get buttonLabel {
    switch (selectedFootingType) {
      case 'Strip or continuous':
        return 'Calculate w:';
      case 'Circular':
        return 'Calculate P:';
      default:
        return 'Calculate P:';
    }
  }

String? selectedShearFailure;
  final List<String> shearFailureValues = [
    'General',
    'Local',
  ];

String? selectedFootingType = 'Square';
  final List<String> footingTypes = [
    'Strip or continuous',
    'Square',
    'Circular',
  ];

  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
  }

  Future<void> calculateP() async {
    // Parse the input values
      // Non-nullable
    df = double.tryParse(inputDepthFoundation.text);
    dw = double.tryParse(inputDepthWater.text);
    c = double.tryParse(inputCohesion.text);
    fDim = double.tryParse(inputFootingBase.text);
      // Nullable
    t = double.tryParse(inputFootingThickness.text);
    gs = double.tryParse(inputSpecificGravity.text);
    w = double.tryParse(inputWaterContent.text);
    e = double.tryParse(inputVoidRatio.text);

    yDry = double.tryParse(inputGammaDry.text);
    y = double.tryParse(inputGammaMoist.text);
    ySat = double.tryParse(inputGammaSat.text);
    theta = double.tryParse(inputAngleFriction.text);
    nc = double.tryParse(inputFactCohesion.text);
    nq = double.tryParse(inputFactOverburden.text);
    ny = double.tryParse(inputFactUnitWeight.text);

      // Default values
    yw = double.tryParse(inputUnitWeightWater.text) ?? 9.81; // Default to 9.81 if null
    yc = double.tryParse(inputUnitWeightConcrete.text) ?? 24; // Default to 24 if null
    fs = double.tryParse(inputFactorSafety.text) ?? 3; // Default to 3 if null

      if (df != null && fDim != null && c != null) {
        if (widget.state.soilProp == true) { //if soilProp is on
          if (dw != null) {
            hw = df! - dw!;
            if (dw! >= df!) {
              if (gs != null && e!= null && w != null) {
                yFinal = (gs!*yw!*(1+(0.01*w!)))/(1+e!); // final y = y
              } else if (gs != null && e != null) {
                yFinal = (gs!*yw!)/(1+e!);
              } else {
                yFinal = null; // any other option
              }
            } else { // Dw < Df
              if (gs != null) {
                if (e != null) {
                  if (w != null) { // Gs, e, w
                    yFinal = (yw!*(gs!+e!))/(1 + e!); // final y = ysat
                  } else { // Gs, e
                    yFinal = (yw!*(gs!+e!))/(1 + e!); // final y = ysat
                  }
                } else if (w != null) { // Gs, w
                  yFinal = (gs!*yw!*(1+0.01*w!))/(1+(0.01*w!*gs!)); // final y = ysat
                } else { // Gs
                  yFinal = null;
                }
              } else if (e != null && w != null) { // e, w
                yFinal = ((yw!*e!)/w!)/((1+(0.01*w!))/(1+e!));  // final y = ysat
              } else { // none
                yFinal = null;
              }
            }
          } else {
            if (gs != null && e!= null && w != null) {
              yFinal = (gs!*yw!*(1+(0.01*w!)))/(1+e!); // final y = y
            } else if (gs != null && e != null) {
              yFinal = (gs!*yw!)/(1+e!);
            } else {
              yFinal = null; // any other option
            }
          }
        } else { // if soilProp is off
          if (dw != null) {
            hw = df! - dw!;
            if (dw! != 0) {
              if (dw! >= df!) {
                if (yDry != null && y != null) {
                  yFinal = null;
                } else if (yDry != null) {
                  yFinal = yDry!;
                } else if (y != null) {
                  yFinal = y!;
                } else {
                  yFinal = null;
                }
              } else { // Dw < Df (at least 2)
                if (yDry != null && ySat != null) { // yDry, ySat
                  yFinal = ySat!; // final y = ySat
                } else if (y != null && ySat != null) { // y, ySat
                  yFinal = ySat!; // final y = ySat
                } else { // none
                  yFinal = null; 
                }
              }
            } else {
              if (ySat != null) {
                yFinal = ySat!;
              } else {
                yFinal = null;
              }
            }
          } else {

          }
        }

        dfPlusB = df! + fDim!;

        if (yFinal != null && yw != null && df != null && fDim != null) {
          if (dw != null) { // Dw is given
            if (dw! <= df!) { // Case 1 for y' and q
              yPrime = yFinal! - yw!;
              q = yFinal!*df! + yPrime!*hw!;
            } else if (dw! >= dfPlusB!) { // Case 3 for y' and q
              yPrime = yFinal!;
              q = yFinal!*df!;
            } else { // Case 2 for y' and q
              yPrime = yFinal! - yw!*(1 - ((dw! - df!)/fDim!));
              q = yFinal!*df!; 
            }
          } else { // no Dw
            yPrime = yFinal!;
            q = yFinal!*df!;
          }         
        } else {
          yPrime = null;
          q = null;
        }

        if (widget.state.angleDet == true) {
          if (theta != null) {
            if (theta! >= 0 && theta! <= 50) {
              if (widget.state.selectedShearFailure == 'General') {
                await searchThetaGeneral();
                if (widget.state.selectedFootingType == "Strip or continuous") {
                  qUlt = c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
                } else if (widget.state.selectedFootingType == "Square") {
                  qUlt = 1.3*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
                } else { // if circular
                  qUlt = 1.3*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
                }
              } else { // local shear
                await searchThetaLocal();
                if (widget.state.selectedFootingType == "Strip or continuous") {
                  qUlt = (2/3)*c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
                } else if (widget.state.selectedFootingType == "Square") {
                  qUlt = 0.867*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
                } else { // if circular
                  qUlt = 0.867*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
                }
              }
            } else {
              qUlt = null;
            }
          } else {
            qUlt = null;
          }
        } else { // Nc, Nq, Ny are given (angleDet = false)
          if (nc != null && nq != null && ny != null) {
            if (widget.state.selectedShearFailure == 'General') {
              if (widget.state.selectedFootingType == "Strip or continuous") {
                qUlt = c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
              } else if (widget.state.selectedFootingType == "Square") {
                qUlt = 1.3*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
              } else { // if circular
                qUlt = 1.3*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
              }
            } else { // local shear
              if (widget.state.selectedFootingType == "Strip or continuous") {
                qUlt = (2/3)*c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
              } else if (widget.state.selectedFootingType == "Square") {
                qUlt = 0.867*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
              } else { // if circular
                qUlt = 0.867*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
              }
            }
          } else { // no Nc, Nq and Ny
            qUlt = null;
          }
        }

        if (selectedFootingType == 'Square') {
          af = fDim!*fDim!;
        } else if (selectedFootingType == 'Circular') {
          af = 0.25*pi*fDim!*fDim!;
        } else {
          af = null;
        }

        if (qUlt != null && q != null) {
          qAll = qUlt!/fs!;
          qNetAll = (qUlt! - q!)/fs!;
          qNet = qNetAll!*fs!;
        }

        if (q != null && qUlt != null) {
          if (t != null && hw != null) {
            a = df! - hw!;
            b = df! - t!;
            if (af != null) { // square/circular
              sol = 1; // with t, square/circular
              
              pf = yc!*af!*t!;
              ps = af!*(y!*a!-ySat!*b!);
              p = (af!*(qUlt!+yw!*hw!)) - pf! - ps!;
              p = roundToFourDecimalPlaces(p!);
              udl = 0;
            } else { // strip
              sol = 2; // with t, strip

              pf = yc!*fDim!*t!;
              ps = fDim!*(y!*a!-ySat!*b!);
              p = 0;
              udl = (fDim!*(qUlt!+yw!*hw!)) - pf! - ps!;
              udl = roundToFourDecimalPlaces(udl!);
            }
          } else { // if no t
            if (af != null) { // square/circular
              sol = 3; // with no t, square/circular

              p = qAll!*af!;
              p = roundToFourDecimalPlaces(p!);
              udl = 0;
            } else { // strip
              sol = 1; // with t, strip

              p = 0;
              udl = qAll!*fDim!;
              udl = roundToFourDecimalPlaces(udl!);
            }
          }
        }
      } else {
        yFinal = null;
      }

  // Print the results for debugging
  print("yw = $yw, yc = $yc, yFinal = $yFinal, yPrime = $yPrime, q = $q");
  print('///////////////////');
  print('Nc = $nc, Nq = $nq, Nγ = $ny, qUlt = $qUlt, qAll = $qAll, qNet = $qNet, qAllNet = $qNetAll, P = $p, w = $udl, isGammaSatEnabled = $isGammaSatEnabled');
  print('isGammaDryEnabled = $isGammaDryEnabled, isGammaMoistEnabled = $isGammaMoistEnabled');
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF363434),
  // App Bar
      appBar: AppBar(
        title: Text(
          widget.title,
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
                      row1ShearFailure(),
                      row2FootingType(),
                      row3Df(),
                      row4footingDim(),
                      row5Cohesion(),
                      row6Dw(),
                      row7Thickness(),
                      row8FactorOfSafety(),
                      row9SoilProp(),
                      Stack(
                        children: [
                          row10aSoilPropOn(),
                          row10bSoilPropOff(),
                        ]
                      ),
                      row11AngleDet(),
                      Stack(
                        children: [
                          row12aAngleDetOn(),
                          row12bAngleDetOff(),
                        ]
                      ),
                      row13yWaterDet(),
                      row14yWaterDetOn(),
                      row15yConcreteDet(),
                      row16yConcreteDetOn(),
                      SizedBox(height: 10),
                      submitButton(),
                      SizedBox(height: 10),
                      if (showResults && selectedFootingType == 'Strip or continuous')
                        resultStrip(),
                      if (showResults && (selectedFootingType == 'Square' || selectedFootingType == 'Circular'))
                        resultNotStrip(),
                      SizedBox(height: 10),
                      if (showResults)
                        solutionButton(),
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

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle form submission
        calculateP();
        setState(() {
          showResults = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(buttonLabel),
    );
  }
  Widget solutionButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          showSolution = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('View solution'),
    );
  }
  Widget resultStrip() {
    return Text(
      "w = $udl kN/m",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  Widget resultNotStrip() {
    return Text(
      "P = $p kN",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget row1ShearFailure() {
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
                'Type of shear failure:',
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
                value: selectedShearFailure,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedShearFailure = newValue;
                    });
                  },
                items: shearFailureValues.map((String value) {
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
  }
  Widget row2FootingType() {
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
                'Type of footing:',
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
                value: selectedFootingType,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFootingType = newValue;
                    showResults = false;
                    });
                  },
                items: footingTypes.map((String value) {
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
  }
  Widget row3Df() {
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
                  height: 40, // Adjust height as needed
                  child: TextField(
                    controller: inputDepthFoundation, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputDepthFoundation.clear();
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
  Widget row4footingDim() {
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
                  footingDetLabel,
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
                    controller: inputFootingBase,
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
                          inputFootingBase.clear();
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
  }
  Widget row5Cohesion() {
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
                  'Cohesion, c (in kPa):',
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
                    controller: inputCohesion,
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
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }
  Widget row6Dw() {
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
                  'Depth of the water table from ground level, Dw (in m):',
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
                    controller: inputDepthWater,
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Optional",
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
                          inputDepthWater.clear();
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
  }
  Widget row7Thickness() {
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
                  'Footing thickness, t (in m):',
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
                    controller: inputFootingThickness,
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Optional",
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
                            inputFootingThickness.clear();
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
  }
  Widget row8FactorOfSafety() {
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
                  'Factor of safety:',
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
                    controller: inputFactorSafety,
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Optional",
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
                          inputFactorSafety.clear();
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
  }

  Widget row9SoilProp() {
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
                  'Soil properties',
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
                    value: widget.state.soilProp,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.soilProp = newValue;
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
  }
  // Soil Prop On
  Widget row10aSoilPropOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.soilProp,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 10, 131, 14),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
// Soil Prop On Manager
                row10aaGs(),
                row10abVoidRatio(),
                row10acWaterContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget row10aaGs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Specific gravity of soil solids, Gs:',
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
                  controller: inputSpecificGravity,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Input required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 149, 53),
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
                        inputSpecificGravity.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  Widget row10abVoidRatio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Void ratio, e:',
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
                  controller: inputVoidRatio,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Input required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 149, 53),
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
                        inputVoidRatio.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  Widget row10acWaterContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Water content, ω (%):',
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
                  controller: inputWaterContent,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Optional",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 149, 53),
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
                        inputWaterContent.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  // Soil Prop Off
  Widget row10bSoilPropOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.soilProp,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 201, 40, 29),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  row10bHeader(),
                  row10baGammaDry(),
                  row10bbGammaMoist(),
                  row10bcGammaSat(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget row10bHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centers the text
        children: [
          Flexible(
            child: Text(
              soilPropOffHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold, // Makes text bold
              ),
              textAlign: TextAlign.center, // Centers the text inside the widget
            ),
          ),
        ],
      ),
    );
  }
  Widget row10baGammaDry() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Dry/bulk unit weight, γdry (in kN/m³):',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
                  controller: inputGammaDry,
                  enabled: isGammaDryEnabled,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: gammaDryHint,
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 226, 65, 54),
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
                        inputGammaDry.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  Widget row10bbGammaMoist() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Moist unit weight, γ (in kN/m³):',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
                  controller: inputGammaMoist,
                  enabled: isGammaMoistEnabled,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: gammaMoistHint,
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 226, 65, 54),
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
                        inputGammaMoist.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  Widget row10bcGammaSat() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Saturated unit weight, γsat (in kN/m³):',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
                  controller: inputGammaSat,
                  enabled: widget.state.isGammaSatEnabled,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: gammaSatHint,
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 226, 65, 54),
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
                        inputGammaSat.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }


  Widget row11AngleDet() {
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
                width: 120,
                child: Text(
                  'Angle of internal friction',
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
                    value: widget.state.angleDet,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.angleDet = newValue;
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
  }
// Angle Det On
  Widget row12aAngleDetOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.angleDet,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 10, 131, 14),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
// Angle Det On Manager
                row12aHeader(),
                row12aaAngle(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget row12aHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centers the text
        children: [
          Flexible(
            child: Text(
              'Input an integer within this range: 0 ≤ θ ≤ 50',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold, // Makes text bold
              ),
              textAlign: TextAlign.center, // Centers the text inside the widget
            ),
          ),
        ],
      ),
    );
  }
  Widget row12aaAngle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Angle of internal friction, θ (in degrees):',
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
                  controller: inputAngleFriction,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Input required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 149, 53),
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
                        inputAngleFriction.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  // Angle Det Off
  Widget row12bAngleDetOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.angleDet,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 201, 40, 29),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
// offmanager
                  row12baNc(),
                  row12bbNq(),
                  row12bcNy(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget row12baNc() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Cohesion factor, Nc:',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
                  controller: inputFactCohesion,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Input required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 226, 65, 54),
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
                        inputFactCohesion.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  Widget row12bbNq() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Overburden factor, Nq:',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
                  controller: inputFactOverburden,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Input required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 226, 65, 54),
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
                        inputFactOverburden.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  Widget row12bcNy() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Unit weight factor, Nγ:',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
                  controller: inputFactUnitWeight,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Input required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 226, 65, 54)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 226, 65, 54),
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
                        inputFactUnitWeight.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }

  Widget row13yWaterDet() {
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
                width: 120,
                child: Text(
                  'Unit weight of water (assumed as 9.81 kN/m³ if not given)',
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
                    value: widget.state.waterDet,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.waterDet = newValue;
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
  }
  Widget row14yWaterDetOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.waterDet,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 10, 131, 14),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                row14ayWater(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget row14ayWater() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Unit weight of water, γw (in kN/m³):',
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
                  controller: inputUnitWeightWater,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Input required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 149, 53),
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
                        inputUnitWeightWater.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  
  Widget row15yConcreteDet() {
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
                width: 120,
                child: Text(
                  'Unit weight of concrete (assumed as 24 kN/m³ if not given)',
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
                    value: widget.state.concreteDet,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.concreteDet = newValue;
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
  }
  Widget row16yConcreteDetOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.concreteDet,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 10, 131, 14),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                row16ayConcrete(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget row16ayConcrete() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Unit weight of concrete, γconc. (in kN/m³):',
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
                  controller: inputUnitWeightConcrete,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Field required",
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color.fromARGB(255, 51, 149, 53)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 149, 53),
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
                        inputUnitWeightConcrete.clear();
                      },
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }
  // to be fixed
  Widget row17Solution() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
        ],
      ),
    );
  }
} // AnalysisPageState