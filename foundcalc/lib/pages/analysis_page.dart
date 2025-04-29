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

class _AnalysisPageState extends State<AnalysisPage> 
with AutomaticKeepAliveClientMixin<AnalysisPage>{
  
  String get displayTitle {
    if (widget.title.startsWith('Analysis')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Analysis of Footings $index"; // Shorter for tab
    }

    return widget.title; 
  }

  @override
  bool get wantKeepAlive => true; 

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
  double? yw;
  double? ywFinal;
  double? yc;
  double? ycFinal;

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
  double? uD;
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

  double? rounded_yFinal;
  double? rounded_yPrime;
  double? rounded_q;
  double? rounded_qUlt;
  double? rounded_qAll;
  double? rounded_qNetAll;
  double? rounded_af;
  double? rounded_pf;
  double? rounded_ps;
  double? rounded_uD;

  

  List<Map<String, dynamic>> generalShear = [
    {"theta": 0, "nc": 5.7, "nq": 1, "ny": 0},
    {"theta": 1, "nc": 6, "nq": 1.1, "ny": 0.01},
    {"theta": 2, "nc": 6.3, "nq": 1.22, "ny": 0.04},
    {"theta": 3, "nc": 6.62, "nq": 1.35, "ny": 0.06},
    {"theta": 4, "nc": 6.97, "nq": 1.49, "ny": 0.1},
    {"theta": 5, "nc": 7.34, "nq": 1.64, "ny": 0.14},
    {"theta": 6, "nc": 7.73, "nq": 1.81, "ny": 0.2},
    {"theta": 7, "nc": 8.15, "nq": 2, "ny": 0.27},
    {"theta": 8, "nc": 8.6, "nq": 2.21, "ny": 0.35},
    {"theta": 9, "nc": 9.09, "nq": 2.44, "ny": 0.44},
    {"theta": 10, "nc": 9.61, "nq": 2.69, "ny": 0.56},
    {"theta": 11, "nc": 10.16, "nq": 2.98, "ny": 0.69},
    {"theta": 12, "nc": 10.76, "nq": 3.29, "ny": 0.85},
    {"theta": 13, "nc": 11.41, "nq": 3.63, "ny": 1.04},
    {"theta": 14, "nc": 12.11, "nq": 4.02, "ny": 1.26},
    {"theta": 15, "nc": 12.86, "nq": 4.45, "ny": 1.52},
    {"theta": 16, "nc": 13.68, "nq": 4.92, "ny": 1.82},
    {"theta": 17, "nc": 14.6, "nq": 5.45, "ny": 2.18},
    {"theta": 18, "nc": 15.12, "nq": 6.04, "ny": 2.59},
    {"theta": 19, "nc": 16.56, "nq": 6.7, "ny": 3.07},
    {"theta": 20, "nc": 17.69, "nq": 7.44, "ny": 3.64},
    {"theta": 21, "nc": 18.92, "nq": 8.26, "ny": 4.31},
    {"theta": 22, "nc": 20.27, "nq": 9.19, "ny": 5.09},
    {"theta": 23, "nc": 21.75, "nq": 10.23, "ny": 6},
    {"theta": 24, "nc": 23.36, "nq": 11.4, "ny": 7.08},
    {"theta": 25, "nc": 25.13, "nq": 12.72, "ny": 8.34},
    {"theta": 26, "nc": 27.09, "nq": 14.21, "ny": 9.84},
    {"theta": 27, "nc": 29.24, "nq": 16.9, "ny": 11.6},
    {"theta": 28, "nc": 31.61, "nq": 17.81, "ny": 13.7},
    {"theta": 29, "nc": 34.24, "nq": 19.98, "ny": 16.18},
    {"theta": 30, "nc": 37.16, "nq": 22.46, "ny": 19.13},
    {"theta": 31, "nc": 40.41, "nq": 25.28, "ny": 22.65},
    {"theta": 32, "nc": 44.04, "nq": 28.52, "ny": 26.87},
    {"theta": 33, "nc": 48.09, "nq": 32.23, "ny": 31.94},
    {"theta": 34, "nc": 52.64, "nq": 36.5, "ny": 38.04},
    {"theta": 35, "nc": 57.75, "nq": 41.44, "ny": 45.41},
    {"theta": 36, "nc": 63.53, "nq": 47.16, "ny": 54.36},
    {"theta": 37, "nc": 70.01, "nq": 53.8, "ny": 65.27},
    {"theta": 38, "nc": 77.5, "nq": 61.55, "ny": 78.61},
    {"theta": 39, "nc": 85.97, "nq": 70.61, "ny": 95.03},
    {"theta": 40, "nc": 95.66, "nq": 81.27, "ny": 116.31},
    {"theta": 41, "nc": 106.81, "nq": 93.85, "ny": 140.51},
    {"theta": 42, "nc": 119.67, "nq": 108.75, "ny": 171.99},
    {"theta": 43, "nc": 134.58, "nq": 126.5, "ny": 211.56},
    {"theta": 44, "nc": 161.95, "nq": 147.74, "ny": 261.6},
    {"theta": 45, "nc": 172.28, "nq": 173.28, "ny": 325.34},
    {"theta": 46, "nc": 196.22, "nq": 204.19, "ny": 407.11},
    {"theta": 47, "nc": 224.55, "nq": 241.8, "ny": 512.84},
    {"theta": 48, "nc": 258.28, "nq": 287.85, "ny": 650.67},
    {"theta": 49, "nc": 298.71, "nq": 344.63, "ny": 831.99},
    {"theta": 50, "nc": 347.5, "nq": 416.14, "ny": 1072.8}
  ];
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

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();


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
          widget.state.isGammaSatEnabled = false;
        }
      } else {
        widget.state.isGammaSatEnabled = false;
      }

      yDry = double.tryParse(inputGammaDry.text);
      y = double.tryParse(inputGammaMoist.text);

      if (yDry != null) {
        widget.state.isGammaMoistEnabled = false;
      } else {
        widget.state.isGammaMoistEnabled = true;
      }

      if (y != null) {
        widget.state.isGammaDryEnabled = false;
      } else {
        widget.state.isGammaDryEnabled = true;
      }

    // calculateP();

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
    if (widget.state.isGammaDryEnabled) {
      return '';
    } else {
      return 'Input not required';
    }
  }

  String get gammaMoistHint {
    if (widget.state.isGammaMoistEnabled) {
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

  String get solutionButtonLabel {
    if (widget.state.showSolution) {
      return 'Hide solution';
    } else {
      return 'View solution';
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

  // Method to get shear values based on theta
  void getShearValues(double theta, String shearType) {
    List<Map<String, dynamic>> shearList = shearType == 'General' ? generalShear : localShear;

    for (var entry in shearList) {
      if (entry['theta'] == theta) {
        setState(() {
          nc = entry['nc'];
          nq = entry['nq'];
          ny = entry['ny'];
        });
        return; // Exit the method once the values are found
      }
    }

    // If no matching theta is found, you can set default values or handle it as needed
    nc = nq = ny = null; // or some default values
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

    yc = double.tryParse(inputUnitWeightConcrete.text);
    yw = double.tryParse(inputUnitWeightWater.text);

      // Default values
    fs = double.tryParse(inputFactorSafety.text) ?? 3; // Default to 3 if null

    if (widget.state.concreteDet) {
      if (yc != null) {
        ycFinal = yc;
      } else {
        ycFinal = null;
      }
    } else {
      ycFinal = 24;
    }

    if (widget.state.waterDet) {
      if (yw != null) {
        ywFinal = yw;
      } else {
        ywFinal = null;
      }
    } else {
      ywFinal = 9.81;
    }

      if (df != null && fDim != null && c != null) {
        if (widget.state.soilProp == true) { //if soilProp is on
          if (dw != null) {
            if (dw! >= df!) {
              if (ywFinal != null) {
                if (gs != null && e!= null && w != null) {
                  y = (gs!*ywFinal!*(1+(0.01*w!)))/(1+e!); // final y = y
                  yDry = null;
                  ySat = null;
                  yFinal = y;
                } else if (gs != null && e != null) {
                  y = null;
                  yDry = (gs!*ywFinal!)/(1+e!); // final y = yDry
                  ySat = null;
                  yFinal = yDry; 
                } else {
                  y = null;
                  yDry = null;
                  ySat = null;
                  yFinal = null; // any other option
                }
              } else { // no yw
                y = null;
                yDry = null;
                ySat = null;
                yFinal = null; // any other option
              }
            } else { // Dw < Df
              if (ywFinal != null) {
                hw = df! - dw!;
                uD = hw!*ywFinal!;
                if (gs != null) {
                  if (e != null) {
                    if (w != null) { // Gs, e, w
                      y = (gs!*ywFinal!)/(1+e!);
                      yDry = null; 
                      ySat = (ywFinal!*(gs!+e!))/(1 + e!); // final y = ysat
                      yFinal = ySat;
                    } else { // Gs, e
                      y = (gs!*ywFinal!)/(1+e!);
                      yDry = null; 
                      ySat = (ywFinal!*(gs!+e!))/(1 + e!); // final y = ysat
                      yFinal = ySat;
                    }
                  } else if (w != null) { // Gs, w
                    y = null;
                    yDry = null;
                    ySat = (gs!*ywFinal!*(1+0.01*w!))/(1+(0.01*w!*gs!)); // final y = ysat
                    yFinal = ySat;
                  } else { // Gs
                    y = null;
                    yDry = null;
                    ySat = null;
                    yFinal = null;
                  }
                } else if (e != null && w != null) { // e, w
                  y = null;
                  yDry = null;
                  ySat = ((ywFinal!*e!)/w!)/((1+(0.01*w!))/(1+e!));  // final y = ysat
                  yFinal = ySat;
                } else { // none
                  y = null;
                  yDry = null;
                  ySat = null;
                  yFinal = null;
                }
              } else { // no yw
                y = null;
                yDry = null;
                ySat = null;
                yFinal = null;
              }
            }
          } else {
            if (ywFinal != null) {
              if (gs != null && e!= null && w != null) {
                yFinal = (gs!*ywFinal!*(1+(0.01*w!)))/(1+e!); // final y = y
              } else if (gs != null && e != null) {
                yFinal = (gs!*ywFinal!)/(1+e!);
              } else {
                yFinal = null; // any other option
              }
            } else {
              yFinal = null;
            }
          }
        } else { // if soilProp is off
          if (dw != null) {
            if (dw! != 0) {
              if (dw! >= df!) {
                hw = 0;
                uD = 0;
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
                hw = df! - dw!;
                if (ywFinal != null) {
                  uD = hw!*ywFinal!;
                } else {
                  uD = null;
                }
                if (yDry != null && ySat != null) { // yDry, ySat
                  yFinal = ySat!; // final y = ySat
                } else if (y != null && ySat != null) { // y, ySat
                  yFinal = ySat!; // final y = ySat
                } else { // none
                  yFinal = null; 
                }
              }
            } else {
              hw = 0;
              if (ySat != null) {
                yFinal = ySat!;
              } else {
                yFinal = null;
              }
            }
          } else { // Dw is null
            hw = 0;
            uD = 0;
            if (yDry != null && y != null) {
              yFinal = null;
            } else if (yDry != null) {
              yFinal = yDry!;
            } else if (y != null) {
              yFinal = y!;
            } else {
              yFinal = null;
            }
          }
        }

        if (yFinal != null) {
          rounded_yFinal = roundToFourDecimalPlaces(yFinal!);
        } else {
          rounded_yFinal = null;
        }

        dfPlusB = df! + fDim!;

        if (yFinal != null && ywFinal != null && df != null && fDim != null) {
          if (dw != null) { // Dw is given
            if (dw! <= df!) { // Case 1 for y' and q
              if (hw != null) {
                yPrime = yFinal! - ywFinal!;
                q = yFinal!*df! + yPrime!*hw!;
              } else {
                yPrime = null;
                q = null;
              }
            } else if (dw! >= dfPlusB!) { // Case 3 for y' and q
              yPrime = yFinal!;
              q = yFinal!*df!;
            } else { // Case 2 for y' and q
              yPrime = yFinal! - ywFinal!*(1 - ((dw! - df!)/fDim!));
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

        if (yPrime != null) {
          rounded_yPrime = roundToFourDecimalPlaces(yPrime!);
        } else {
          rounded_yPrime = null;
        }

        if (q != null) {
          rounded_q = roundToFourDecimalPlaces(q!);
        } else {
          rounded_q = null;
        }

        if (widget.state.angleDet == true) {
          if (theta != null) {
            if (theta! >= 0 && theta! <= 50) {
              if (widget.state.selectedShearFailure == 'General') {
                getShearValues(theta ?? 0, 'General');
                if (nc != null && nq != null && ny != null) {
                  if (q != null && yPrime != null) {
                    if (widget.state.selectedFootingType == "Strip or continuous") {
                      qUlt = c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
                    } else if (widget.state.selectedFootingType == "Square") {
                      qUlt = 1.3*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
                    } else { // if circular
                      qUlt = 1.3*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
                    }
                  } else {
                    qUlt = null;
                  }
                }
              } else { // local shear
                getShearValues(theta ?? 0, 'Local');
                if (nc != null && nq != null && ny != null) {
                  if (q != null && yPrime != null) {
                    if (widget.state.selectedFootingType == "Strip or continuous") {
                      qUlt = (2/3)*c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
                    } else if (widget.state.selectedFootingType == "Square") {
                      qUlt = 0.867*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
                    } else { // if circular
                      qUlt = 0.867*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
                    }
                  } else {
                    qUlt = null;
                  }
                }
              }
            } else {
              qUlt = null;
            }
          } else { // no theta
            qUlt = null;
          }
        } else { // Nc, Nq, Ny are given (angleDet = false)
          if (nc != null && nq != null && ny != null) {
            if (widget.state.selectedShearFailure == 'General') {
              if (q != null && yPrime != null) {
                if (widget.state.selectedFootingType == "Strip or continuous") {
                  qUlt = c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
                } else if (widget.state.selectedFootingType == "Square") {
                  qUlt = 1.3*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
                } else { // if circular
                  qUlt = 1.3*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
                }
              } else {
                qUlt = null;
              }
            } else { // local shear
              if (q != null && yPrime != null) {
                if (widget.state.selectedFootingType == "Strip or continuous") {
                  qUlt = (2/3)*c!*nc!+q!*nq!+0.5*yPrime!*fDim!*ny!;
                } else if (widget.state.selectedFootingType == "Square") {
                  qUlt = 0.867*c!*nc!+q!*nq!+0.4*yPrime!*fDim!*ny!;
                } else { // if circular
                  qUlt = 0.867*c!*nc!+q!*nq!+0.3*yPrime!*fDim!*ny!;
                }
              } else {
                qUlt = null;
              }
            }
          } else { // no Nc, Nq and Ny
            qUlt = null;
          }
        }

        if (qUlt != null) {
          rounded_qUlt = roundToFourDecimalPlaces(qUlt!);
        } else {
          rounded_qUlt = null;
        }

        if (selectedFootingType == 'Square') {
          af = fDim!*fDim!;
          widget.state.isItStrip = false;
        } else if (selectedFootingType == 'Circular') {
          af = 0.25*pi*fDim!*fDim!;
          widget.state.isItStrip = false;
        } else { // Strip is selected
          af = null;
          widget.state.isItStrip = true;
        }

        if (af != null) {
          rounded_af = roundToFourDecimalPlaces(af!);
        } else {
          rounded_af = null;
        }

        if (qUlt != null && q != null) {
          qAll = qUlt!/fs!;
          qNetAll = (qUlt! - q!)/fs!;
          qNet = qNetAll!*fs!;
        }

        if (qAll != null) {
          rounded_qAll = roundToFourDecimalPlaces(qAll!);
        } else {
          rounded_qAll = null;
        }

        if (qNetAll != null) {
          rounded_qNetAll = roundToFourDecimalPlaces(qNetAll!);
        } else {
          rounded_qNetAll = null;
        }

        if (q != null && qAll != null) {
          if (t != null && hw != null && ywFinal != null && ycFinal != null) {
            a = df! - hw!;
            b = df! - t! - a!;
            if (af != null) { // square/circular
              sol = 1; // with t, square/circular
              pf = ycFinal!*af!*t!;
              if (y != null && yDry == null) {
                if (dw! < df!) {
                  if (ySat != null) {
                    ps = af!*(y!*a!+ySat!*b!);
                  } else {
                    ps = null;
                  }                  
                } else { // Dw ≥ Df
                  ps = af!*(y!*df!);
                }
              } else { // if no y and there's yDry
                if (dw! < df!) {
                  if (ySat != null) {
                    ps = af!*(yDry!*a!+ySat!*b!);
                  } else {
                    ps = null;
                  }
                } else { // Dw ≥ Df
                  ps = af!*(yDry!*df!);
                }
              }
              p = (af!*(qAll!+ywFinal!*hw!)) - pf! - ps!;              
              p = roundToFourDecimalPlaces(p!);
              udl = 0;
              widget.state.finalAnswerP = p;
              widget.state.finalAnswerUdl = udl;
              setState(() {
                widget.state.showResults = true;
              });
            } else { // strip
              sol = 2; // with t, strip

              pf = ycFinal!*fDim!*t!;

              if (y != null && yDry == null) {
                if (dw! < df!) {
                  ps = fDim!*(y!*a!+ySat!*b!);
                } else { // Dw ≥ Df
                  ps = fDim!*(y!*df!);
                }
              } else { // if no y and there's yDry
                if (dw! < df!) {
                  ps = af!*(yDry!*a!+ySat!*b!);
                } else { // Dw ≥ Df
                  ps = af!*(yDry!*df!);
                }
              }
              p = 0;
              udl = (fDim!*(qUlt!+ywFinal!*hw!)) - pf! - ps!;
              udl = roundToFourDecimalPlaces(udl!);
              widget.state.finalAnswerP = p;
              widget.state.finalAnswerUdl = udl;
              setState(() {
                widget.state.showResults = true;
              });
            }
          } else { // if no t
            if (af != null) { // square/circular
              sol = 3; // no t, square/circular

              p = qAll!*af!;
              p = roundToFourDecimalPlaces(p!);
              udl = 0;
              widget.state.finalAnswerP = p;
              widget.state.finalAnswerUdl = udl;
              setState(() {
                widget.state.showResults = true;
              });
            } else { // strip
              sol = 4; // no t, strip

              p = 0;
              udl = qAll!*fDim!;
              udl = roundToFourDecimalPlaces(udl!);
              widget.state.finalAnswerP = p;
              widget.state.finalAnswerUdl = udl;
              setState(() {
                widget.state.showResults = true;
              });
            }
          }         
        } else {
          setState(() {
            widget.state.showResults = false;
          });
        }

        if (pf != null) {
          rounded_pf = roundToFourDecimalPlaces(pf!);
        } else {
          rounded_pf = null;
        }

        if (ps != null) {
          rounded_ps = roundToFourDecimalPlaces(ps!);
        } else {
          rounded_ps = null;
        }

        if (uD != null) {
          rounded_uD = roundToFourDecimalPlaces(uD!);
        } else {
          rounded_uD = null;
        }
      } else {
        yFinal = null;
      }

    // If input is invalid, hide results and show snackbar
    if (selectedShearFailure == null || selectedFootingType == null || df == null
    || fDim == null || c == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide input for all parameters.'),
          backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        widget.state.showResults = false;
        widget.state.showSolution = false;
        widget.state.solutionToggle = true;
      });
      return;
    } else {
      if (widget.state.soilProp == true) {
        if (gs == null || e == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please provide input for all parameters.'),
              backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
              duration: Duration(seconds: 3),
            ),
          );
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          return;
        }
      } else { // soilProp false
        if (dw != null) {
          if (dw! < df!) {
            if (!((y != null) ^ (yDry != null) && ySat != null)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please provide input for all parameters.'),
                  backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
                  duration: Duration(seconds: 3),
                ),
              );
              setState(() {
                widget.state.showResults = false;
                widget.state.showSolution = false;
                widget.state.solutionToggle = true;
              });
              return;
            } else if ((ySat! < y!) || (ySat! < yDry!)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('γsat must be greater than γ/γdry.'),
                  backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
                  duration: Duration(seconds: 3),
                ),
              );
              setState(() {
                widget.state.showResults = false;
                widget.state.showSolution = false;
                widget.state.solutionToggle = true;
              });
            }
          } else { // if Dw ≥ Df
            if ((y != null && yDry != null) || (y == null && yDry == null)) { 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please provide input for all parameters.'),
                  backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
                  duration: Duration(seconds: 3),
                ),
              );
              setState(() {
                widget.state.showResults = false;
                widget.state.showSolution = false;
                widget.state.solutionToggle = true;
              });
              return;
            }
          }
        } else { // if no Dw
          if ((y != null && yDry != null) || (y == null && yDry == null)) { 
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please provide input for all parameters.'),
                backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
                duration: Duration(seconds: 3),
              ),
            );
            setState(() {
              widget.state.showResults = false;
              widget.state.showSolution = false;
              widget.state.solutionToggle = true;
            });
            return;
          }
        }
      }
      if (widget.state.angleDet == true) {
        if (theta == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please provide input for all parameters.'),
              backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
              duration: Duration(seconds: 3),
            ),
          );
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          return;
        } else {
          if (theta! > 50) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('The angle of internal friction must be from the specified range.'),
                backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
                duration: Duration(seconds: 3),
              ),
            );
            setState(() {
              widget.state.showResults = false;
              widget.state.showSolution = false;
              widget.state.solutionToggle = true;
            });
            return;
          }
        }
      } else { // angleDet == false
        if (nc == null || nq == null || ny == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please provide input for all parameters.'),
              backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
              duration: Duration(seconds: 3),
            ),
          );
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          return;
        }
      }
    }


    // Print the results for debugging
    print("yw = $yw, yc = $yc, yFinal = $yFinal, yPrime = $yPrime, q = $q, showResults = ${widget.state.showResults}");
    print('Nc = $nc, Nq = $nq, Nγ = $ny, qUlt = $qUlt, qAll = $qAll, qNet = $qNet, qAllNet = $qNetAll, P = $p, w = $udl, isGammaSatEnabled = ${widget.state.isGammaSatEnabled}');
    print('isGammaDryEnabled = ${widget.state.isGammaDryEnabled}, isGammaMoistEnabled = ${widget.state.isGammaMoistEnabled}');
    print('af = $af, P = ${widget.state.finalAnswerP}, w = ${widget.state.finalAnswerUdl}, qAll = $qAll, sol = $sol');
    }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF363434),
  // App Bar
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
                      row13yConcreteDet(),
                      row14yConcreteDetOn(),
                    
                      if (widget.state.soilProp)
                        row15yWaterDet(),
                      if (widget.state.soilProp)
                        row16yWaterDetOn(),
                      
                      SizedBox(height: 10),
                      submitButton(),
                      
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
                        solutionContainer(),

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
  }

  Widget clearButton() {
    return ElevatedButton(
      onPressed: () {        
        selectedShearFailure = null;
        selectedFootingType = null;
        inputDepthFoundation.clear();
        inputDepthWater.clear();
        inputFootingBase.clear();
        inputCohesion.clear();
        inputFootingThickness.clear();
        inputFactorSafety.clear();
        inputSpecificGravity.clear();
        inputWaterContent.clear();
        inputVoidRatio.clear();
        inputGammaDry.clear();
        inputGammaMoist.clear();
        inputGammaSat.clear();
        inputAngleFriction.clear();
        inputFactCohesion.clear();
        inputFactOverburden.clear();
        inputFactUnitWeight.clear();
        inputUnitWeightWater.clear();
        inputUnitWeightConcrete.clear();
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
  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        calculateP();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(buttonLabel),
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

  Widget solutionContainer() {
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
// Solution Manager
            if (sol == 1)
              solution1(),
            if (sol == 2)
              solution2(),
            if (sol == 3)
              solution3(),
            if (sol == 4)
              solution4(),
            ],
          ),
        ),
      ),
    );
  }
  Widget solution1() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Most critical γ = $rounded_yFinal kN/m³',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Effective unit weight, γ' = $rounded_yPrime kN/m³",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Surcharge, q = $rounded_q kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nc = $nc",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nq = $nq",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nγ = $ny",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Ultimate soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qult = $rounded_qUlt kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Allowable/gross soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qa = $rounded_qAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Net soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qneta = $rounded_qNetAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Area of footing, Af = $rounded_af m²",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Point load due to weight of footing,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Pf = $rounded_pf kN",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Point load due to weight of soil,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Pₛ = $rounded_ps kN",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Surface load due to weight of water,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "μD = $rounded_uD kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Service load, P = ${widget.state.finalAnswerP} kN",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget solution2() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Most critical γ = $rounded_yFinal kN/m³',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Effective unit weight, γ' = $rounded_yPrime kN/m³",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Surcharge, q = $rounded_q kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nc = $nc",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nq = $nq",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nγ = $ny",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Ultimate soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qult = $rounded_qUlt kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Allowable/gross soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qa = $rounded_qAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Net soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qneta = $rounded_qNetAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Distributed load due to weight of footing,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "wf = $rounded_pf kN/m",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Distributed load due to weight of soil,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "wₛ = $rounded_ps kN/m",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Surface load due to weight of water,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "μD = $rounded_uD kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Service load per meter, w = ${widget.state.finalAnswerUdl} kN",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget solution3() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Most critical γ = $rounded_yFinal kN/m³',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Effective unit weight, γ' = $rounded_yPrime kN/m³",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Surcharge, q = $rounded_q kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nc = $nc",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nq = $nq",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nγ = $ny",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Ultimate soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qult = $rounded_qUlt kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Allowable/gross soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qa = $rounded_qAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Net soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qneta = $rounded_qNetAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Service load, P = ${widget.state.finalAnswerP} kN",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget solution4() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Most critical γ = $rounded_yFinal kN/m³',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Effective unit weight, γ' = $rounded_yPrime kN/m³",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Surcharge, q = $rounded_q kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nc = $nc",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nq = $nq",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Nγ = $ny",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Ultimate soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qult = $rounded_qUlt kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Allowable/gross soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qa = $rounded_qAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Net soil bearing capacity,",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "qneta = $rounded_qNetAll kPa",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Service load per meter, w = ${widget.state.finalAnswerUdl} kN",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  
  Widget resultText() {
    return Visibility(
      visible: widget.state.showResults,
      child: Text(
        '${widget.state.isItStrip ? "w" : "P"} = ${widget.state.isItStrip ? (widget.state.finalAnswerUdl) : (widget.state.finalAnswerP)} ${widget.state.isItStrip ? "kN/m" : "kN"}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold, 
        ),
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
                  enabled: widget.state.isGammaDryEnabled,
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
                  enabled: widget.state.isGammaMoistEnabled,
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
                      FilteringTextInputFormatter.digitsOnly, // Allows only whole numbers
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

  Widget row13yConcreteDet() {
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
  Widget row14yConcreteDetOn() {
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
                row14ayConcrete(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget row14ayConcrete() {
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

  Widget row15yWaterDet() {
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
  Widget row16yWaterDetOn() {
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
                row16ayWater(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget row16ayWater() {
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
  
  


  @override
  void didUpdateWidget(AnalysisPage oldWidget) {
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
} // AnalysisPageState