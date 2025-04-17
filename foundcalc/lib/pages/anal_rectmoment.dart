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
      return "Rectangular Footings with Moment $index"; // Shorter for tab
    }

    return widget.title; 
  }

  late ScrollController _scrollController;

  late TextEditingController inputEte;
  late TextEditingController inputB;
  late TextEditingController inputL;
  late TextEditingController inputC1;
  late TextEditingController inputC2;
  late TextEditingController inputT;
  late TextEditingController inputDf;
  late TextEditingController inputHf;
  late TextEditingController inputDw;

  late TextEditingController inputPDL;
  late TextEditingController inputPLL;
  late TextEditingController inputPUlt;
  
  late TextEditingController inputMDL;
  late TextEditingController inputMLL;
  late TextEditingController inputMUlt;

  late TextEditingController inputHDL;
  late TextEditingController inputHLL;
  late TextEditingController inputHUlt;

  late TextEditingController inputGs;
  late TextEditingController inputE;
  late TextEditingController inputW;

  late TextEditingController inputGammaDry;
  late TextEditingController inputGammaMoist;
  late TextEditingController inputGammaSat;

  late TextEditingController inputFloorLoading;
  late TextEditingController inputFloorThickness;
  late TextEditingController inputOtherUnitWeight;

  late TextEditingController inputYc;
  late TextEditingController inputYw;
  late TextEditingController inputFc;

  late TextEditingController inputTop;
  late TextEditingController inputBot;
  late TextEditingController inputCc;

  double? ete;
  double? b;
  double? l;
  double? c1;
  double? c2;
  double? t;
  double? df;
  double? hf;
  double? dw;

  double? pdl;
  double? pll;
  double? pUlt;

  double? mdl;
  double? mll;
  double? mUlt;

  double? hdl;
  double? hll;
  double? hUlt;

  double? gs;
  double? e;
  double? w;

  double? yDry;
  double? y; 
  double? ySat;

  double? fLoad;
  double? fThick;
  double? yMatInput;

  double? yc;
  double? yw;

  double? dtop;
  double? dbot;
  double? cc;

  // solvar (solution variables)
  double? dcc;
  double? p;
  double? m;
  double? h;
  double? mf;
  double? hMomentArm;
  double? ecc;
  double? eUplift;
  bool? uplift;

  double? pOverBL;
  double? sixMfOverBL2;
  double? qmin;
  double? qmax;
  double? qgmin;
  double? qgmax;
  double? yMat;
  double? qy;
  double? qn;
  double? qo;
  
  // soldesign
  double? depth1;
  double? depth2;
  double? dp;
  double? x3;
  double? q3;

  // for solution container
  double? roundedEcc;
  double? rounded_eUplift;
  double? roundedPoverbl;
  double? roundedSixMfOverBL2;
  double? roundedQmin;
  double? roundedQmax;
  double? roundedQo;
  double? roundedQgmin;
  double? roundedQgmax;

  // for rounding up
  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
  }

  // toggles
  bool isThereUplift = false;

  bool showSolution = false;

  // string getters
  String? loadingCase;
  final List<String> loadingCaseValues = [
    'Axial vertical load (P) only',
    'Axial vertical load (P) and moment (M)',
    'Axial vertical load (P) and lateral force (H)',
  ];

  String? mDirection;
  final List<String> rotations = [
    'Clockwise',
    'Counterclockwise',
  ];

  String? hDirection;
  final List<String> directions = [
    'To the left',
    'To the right',
  ];

  String? material;
  final List<String> materials = [
    'Concrete',
    'Others',
  ];

  String? modFactor;
  final List<String> modFactorValues = [
    'All-lightweight',
    'Sand-lightweight',
    'Normal-lightweight',
  ];

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

  String get gammaSatHint {
    if (widget.state.isGammaSatEnabled) {
      return 'Input required';
    } else {
      return 'Input not required';
    }
  }

  String get soilPropOffHeaderrr {
    if (widget.state.isGammaSatEnabled) {
      return 'Input only two (2)';
    } else {
      return 'Input only one (1)';
    }
  }

  String get solutionButtonLabelAnalysis {
    if (widget.state.showSolutionAnalysis) {
      return 'Hide solution';
    } else {
      return 'View solution';
    }
  }

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    inputEte = TextEditingController(text: widget.state.inputEte);
    inputB = TextEditingController(text: widget.state.inputB);
    inputL = TextEditingController(text: widget.state.inputL);
    inputC1 = TextEditingController(text: widget.state.inputC1);
    inputC2 = TextEditingController(text: widget.state.inputC2);
    inputT = TextEditingController(text: widget.state.inputT);
    inputDf = TextEditingController(text: widget.state.inputDf);
    inputHf = TextEditingController(text: widget.state.inputHf);
    inputDw = TextEditingController(text: widget.state.inputDw);

    inputPDL = TextEditingController(text: widget.state.inputPDL);
    inputPLL = TextEditingController(text: widget.state.inputPLL);
    inputPUlt = TextEditingController(text: widget.state.inputPUlt);

    inputMDL = TextEditingController(text: widget.state.inputMDL);
    inputMLL = TextEditingController(text: widget.state.inputMLL);
    inputMUlt = TextEditingController(text: widget.state.inputMUlt);

    inputHDL = TextEditingController(text: widget.state.inputHDL);
    inputHLL = TextEditingController(text: widget.state.inputHLL);
    inputHUlt = TextEditingController(text: widget.state.inputHUlt);

    inputGs = TextEditingController(text: widget.state.inputGs);
    inputE = TextEditingController(text: widget.state.inputE);
    inputW = TextEditingController(text: widget.state.inputW);

    inputGammaDry = TextEditingController(text: widget.state.inputGammaDry);
    inputGammaMoist = TextEditingController(text: widget.state.inputGammaMoist);
    inputGammaSat = TextEditingController(text: widget.state.inputGammaSat);
    
    inputFloorLoading = TextEditingController(text: widget.state.inputFloorLoading);
    inputFloorThickness = TextEditingController(text: widget.state.inputFloorThickness);
    inputOtherUnitWeight = TextEditingController(text: widget.state.inputOtherUnitWeight);
    
    inputYc = TextEditingController(text: widget.state.inputYc);
    inputYw = TextEditingController(text: widget.state.inputYw);
    inputFc = TextEditingController(text: widget.state.inputFc);

    inputTop = TextEditingController(text: widget.state.inputTop);
    inputBot = TextEditingController(text: widget.state.inputBot);
    inputCc = TextEditingController(text: widget.state.inputCc);

    // for dropdowns

    modFactor = "Normal-lightweight"; // Set default value here
    widget.state.modFactor = modFactor; // Update the state

    loadingCase = widget.state.loadingCase;
    mDirection = widget.state.mDirection;
    hDirection = widget.state.hDirection;

    // listeners

    inputEte.addListener(_updateState);
    inputB.addListener(_updateState);
    inputL.addListener(_updateState);
    inputC1.addListener(_updateState);
    inputC2.addListener(_updateState);
    inputT.addListener(_updateState);
    inputDf.addListener(_updateState);
    inputHf.addListener(_updateState);
    inputDw.addListener(_updateState);

    inputPDL.addListener(_updateState);
    inputPLL.addListener(_updateState);
    inputPUlt.addListener(_updateState);

    inputMDL.addListener(_updateState);
    inputMLL.addListener(_updateState);
    inputMUlt.addListener(_updateState);

    inputHDL.addListener(_updateState);
    inputHLL.addListener(_updateState);
    inputHUlt.addListener(_updateState);

    inputGs.addListener(_updateState);
    inputE.addListener(_updateState);
    inputW.addListener(_updateState);

    inputGammaDry.addListener(_updateState);
    inputGammaMoist.addListener(_updateState);
    inputGammaSat.addListener(_updateState);

    inputFloorLoading.addListener(_updateState);
    inputFloorThickness.addListener(_updateState);
    inputOtherUnitWeight.addListener(_updateState);

    inputYc.addListener(_updateState);  
    inputYw.addListener(_updateState);
    inputFc.addListener(_updateState);

    inputTop.addListener(_updateState);
    inputBot.addListener(_updateState);
    inputCc.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      widget.state.inputEte = inputEte.text;
      widget.state.inputB = inputB.text;
      widget.state.inputL = inputL.text;
      widget.state.inputC1 = inputC1.text;
      widget.state.inputC2 = inputC2.text;
      widget.state.inputT = inputT.text;
      widget.state.inputDf = inputDf.text;
      widget.state.inputHf = inputHf.text;
      widget.state.inputDw = inputDw.text;

      widget.state.inputPDL = inputPDL.text;
      widget.state.inputPLL = inputPLL.text;
      widget.state.inputPUlt = inputPUlt.text;

      widget.state.inputMDL = inputMDL.text;
      widget.state.inputMLL = inputMLL.text;
      widget.state.inputMUlt = inputMUlt.text;

      widget.state.inputHDL = inputHDL.text;
      widget.state.inputHLL = inputHLL.text;
      widget.state.inputHUlt = inputHUlt.text;

      widget.state.inputGs = inputGs.text;
      widget.state.inputE = inputE.text;
      widget.state.inputW = inputW.text;

      widget.state.inputGammaDry = inputGammaDry.text;
      widget.state.inputGammaMoist = inputGammaMoist.text;
      widget.state.inputGammaSat = inputGammaSat.text;

      widget.state.inputFloorLoading = inputFloorLoading.text;
      widget.state.inputFloorThickness = inputFloorThickness.text;
      widget.state.inputOtherUnitWeight = inputOtherUnitWeight.text;

      widget.state.inputYc = inputYc.text;     
      widget.state.inputYw = inputYw.text;
      widget.state.inputFc = inputFc.text;

      widget.state.inputTop = inputTop.text;
      widget.state.inputBot = inputBot.text;
      widget.state.inputCc = inputCc.text;

      df = double.tryParse(inputDf.text);
      dw = double.tryParse(inputDw.text);

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
        widget.state.isGammaMoistEnabled = false;
      } else {
        widget.state.isGammaMoistEnabled = true;
      }

      if (y != null) {
        widget.state.isGammaDryEnabled = false;
      } else {
        widget.state.isGammaDryEnabled = true;
      }

      //calcQ();

      widget.onStateChanged(widget.state);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    inputEte.dispose();
    inputB.dispose();
    inputL.dispose();
    inputC1.dispose();
    inputC2.dispose();
    inputT.dispose();
    inputDf.dispose();
    inputDw.dispose();

    inputPDL.dispose();
    inputPLL.dispose();
    inputPUlt.dispose();

    inputMDL.dispose();
    inputMLL.dispose();
    inputMUlt.dispose();

    inputHDL.dispose();
    inputHLL.dispose();
    inputHUlt.dispose();

    inputGs.dispose();
    inputE.dispose();
    inputW.dispose();

    inputGammaDry.dispose();
    inputGammaMoist.dispose();
    inputGammaSat.dispose();

    inputYc.dispose();
    inputYw.dispose();
    inputFc.dispose();

    inputTop.dispose();
    inputBot.dispose();
    inputCc.dispose();

    super.dispose();
  }

  void calcAnalysis() {
    ete = double.tryParse(inputEte.text);
    b = double.tryParse(inputB.text);
    l = double.tryParse(inputL.text);
    c1 = double.tryParse(inputC1.text);
    c2 = double.tryParse(inputC2.text);
    df = double.tryParse(inputDf.text);
    hf = double.tryParse(inputHf.text);
    dw = double.tryParse(inputDw.text);
    t = double.tryParse(inputT.text);

    pdl = double.tryParse(inputPDL.text);
    pll = double.tryParse(inputPLL.text);
    pUlt = double.tryParse(inputPUlt.text);
    
    mdl = double.tryParse(inputMDL.text);
    mll = double.tryParse(inputMLL.text);
    mUlt = double.tryParse(inputMUlt.text);

    hdl = double.tryParse(inputHDL.text);
    hll = double.tryParse(inputHLL.text);
    hUlt = double.tryParse(inputHUlt.text);

    yMatInput = double.tryParse(inputOtherUnitWeight.text);
    fLoad = double.tryParse(inputFloorLoading.text);
    fThick = double.tryParse(inputFloorThickness.text);

      // Default values
    yw = double.tryParse(inputYw.text) ?? 9.81; // Default to 9.81 if null
    yc = double.tryParse(inputYc.text) ?? 24; // Default to 24 if null
    cc = double.tryParse(inputCc.text) ?? 75; // Default to 3 if null
    
    // moment arm of P
    if (ete != null && l != null && c2 != null) {
      dcc = 0.5*l!-ete!-0.5*c2!;
    } else {
      dcc = null;
    }
    
    if (loadingCase == 'Axial vertical load (P) only') {
      if (widget.state.toggleP) { // load combi
        if (pdl != null && pll != null) {
          p = 1.2*pdl! + 1.6*pll!;  
        } else {
          p = null;
        }
      } else { // no load combi
        if (pUlt != null) {
          p = pUlt!;  
        } else {
          p = null;
        }
      }
    } else if (loadingCase == 'Axial vertical load (P) and moment (M)') {
      if (widget.state.toggleP) { // load combi
        if (pdl != null && pll != null) {
          p = 1.2*pdl! + 1.6*pll!;  
        } else {
          p = null;
        }
      } else { // no load combi
        if (pUlt != null) {
          p = pUlt!;  
        } else {
          p = null;
        }
      }
      if (widget.state.toggleM) { // load combi
        if (mdl != null && mll != null) {
          m = 1.2*mdl! + 1.6*mll!;  
        } else {
          m = null;
        }
      } else { // no load combi
        if (mUlt != null) {
          m = mUlt!;  
        } else {
          m = null;
        }
      }
    } else if (loadingCase == 'Axial vertical load (P) and lateral force (H)') {
      if (widget.state.toggleP) { // load combi
        if (pdl != null && pll != null) {
          p = 1.2*pdl! + 1.6*pll!;  
        } else {
          p = null;
        }
      } else { // no load combi
        if (pUlt != null) {
          p = pUlt!;  
        } else {
          p = null;
        }
      }
      if (widget.state.toggleH) { // load combi
        if (hdl != null && hll != null) {
          h = 1.2*hdl! + 1.6*hll!;  
        } else {
          h = null;
        }
      } else { // no load combi
        if (hUlt != null) {
          h = hUlt!;  
        } else {
          h = null;
        }
      }
    }

    if (p != null && dcc != null) {
      if (loadingCase == 'Axial vertical load (P) only') {
        mf = p!*dcc!;
      } else if (loadingCase == 'Axial vertical load (P) and moment (M)') {
        if (m != null) {
          if (mDirection == 'Clockwise') {
            mf = (m! - p!*dcc!).abs();
          } else if (mDirection == 'Counterclockwise') {
            mf = m! + p!*dcc!;
          } else { // null
            mf = null;
          }
        } else {
          mf = null;
        }
      } else if (loadingCase == 'Axial vertical load (P) and lateral force (H)') {
        // computation of moment arm of H
        if (hf != null && t != null) {
          hMomentArm = hf! - t!;
        } else {
          hMomentArm = null;
        }

        if (hMomentArm != null && h != null) {
          if (hDirection == 'To the left') {
            mf = p! + h!*hMomentArm!;
          } else if (hDirection == 'To the right') {
            mf = (p! - h!*hMomentArm!).abs();
          } else { // null
            mf = null;
          }  
        }
      }  
    } else {
      mf = null;
    }
    
    // eccentricity
    if (mf != null && p != null) {
      ecc = mf!/p!;
      roundedEcc = roundToFourDecimalPlaces(ecc!);
    } else {
      ecc = null;
      roundedEcc = null;
    }

    // to check for uplift
    if (l != null) {
      eUplift = l!/6;
      rounded_eUplift = roundToFourDecimalPlaces(eUplift!);
    } else {
      eUplift = null;
      rounded_eUplift = null;
    }

    if (ecc != null && eUplift != null) {
      if (ecc! < eUplift!) { // no uplift, continue solution
        uplift = false;
        setState(() {
          isThereUplift = false;
        });
      } else { // stop solution
        uplift = true;
        setState(() {
          isThereUplift = true;
        });
      }
    } else {
      uplift = null;
    }

    // q1 and q2
    if (uplift == false) {
      if (p != null && b != null && l != null && mf!= null) {
        pOverBL = (p!/(l!*b!));
        sixMfOverBL2 = (6*mf!)/(b!*l!*l!);

        roundedPoverbl = roundToFourDecimalPlaces(pOverBL!);
        roundedSixMfOverBL2 = roundToFourDecimalPlaces(sixMfOverBL2!);

        qmin = (p!/(l!*b!)) - (6*mf!)/(b!*l!*l!);
        qmax = (p!/(l!*b!)) + (6*mf!)/(b!*l!*l!);

        roundedQmin = roundToFourDecimalPlaces(qmin!);
        roundedQmax = roundToFourDecimalPlaces(qmax!);
      } else {
        qmin = null;
        qmax = null;

        roundedPoverbl = null;
        roundedSixMfOverBL2 = null;

        roundedQmin = null;
        roundedQmax = null;
      }
    }

    if (widget.state.soilProp) { // Soil Prop is ON
      if (gs != null && e != null && w != null) {
        y = ((gs!*yw!)*(1+w!))/(1+e!);
      } else if (gs != null && e != null) {
        y = (gs!*yw!)/(1+e!);
      } else {
        y = null;
      }
    } else { // Soil Prop is OFF
      if (y != null && yDry == null) {
        y = y;
      } else if (y == null && yDry != null) {
        y = yDry;
      } else {
        y = null;
      }
    }

    // pressure due to soil
    if (df != null && t != null && y != null) {
      if (dw != null) {
        if (dw! < df!) {
          if (ySat != null) {
            qy = yc!*t!+y!*dw!+ySat!*(df!-dw!-t!);
          } else {
            qy = null;
          }
        } else {
          qy = yc!*t!+y!*(df!-t!);
        }
      } else {
        qy = yc!*t!+y!*(df!-t!);
      }
    } else {
      qy = null;
    }

    // qo
    if (widget.state.weightPressures) { // pressure due to other weight pressures
      if (widget.state.material == 'Concrete') {
        yMat = yc!;
      } else { // others
        if (yMatInput != null) {
          yMat = yMatInput!;
        } else {
          yMat = null;
        }
      }
      if (fLoad != null && yMat != null && fThick != null && qy != null) {
        qo = fLoad! + yMat!*(fThick!/1000) + qy!;
        roundedQo = roundToFourDecimalPlaces(qo!);
      } else {
        qo = null;
        roundedQo = null;
      }
    } else { // no weight pressures
      if (qy != null) {
        qo = qy!;
        roundedQo = roundToFourDecimalPlaces(qo!);
      } else {
        qo = null;
        roundedQo = null;
      }     
    }
    
    if (qmin != null && qmax != null && qo != null) {
      qgmin = qmin! + qo!;
      qgmax = qmax! + qo!;

      roundedQgmin = roundToFourDecimalPlaces(qgmin!);
      roundedQgmax = roundToFourDecimalPlaces(qgmax!);

      widget.state.finalQgmin = roundedQgmin;
      widget.state.finalQgmax = roundedQgmax;
    } else {
      qgmin = null;
      qgmax = null;
      roundedQgmin = null;
      roundedQgmax = null;
      widget.state.finalQgmin = null;
      widget.state.finalQgmax = null;
    }

    if (uplift == false) {
      if (widget.state.finalQgmin != null && widget.state.finalQgmax != null) {
        setState(() {
          widget.state.showResultsAnalysis = true;
        });
      } else {
        setState(() {
          widget.state.showResultsAnalysis = false;
        });
      }
    } else if (uplift == true) {
      setState(() {
          widget.state.showResultsAnalysis = true;
      });
    } else { // uplift = null
      setState(() {
        widget.state.showResultsAnalysis = false;
      });
    }

    print('''
      dcc = $dcc,
      P = $p,
      M = $m,
      H = $h,
      mf = $mf,
      ecc = $ecc,
      eUplift = $eUplift,
      uplift = $uplift,
      qmin = $qmin,
      qmax = $qmax,
      qy = $qy,
      qn = $qn,
      qo = $qo,
      qgmin = $qgmin,
      qgmax = $qgmax,
    ''');

    // Only show the result if all inputs are valid and an operation is selected
    /*
    setState(() {
      showResults = true;
    });
    */
    /*
    double q = 325.4927;
    double col = 0.5;
    double F = sqrt(24);
    double L = 1;
    double B = 3.575;

    double a = -(q + 990*L*F);
    double b_quad = -(4000*q*col + 1980000*L*F*col);
    double c = 4000000*q*((B*B)-(col*col));

    double d = (-b_quad - sqrt((b_quad*b_quad)-(4*a*c)))/(2*a);
    print('d = $d');
    */
  }  // calcAnalysis
  void calcDesign() {
    ete = double.tryParse(inputEte.text);
    b = double.tryParse(inputB.text);
    l = double.tryParse(inputL.text);
    c1 = double.tryParse(inputC1.text);
    c2 = double.tryParse(inputC2.text);
    df = double.tryParse(inputDf.text);
    hf = double.tryParse(inputHf.text);
    dw = double.tryParse(inputDw.text);
    t = double.tryParse(inputT.text);

    pdl = double.tryParse(inputPDL.text);
    pll = double.tryParse(inputPLL.text);
    pUlt = double.tryParse(inputPUlt.text);
    
    mdl = double.tryParse(inputMDL.text);
    mll = double.tryParse(inputMLL.text);
    mUlt = double.tryParse(inputMUlt.text);

    hdl = double.tryParse(inputHDL.text);
    hll = double.tryParse(inputHLL.text);
    hUlt = double.tryParse(inputHUlt.text);

    yMatInput = double.tryParse(inputOtherUnitWeight.text);
    fLoad = double.tryParse(inputFloorLoading.text);
    fThick = double.tryParse(inputFloorThickness.text);

    dtop = double.tryParse(inputTop.text);
    dbot = double.tryParse(inputBot.text);

      // Default values
    yw = double.tryParse(inputYw.text) ?? 9.81; // Default to 9.81 if null
    yc = double.tryParse(inputYc.text) ?? 24; // Default to 24 if null
    cc = double.tryParse(inputCc.text) ?? 75; // Default to 3 if null
    
    // moment arm of P
    if (ete != null && l != null && c2 != null) {
      dcc = 0.5*l!-ete!-0.5*c2!;
    } else {
      dcc = null;
    }
    
    if (loadingCase == 'Axial vertical load (P) only') {
      if (widget.state.toggleP) { // load combi
        if (pdl != null && pll != null) {
          p = 1.2*pdl! + 1.6*pll!;  
        } else {
          p = null;
        }
      } else { // no load combi
        if (pUlt != null) {
          p = pUlt!;  
        } else {
          p = null;
        }
      }
    } else if (loadingCase == 'Axial vertical load (P) and moment (M)') {
      if (widget.state.toggleP) { // load combi
        if (pdl != null && pll != null) {
          p = 1.2*pdl! + 1.6*pll!;  
        } else {
          p = null;
        }
      } else { // no load combi
        if (pUlt != null) {
          p = pUlt!;  
        } else {
          p = null;
        }
      }
      if (widget.state.toggleM) { // load combi
        if (mdl != null && mll != null) {
          m = 1.2*mdl! + 1.6*mll!;  
        } else {
          m = null;
        }
      } else { // no load combi
        if (mUlt != null) {
          m = mUlt!;  
        } else {
          m = null;
        }
      }
    } else if (loadingCase == 'Axial vertical load (P) and lateral force (H)') {
      if (widget.state.toggleP) { // load combi
        if (pdl != null && pll != null) {
          p = 1.2*pdl! + 1.6*pll!;  
        } else {
          p = null;
        }
      } else { // no load combi
        if (pUlt != null) {
          p = pUlt!;  
        } else {
          p = null;
        }
      }
      if (widget.state.toggleH) { // load combi
        if (hdl != null && hll != null) {
          h = 1.2*hdl! + 1.6*hll!;  
        } else {
          h = null;
        }
      } else { // no load combi
        if (hUlt != null) {
          h = hUlt!;  
        } else {
          h = null;
        }
      }
    }

    if (p != null && dcc != null) {
      if (loadingCase == 'Axial vertical load (P) only') {
        mf = p!*dcc!;
      } else if (loadingCase == 'Axial vertical load (P) and moment (M)') {
        if (m != null) {
          if (mDirection == 'Clockwise') {
            mf = (m! - p!*dcc!).abs();
          } else if (mDirection == 'Counterclockwise') {
            mf = m! + p!*dcc!;
          } else { // null
            mf = null;
          }
        } else {
          mf = null;
        }
      } else if (loadingCase == 'Axial vertical load (P) and lateral force (H)') {
        // computation of moment arm of H
        if (hf != null && t != null) {
          hMomentArm = hf! - t!;
        } else {
          hMomentArm = null;
        }

        if (hMomentArm != null && h != null) {
          if (hDirection == 'To the left') {
            mf = p! + h!*hMomentArm!;
          } else if (hDirection == 'To the right') {
            mf = (p! - h!*hMomentArm!).abs();
          } else { // null
            mf = null;
          }  
        }
      }  
    } else {
      mf = null;
    }
    
    // eccentricity
    if (mf != null && p != null) {
      ecc = mf!/p!;
      roundedEcc = roundToFourDecimalPlaces(ecc!);
    } else {
      ecc = null;
      roundedEcc = null;
    }

    // to check for uplift
    if (l != null) {
      eUplift = l!/6;
      rounded_eUplift = roundToFourDecimalPlaces(eUplift!);
    } else {
      eUplift = null;
      rounded_eUplift = null;
    }

    if (ecc != null && eUplift != null) {
      if (ecc! < eUplift!) { // no uplift, continue solution
        uplift = false;
        setState(() {
          isThereUplift = false;
        });
      } else { // stop solution
        uplift = true;
        setState(() {
          isThereUplift = true;
        });
      }
    } else {
      uplift = null;
    }

    // q1 and q2
    if (uplift == false) {
      if (p != null && b != null && l != null && mf!= null) {
        pOverBL = (p!/(l!*b!));
        sixMfOverBL2 = (6*mf!)/(b!*l!*l!);

        roundedPoverbl = roundToFourDecimalPlaces(pOverBL!);
        roundedSixMfOverBL2 = roundToFourDecimalPlaces(sixMfOverBL2!);

        qmin = (p!/(l!*b!)) - (6*mf!)/(b!*l!*l!);
        qmax = (p!/(l!*b!)) + (6*mf!)/(b!*l!*l!);

        roundedQmin = roundToFourDecimalPlaces(qmin!);
        roundedQmax = roundToFourDecimalPlaces(qmax!);
      } else {
        qmin = null;
        qmax = null;

        roundedPoverbl = null;
        roundedSixMfOverBL2 = null;

        roundedQmin = null;
        roundedQmax = null;
      }
    }

    if (widget.state.soilProp) { // Soil Prop is ON
      if (gs != null && e != null && w != null) {
        y = ((gs!*yw!)*(1+w!))/(1+e!);
      } else if (gs != null && e != null) {
        y = (gs!*yw!)/(1+e!);
      } else {
        y = null;
      }
    } else { // Soil Prop is OFF
      if (y != null && yDry == null) {
        y = y;
      } else if (y == null && yDry != null) {
        y = yDry;
      } else {
        y = null;
      }
    }

    // pressure due to soil
    if (df != null && t != null && y != null) {
      if (dw != null) {
        if (dw! < df!) {
          if (ySat != null) {
            qy = yc!*t!+y!*dw!+ySat!*(df!-dw!-t!);
          } else {
            qy = null;
          }
        } else {
          qy = yc!*t!+y!*(df!-t!);
        }
      } else {
        qy = yc!*t!+y!*(df!-t!);
      }
    } else {
      qy = null;
    }

    // qo
    if (widget.state.weightPressures) { // pressure due to other weight pressures
      if (widget.state.material == 'Concrete') {
        yMat = yc!;
      } else { // others
        if (yMatInput != null) {
          yMat = yMatInput!;
        } else {
          yMat = null;
        }
      }
      if (fLoad != null && yMat != null && fThick != null && qy != null) {
        qo = fLoad! + yMat!*(fThick!/1000) + qy!;
        roundedQo = roundToFourDecimalPlaces(qo!);
      } else {
        qo = null;
        roundedQo = null;
      }
    } else { // no weight pressures
      if (qy != null) {
        qo = qy!;
        roundedQo = roundToFourDecimalPlaces(qo!);
      } else {
        qo = null;
        roundedQo = null;
      }     
    }
    
    if (qmin != null && qmax != null && qo != null) {
      qgmin = qmin! + qo!;
      qgmax = qmax! + qo!;

      roundedQgmin = roundToFourDecimalPlaces(qgmin!);
      roundedQgmax = roundToFourDecimalPlaces(qgmax!);
    } else {
      qgmin = null;
      qgmax = null;

      roundedQgmin = null;
      roundedQgmax = null;
    }

    if (widget.state.topToggle) {
      dtop = dtop;
    } else {
      dtop = 20;
    }

    if (widget.state.botToggle) {
      dbot = dbot;
    } else {
      dbot = 20;
    }

    if (t != null) {
      depth1 = (t!*1000) - cc! - 0.5*dbot!;
      depth2 = (t!*1000) - cc! - dbot! - 0.5*dtop!;
      dp = (depth1! + depth2!)/2;
    } else {
      depth1 = null;
      depth2 = null;
      dp = null;
    }

    if (l != null && dcc != null) {
      x3 = 0.5*l! - dcc! + 0.5*c2! + depth1!;
    } else {
      x3 = null;
    }

    if (x3 != null && qmin != null && qmax != null && l != null) {
      q3 = qmin! + (x3!*(qmax!-qmin!))/l!;
    } else {
      q3 = null;
    }

    /*
    if (uplift == false) {
      if (widget.state.finalQgmin != null && widget.state.finalQgmax != null) {
        setState(() {
          widget.state.showResultsAnalysis = true;
        });
      } else {
        setState(() {
          widget.state.showResultsAnalysis = false;
        });
      }
    } else if (uplift == true) {
      setState(() {
          widget.state.showResultsAnalysis = true;
      });
    } else { // uplift = null
      setState(() {
        widget.state.showResultsAnalysis = false;
      });
    }
    */

    print('''
      dcc = $dcc,
      P = $p,
      M = $m,
      H = $h,
      mf = $mf,
      ecc = $ecc,
      eUplift = $eUplift,
      uplift = $uplift,
      qmin = $qmin,
      qmax = $qmax,
      qy = $qy,
      qn = $qn,
      qo = $qo,
      qgmin = $qgmin,
      qgmax = $qgmax,
    ''');
  }  // calcAnalysis
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build
    return Scaffold(
      backgroundColor: Color(0xFF363434),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Increase height to accommodate two lines
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0), // Add vertical padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the text vertically
              children: [
                SizedBox(height: 30),
                Text(
                  'Analysis and Design of',
                  style: TextStyle(color: Colors.white, fontSize: 20), // Adjust font size as needed
                  textAlign: TextAlign.center, // Center the text
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    displayTitle,
                    style: TextStyle(color: Colors.white, fontSize: 20), // Smaller font for the second line
                    textAlign: TextAlign.center, // Center the text
                  ),
                )
                
              ],
            ),
          ),
          backgroundColor: Color(0xFF363434),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
        ),
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
                      headerAnalysis(),
                      dropdownLoadingCase(),
                      entryEte(),
                      entryB(),
                      entryL(),
                      entryC2(),
                      entryT(),
                      entryDf(),
                      if (loadingCase == 'Axial vertical load (P) and lateral force (H)')
                        entryHf(),
                      entryDw(),

                      if (loadingCase == 'Axial vertical load (P) only' || loadingCase == 'Axial vertical load (P) and moment (M)' || loadingCase == 'Axial vertical load (P) and lateral force (H)')
                        switchP(),
                      if (loadingCase == 'Axial vertical load (P) only' || loadingCase == 'Axial vertical load (P) and moment (M)' || loadingCase == 'Axial vertical load (P) and lateral force (H)')
                        Stack(
                          children: [
                            containerPOn(),
                            containerPOff(),
                          ]
                        ),

                      if (loadingCase == 'Axial vertical load (P) and moment (M)')
                        switchM(), // subdropdownM(),
                      if (loadingCase == 'Axial vertical load (P) and moment (M)')
                        subdropdownM(),
                      if (loadingCase == 'Axial vertical load (P) and moment (M)')
                        Stack(
                          children: [
                            containerMOn(),
                            containerMOff(),
                          ]
                        ),

                      if (loadingCase == 'Axial vertical load (P) and lateral force (H)')
                        switchH(),
                      if (loadingCase == 'Axial vertical load (P) and lateral force (H)')
                        subdropdownH(),  
                      if (loadingCase == 'Axial vertical load (P) and lateral force (H)')
                        Stack(
                          children: [
                            containerHOn(),
                            containerHOff(),
                          ]
                        ),

                      switchSoilProp(),
                      Stack(
                        children: [
                          containerSoilPropOn(),
                          containerSoilPropOff(),
                        ]
                      ),

                      switchWP(),
                      containerWPOn(),

                      switchConcreteDet(),
                      containerConcreteOn(),

                      if (widget.state.soilProp)
                        switchWaterDet(),
                      if (widget.state.soilProp)
                        containerWaterOn(),

                      buttonAnalysis(),
                      SizedBox(height: 10),

                      if (widget.state.showResultsAnalysis)
                        resultAnalysis(),

                      SizedBox(height: 10),
                      if (widget.state.showResultsAnalysis)
                        solutionButtonAnalysis(),
                      if (widget.state.showSolutionAnalysis)
                        solutionContainerAnalysis(),

                      // design widgets
                      switchDesign(),
                      if (widget.state.design)
                        headerDesign(),
                      if (widget.state.design)
                        dropdownModFactor(),
                      if (widget.state.design)
                        entryFc(),

                      if (widget.state.design)
                        switchTop(),
                      if (widget.state.design)
                        containerTop(),

                      if (widget.state.design)
                        switchBot(),
                      if (widget.state.design)
                        containerBot(),

                      if (widget.state.design)
                        switchCC(),
                      if (widget.state.design)
                        containerCC(),

                      if (widget.state.design)
                        buttonDesign(),
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
  Widget headerAnalysis() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Analysis',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget dropdownLoadingCase() {
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
                'Select loading case:',
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
                value: loadingCase,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    loadingCase = newValue;
                    });
                  },
                items: loadingCaseValues.map((String value) {
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
  } // dropdownLoadingCase
  Widget entryEte() {
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
                  'Shortest distance between the edge of column and the shorter side of footing (in m):',
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
                    controller: inputEte,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
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
                          inputEte.clear();
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
  } // entryEte
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
                  'Transverse dimension of footing, B (in m):',
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
                    controller: inputB, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                  'Longitudinal dimension of footing, L (in m):',
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
                    controller: inputL, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
  //
  Widget entryC1() {
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
                  'Dimension of column parallel to B, C1 (in m)',
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
                    controller: inputC1, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputC1.clear();
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
  } // entryC1
  //
  Widget entryC2() {
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
                  'Dimension of column parallel to L, C2 (in m)',
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
                    controller: inputC2, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputC2.clear();
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
  } // entryC2
  Widget entryT() {
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
                  'Thickness of footing, T (in m):',
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
                    controller: inputT, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputT.clear();
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
  } // entryT
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
                  height: 40, // Adjust height as needed
                  child: TextField(
                    controller: inputDf, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
  Widget entryHf() {
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
                  'Height of foundation (top of column to bottom of footing), hf (in m):',
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
                    controller: inputDf, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
  } // entryHf
  Widget entryDw() {
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
                    controller: inputDw, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputDw.clear();
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
  } // entryDw
  
  Widget switchP() {
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
                  'Load combination for P',
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
                    value: widget.state.toggleP,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.toggleP = newValue;
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
  } // switchP
  
  Widget containerPOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.toggleP,
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
                subPDL(),
                subPLL(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerPOn
  Widget subPDL() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'PDL (in kN):',
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
                  controller: inputPDL,
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
                        inputPDL.clear();
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
  } // subPDL
  Widget subPLL() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'PLL (in kN):',
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
                  controller: inputPLL,
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
                        inputPLL.clear();
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
  } // subPLL
  
  Widget containerPOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.toggleP,
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
                  subPUlt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget subPUlt() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Value of axial vertical load, P (in kN):',
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
                  controller: inputPUlt,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Input required',
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
                        inputPUlt.clear();
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
  
  Widget switchM() {
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
                  'Load combination for M',
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
                    value: widget.state.toggleM,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.toggleM = newValue;
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
  } // switchM
  Widget subdropdownM() {
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
                'Rotation of moment:',
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
                value: mDirection,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    mDirection = newValue;
                    widget.state.mDirection = newValue;
                  });
                },
                items: rotations.map((String value) {
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
  } // subdropdownM
  Widget containerMOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.toggleM,
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
                subMDL(),
                subMLL(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerMOn
  Widget subMDL() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'MDL (in kN-m):',
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
                  controller: inputMDL,
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
                        inputMDL.clear();
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
  } // subMDL
  Widget subMLL() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'MLL (in kN-m):',
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
                  controller: inputMLL,
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
                        inputMLL.clear();
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
  } // subMLL
  
  Widget containerMOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.toggleM,
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
                  subMUlt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // containerMOff
  Widget subMUlt() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Value of moment, M (in kN-m):',
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
                  controller: inputMUlt,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Input required',
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
                        inputMUlt.clear();
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
  } // subMUlt
  
  Widget switchH() {
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
                  'Load combination for H',
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
                    value: widget.state.toggleH,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.toggleH = newValue;
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
  } // switchH
  Widget subdropdownH() {
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
                'Direction of lateral force:',
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
                value: hDirection,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    hDirection = newValue;
                    widget.state.hDirection = newValue;
                  });
                },
                items: directions.map((String value) {
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
  } // subdropdownH
  Widget containerHOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.toggleH,
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
                subHDL(),
                subHLL(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerHOn
  Widget subHDL() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'HDL (in kN):',
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
                  controller: inputHDL,
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
                        inputHDL.clear();
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
  } // subHDL
  Widget subHLL() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'HLL (in kN):',
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
                  controller: inputHLL,
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
                        inputHLL.clear();
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
  } // subHLL
  
  Widget containerHOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.toggleH,
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
                  subHUlt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // containerHOff
  Widget subHUlt() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Value of lateral load, H (in kN):',
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
                  controller: inputHUlt,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows only numbers and one decimal point
                    ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Input required',
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
                        inputHUlt.clear();
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
  } // subMUlt

  Widget switchSoilProp() {
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
  } // switchSoilProp

  Widget containerSoilPropOn() {
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
                subGs(),
                subVoidRatio(),
                subWaterContent(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerSoilPropOn
  Widget subGs() {
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
                  controller: inputGs,
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
                        inputGs.clear();
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
  } // subGs
  Widget subVoidRatio() {
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
                  controller: inputE,
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
                        inputE.clear();
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
  } // subVoidRatio
  Widget subWaterContent() {
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
                  controller: inputW,
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
                        inputW.clear();
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
  } // subWaterContent
  
   Widget switchWP() {
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
                  'Other weight pressures',
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
                    value: widget.state.weightPressures,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.weightPressures = newValue;
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

  Widget containerWPOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.weightPressures,
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
                subFloorLoading(),
                subFloorThickness(),
                subdropdownFloorMaterial(),
                subUnitWeightOfMaterial(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget subFloorLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
          children: [
            Flexible(
              child: Container(
                width: 120,
                child: Text(
                  'Basement floor loading (in kPa):',
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
                    controller: inputFloorLoading,
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
                          inputFloorLoading.clear();
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
  Widget subFloorThickness() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Basement floor thickness (in mm):',
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
                  controller: inputFloorThickness,
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
                        inputFloorThickness.clear();
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
  Widget subdropdownFloorMaterial() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
          children: [
            Expanded(
              child: Text(
                'Material of the slab',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              height: 40,
              width: 179,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromARGB(255, 51, 149, 53),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                isExpanded: true,
                value: material,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    material = newValue;
                    widget.state.material = newValue; // Update the state
                    
                    // Set otherMat based on the selected material
                    if (newValue == 'Concrete') {
                      widget.state.otherMat = false; // Set to false if Concrete is selected
                    } else {
                      widget.state.otherMat = true; // Set to true for other materials
                    }

                  });
                },
                items: materials.map((String value) {
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
  Widget subUnitWeightOfMaterial() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Visibility(
        visible: widget.state.otherMat, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
          children: [
            Flexible(
              child: Container(
                width: 120,
                child: Text(
                  'Unit weight of material (in kN/m³):',
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
                    controller: inputOtherUnitWeight,
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
                          inputOtherUnitWeight.clear();
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
  } // subUnitWeightOfMaterial

  Widget containerSoilPropOff() {
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
                  soilPropOffHeader(),
                  subGammaDry(),
                  subGammaMoist(),
                  subGammaSat(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // containerSoilPropOff
  Widget soilPropOffHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centers the text
        children: [
          Flexible(
            child: Text(
              soilPropOffHeaderrr,
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
  } // soilPropOffHeader
  Widget subGammaDry() {
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
  } // subGammaDry
  Widget subGammaMoist() {
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
  } // subGammaMoist
  Widget subGammaSat() {
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
  } // subGammaSat

  Widget switchConcreteDet() {
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
  } // switchConcreteDet
  Widget containerConcreteOn() {
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
// Soil Prop On Manager
                subYconcrete(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerConcreteOn
  Widget subYconcrete() {
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
                  controller: inputYc,
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
                        inputYc.clear();
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
  } // subYconcrete
  
  Widget switchWaterDet() {
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
  } // switchWaterDet
  Widget containerWaterOn() {
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
// Soil Prop On Manager
                subYw(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerWaterOn
  Widget subYw() {
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
                  controller: inputYw,
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
                        inputYw.clear();
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
  } // subYw
  
  Widget buttonAnalysis() {
    return ElevatedButton(
      onPressed: () {
        calcAnalysis();
        if (!widget.state.showResultsAnalysis) {
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
      child: Text('Solve qgmin and qgmax'),
    );
  } // buttonAnalysis

  Widget switchDesign() {
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
                  'Design',
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
                    value: widget.state.design,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.design = newValue;
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
  } // switchDesign
  Widget resultAnalysis() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              isThereUplift ? "e ≥ B/6, ∴ uplift occurs" : "e < B/6, ∴ no uplift occurs",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Visibility(
              visible: !isThereUplift,
              child: Column(
                children: [
                  Text(
                    "qgmin = ${widget.state.finalQgmin} kPa",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "qgmax = ${widget.state.finalQgmax} kPa",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void toggleSolutionAnalysis() {
    if (widget.state.solutionToggleAnalysis) {
      widget.state.showSolutionAnalysis = true;
    } else {
      widget.state.showSolutionAnalysis = false;
    }
    setState(() {
      widget.state.solutionToggleAnalysis = !widget.state.solutionToggleAnalysis; // Toggle between functions
    });
  }
  Widget solutionButtonAnalysis() {
    return ElevatedButton(
      onPressed: toggleSolutionAnalysis,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(solutionButtonLabelAnalysis),
    );
  }
  Widget solutionContainerAnalysis() {
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
              Text(
                'Distance of center of column to center of footing = $dcc',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Mf = $mf',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'e = $roundedEcc',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'B/6 = $rounded_eUplift',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                isThereUplift ? "e ≥ B/6, ∴ uplift occurs" : "e < B/6, ∴ no uplift occurs",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isThereUplift)
                Text(
                  'q = $roundedPoverbl ± $roundedSixMfOverBL2',
                  style: TextStyle(color: Colors.white),
                ),
              if (!isThereUplift)
                Text(
                  'qmin = $roundedQmin',
                  style: TextStyle(color: Colors.white),
                ),
              if (!isThereUplift)
                Text(
                  'qmax = $roundedQmax',
                  style: TextStyle(color: Colors.white),
                ),
              if (!isThereUplift)
                Text(
                  'qo = $roundedQo',
                  style: TextStyle(color: Colors.white),
                ),
              if (!isThereUplift)
                Text(
                  "qgmin = ${widget.state.finalQgmin} kPa",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (!isThereUplift)
                Text(
                  "qgmax = ${widget.state.finalQgmax} kPa",
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
  
  // design widgets

  Widget headerDesign() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Design',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerDesign
  Widget dropdownModFactor() {
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
                'Modification factor for concrete, λ:',
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
                value: modFactor,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    modFactor = newValue;
                    });
                  },
                items: modFactorValues.map((String value) {
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
  } // dropdownModFactor
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
                    controller: inputFc, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                  )
                )
              ),
            ),
          ],
        ),
      ),        
    );
  } // entryFc
  Widget switchTop() {
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
                  'Diameter of top bars (assumed as 20 mm if not given)',
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
                    value: widget.state.topToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.topToggle = newValue;
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
  Widget containerTop() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.topToggle,
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
                subTop(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget subTop() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Diameter of top bars, dtop (in mm):',
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
                  controller: inputTop,
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
                        inputTop.clear();
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
  
  Widget switchBot() {
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
                  'Diameter of bottom bars (assumed as 20 mm if not given)',
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
                    value: widget.state.botToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.botToggle = newValue;
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
  Widget containerBot() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.botToggle,
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
                subBot(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget subBot() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Diameter of bottom bars, dbot (in mm):',
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
                  controller: inputBot,
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
                        inputBot.clear();
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
  
  Widget switchCC() {
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
                  'Concrete cover (assumed as 75 mm if not given)',
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
                    value: widget.state.concreteCover,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.concreteCover = newValue;
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
  Widget containerCC() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.concreteCover,
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
                subCc()
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget subCc() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
          children: [
            Flexible(
              child: Container(
                width: 120,
                child: Text(
                  'Concrete cover (in mm):',
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
                    controller: inputCc,
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
                          inputCc.clear();
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

  Widget buttonDesign() {
    return ElevatedButton(
      onPressed: () {
        //calcDesign();
        /*
        if (!widget.state.showResultsAnalysis) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please provide input for all parameters."),
              backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
              duration: Duration(seconds: 3),
            ),
          );
        }
        */
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Determine shear capacity'),
    );
  } // buttonDesign

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

} // _AnalRectMomentPageState

