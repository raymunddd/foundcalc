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
  late TextEditingController inputFactorShear;

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
  double? yMoist; 
  double? ySat;

  double? fLoad;
  double? fThick;
  double? yMatInput;

  double? yc;
  double? ycFinal;
  double? yw;
  double? ywFinal;

  double? lambda;
  double? fc;
  double? dtop;
  double? dtopFinal;
  double? dbot;
  double? dbotFinal;
  double? cc;
  double? ccFinal;
  double? phi;
  double? phiFinal;

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
  double? y;
  double? yMat;
  double? qy;
  double? qn;
  double? qo;
  
  // soldesign

  // wide-beam shear
  double? depth1;
  double? depth2;
  double? dp;
  double? x3;
  double? q3;
  double? vu;
  double? phiVc;
  bool? safetyWideBeam;
  // punching shear
  double? xc;
  double? x4;
  double? x5;
  double? b1;
  double? b2;
  double? quc;
  double? fu;
  double? vuPunch;
  double? cmax;
  double? cmin;
  double? beta;
  double? bo;
  double? as;
  double? lambdaFc;
  double? vc1;
  double? vc2;
  double? vc3;
  double? min1;
  double? vcPunch;
  double? phiVcPunch;
  bool? safetyPunch;

  // for solution container

  // analysis
  double? roundedEcc;
  double? rounded_eUplift;
  double? roundedPoverbl;
  double? roundedSixMfOverBL2;
  double? roundedQmin;
  double? roundedQmax;
  double? roundedQo;
  double? roundedQgmin;
  double? roundedQgmax;
  // design
  double? roundedQ3;
  double? roundedQuc;
  double? roundedFu;
  double? roundedBeta;
  double? roundedB1;
  double? roundedB2;
  double? roundedVc1;
  double? roundedVc2;
  double? roundedVc3;
  double? roundedVcPunch;


  // for rounding up
  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
  }

  // toggles
  bool isThereUplift = false;

  bool showSolution = false;
  bool showEte = false;

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

  String? colClass;
  final List<String> colClassValues = [
    'Interior',
    'Edge',
    'Corner',
  ];

  String? edge;
  final List<String> edgeOptions = [
    'Longitudinal dimension, L',
    'Transverse dimension, B',
  ];

  String get headerTitle {
    if (widget.state.design) {
      return 'Design';
    } else {
      return 'Analysis';
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

  String get solutionButtonLabelDesign {
    if (widget.state.showSolutionDesign) {
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
    inputFactorShear = TextEditingController(text: widget.state.inputFactorShear);

    // for dropdowns

    
    widget.state.material = material;

    loadingCase = widget.state.loadingCase;
    colClass = widget.state.colClass;
    edge = widget.state.edge;
    mDirection = widget.state.mDirection;
    hDirection = widget.state.hDirection;

    modFactor = "Normal-lightweight"; // Set default value here
    widget.state.modFactor = modFactor;

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
    inputFactorShear.addListener(_updateState);
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
      widget.state.inputFactorShear = inputFactorShear.text;

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

      if (colClass == 'Interior') {
        showEte = true;
      } else if (colClass == 'Edge') {
        if (edge == 'Longitudinal dimension, L') {
          showEte = true;
        } else if (edge == 'Transverse dimension, B') {
          showEte = false;
        } else { // null
          showEte = false;
        }
      } else if (colClass == 'Corner') {
        showEte = false;
      } else { // null
        showEte = false;
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
    inputFactorShear.dispose();

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

    yDry = double.tryParse(inputGammaDry.text);
    yMoist = double.tryParse(inputGammaMoist.text);

    yMatInput = double.tryParse(inputOtherUnitWeight.text);
    fLoad = double.tryParse(inputFloorLoading.text);
    fThick = double.tryParse(inputFloorThickness.text);

    cc = double.tryParse(inputCc.text);
    yw = double.tryParse(inputYw.text);
    yc = double.tryParse(inputYc.text);

    dbot = double.tryParse(inputBot.text);
    dtop = double.tryParse(inputTop.text);

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

    // moment arm of P
    if (colClass == 'Interior') {
      if (ete != null && l != null && c2 != null) {
        dcc = 0.5*l!-ete!-0.5*c2!;
      } else {
        dcc =  null;
      }
    } else if (colClass == 'Edge') {
      if (edge == 'Longitudinal dimension, L') {
        dcc = 0.5*l!-ete!-0.5*c2!;
      } else if (edge == 'Transverse dimension, B') {
        dcc = 0.5*l!-0.5*c2!;
      } else {
        dcc = null;
      }
    } else if (colClass == 'Corner') {
      if (l != null && c2 != null) {
        dcc = 0.5*l!-0.5*c2!;
      } else {
        dcc = null;
      }
    } else { // null
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
    } else {
      qmin = null;
      qmax = null;

      roundedPoverbl = null;
      roundedSixMfOverBL2 = null;

      roundedQmin = null;
      roundedQmax = null;
    }

    if (widget.state.soilProp) { // Soil Prop is ON
      if (ywFinal != null) {
        if (gs != null && e != null && w != null) {
          y = ((gs!*ywFinal!)*(1+w!))/(1+e!);
          ySat = (ywFinal! * (gs! + e!)) / (1 + e!);
        } else if (gs != null && e != null) {
          y = (gs!*ywFinal!)/(1+e!);
          ySat = (ywFinal! * (gs! + e!)) / (1 + e!);
        } else {
          y = null;
          ySat = null;
        }
      } else {
        y = null;
        ySat = null;
      }
    } else { // Soil Prop is OFF
      ySat = double.tryParse(inputGammaSat.text);
      if (yMoist != null && yDry == null) {
        y = yMoist;
      } else if (yMoist == null && yDry != null) {
        y = yDry;
      } else {
        y = null;
      }
    }

    if (y != null && ySat != null) {
      setState(() {
        widget.state.showResultsAnalysis = false;
        widget.state.showSolutionAnalysis = false;
        widget.state.solutionToggleAnalysis = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("γsat must be greater than γ/γdry."),
          backgroundColor:  const Color.fromARGB(255, 201, 40, 29),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // pressure due to soil
    if (df != null && t != null && y != null && ycFinal != null) {
      if (dw != null) {
        if (dw! < df!) {
          if (ySat != null) {
            qy = ycFinal!*t!+y!*dw!+ySat!*(df!-dw!-t!);
          } else {
            qy = null;
          }
        } else {
          qy = ycFinal!*t!+y!*(df!-t!);
        }
      } else {
        qy = ycFinal!*t!+y!*(df!-t!);
      }
    } else {
      qy = null;
    }

    // qo
    if (widget.state.weightPressures) { // pressure due to other weight pressures
      if (widget.state.material == 'Concrete') {
        if (ycFinal != null) {
          yMat = ycFinal!;
        } else {
          yMat = null;
        }
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

    // error handling
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
      uplift = $uplift,
      widget.state.showResultsAnalysis = ${widget.state.showResultsAnalysis},
    ''');

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

    yDry = double.tryParse(inputGammaDry.text);
    yMoist = double.tryParse(inputGammaMoist.text);
    ySat = double.tryParse(inputGammaSat.text);

    yMatInput = double.tryParse(inputOtherUnitWeight.text);
    fLoad = double.tryParse(inputFloorLoading.text);
    fThick = double.tryParse(inputFloorThickness.text);

    fc = double.tryParse(inputFc.text);
    cc = double.tryParse(inputCc.text);
    phi = double.tryParse(inputFactorShear.text);

    if (widget.state.concreteCover) {
      if (cc != null) {
        ccFinal = cc;
      } else {
        ccFinal = 5;
      }
    } else {
      ccFinal = 75;
    }

    if (widget.state.factorShearToggle) {
      if (phi != null) {
        phiFinal = phi;
      } else {
        phiFinal = null;
      }
    } else {
      phiFinal = 0.75;
    }
    
    // moment arm of P
    if (colClass == 'Interior') {
      if (ete != null && l != null && c2 != null) {
        dcc = 0.5*l!-ete!-0.5*c2!;
      } else {
        dcc = 0.0001;
      }
    } else if (colClass == 'Edge') {
      if (edge == 'Longitudinal dimension, L') {
        dcc = 0.5*l!-ete!-0.5*c2!;
      } else if (edge == 'Transverse dimension, B') {
        dcc = 0.5*l!-0.5*c2!;
      } else {
        dcc = 0.002;
      }
    } else if (colClass == 'Corner') {
      if (l != null && c2 != null) {
        dcc = 0.5*l!-0.5*c2!;
      } else {
        dcc = 0.0003;
      }
    } else { // null
      dcc = 0.0004;
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
    } else {
      qmin = null;
      qmax = null;

      roundedPoverbl = null;
      roundedSixMfOverBL2 = null;

      roundedQmin = null;
      roundedQmax = null;
    }

    // design parttt

    if (widget.state.topToggle) {
      if (dtop != null) {
        dtopFinal = dtop;
      } else {
        dtopFinal = null;
      }
    } else {
      dtopFinal = 20;
    }

    if (widget.state.botToggle) {
      if (dbot != null) {
        dbotFinal = dbot;
      } else {
        dbotFinal = null;
      }
    } else {
      dbotFinal = 20;
    }

    // wide-beam shear strength procedure (wbssp)

    if (t != null && ccFinal != null && dbotFinal != null && dtopFinal != null) {
      depth1 = (t!*1000) - ccFinal! - 0.5*dbotFinal!;
      depth2 = (t!*1000) - ccFinal! - dbotFinal! - 0.5*dtopFinal!;
      dp = (depth1! + depth2!)/2;
    } else {
      depth1 = null;
      depth2 = null;
      dp = null;
    }

    if (l != null && dcc != null && c2 != null && depth1 != null) {
      if (colClass == 'Interior' || colClass == 'Edge') {
        x3 = 0.5*l! - dcc! + 0.5*c2! + (depth1!/1000);
      } else if (colClass == 'Corner') {
        x3 = c2! + (depth1!/1000);
      } else { // null
        x3 = 0.0001;
      }
    } else {
      x3 = null;
    }

    if (x3 != null && qmin != null && qmax != null && l != null) {
      q3 = qmin! + ((qmax!-qmin!)*(l!-x3!))/l!;
      roundedQ3 = roundToFourDecimalPlaces(q3!);
    } else {
      q3 = null;
      roundedQ3 = null;
    }

    if (x3 != null && qmin != null && q3 != null && l != null && b != null) {
      vu = 0.5*(q3! + qmin!)*(l! - x3!)*b!;
      widget.state.finalVuWide = roundToFourDecimalPlaces(vu!);
    } else {
      vu = null;
      widget.state.finalVuWide = null;
    }

    if (widget.state.modFactor == "Normal-lightweight") {
      lambda = 1;
    } else if (widget.state.modFactor == "Sand-lightweight") {
      lambda = 0.85;
    } else if (widget.state.modFactor == "All-lightweight") {
      lambda = 0.75;
    } else {
      lambda = null;
    }
    
    if (phiFinal != null && lambda != null && fc != null && b != null && depth1 != null) { //elelel
      phiVc = phiFinal!*0.17*lambda!*sqrt(fc!)*b!*depth1!;
      widget.state.finalVcWide = roundToFourDecimalPlaces(phiVc!);
    } else {
      phiVc = null;
      widget.state.finalVcWide = null;
    }

    if (vu != null && phiVc != null) {
      if (vu! > phiVc!) {
        safetyWideBeam = false;
      } else { // Vu ≤ ΦVc
        safetyWideBeam = true;
      }
    } else {
      safetyWideBeam = null;
    }

    // punching shear strength procedure (pssp)

    if (l != null && dcc != null) {
      xc = 0.5*l! - dcc!;
    } else {
      xc = null;
    }

    if (xc != null && dp != null && c1 != null && c2 != null && qmax != null && qmin != null && l != null) {
      x4 = xc! - 0.5*(c2! + (dp!/1000));
      x5 = xc! + 0.5*(c2! + (dp!/1000));
      quc = qmin! + ((qmax! - qmin!)*(l! - xc!))/l!;
      
      if (colClass == 'Interior') {
        b1 = c1! + (dp!/1000);
        b2 = c2! + (dp!/1000);
      } else if (colClass == 'Edge') {
        b1 = c1! + (dp!/2000);
        b2 = c2! + (dp!/1000);
      } else if (colClass == 'Corner') {
        b1 = c1! + (dp!/2000);
        b2 = c2! + (dp!/2000);
      } else { // null
        b1 = null;
        b2 = null;
      }

      roundedB1 = roundToFourDecimalPlaces(b1!);
      roundedB2 = roundToFourDecimalPlaces(b2!);
      roundedQuc = roundToFourDecimalPlaces(quc!);
    } else {
      x4 = null;
      x5 = null;
      b1 = null;
      b2 = null;
      quc = null;

      roundedB1 = null;
      roundedB2 = null;
      roundedQuc = null;
    }

    if (quc != null && b1 != null && b2 != null) {
      fu = quc! * b1! * b2!;
      roundedFu = roundToFourDecimalPlaces(fu!);
    } else {
      fu = null;
      roundedFu = null;
    }

    if (p != null && fu != null) {
      vuPunch = p! - fu!;
      widget.state.finalVuPunch = roundToFourDecimalPlaces(vuPunch!);
    } else {
      vuPunch = null;
      widget.state.finalVuPunch = null;
    }

    if (c1 != null && c2 != null) {
      if (c1! < c2!) {
        cmax = c2;
        cmin = c1;
      } else if (c1! > c2!) {
        cmax = c1;
        cmin = c2;
      } else if (c1! == c2!) {
        cmax = c1;
        cmin = c1;
      } else {
        cmax = null;
        cmin = null;
      }
    } else {
      cmax = null;
      cmin = null;
    }

    if (cmax != null && cmin != null) {
      beta = cmax!/cmin!;
      roundedBeta = roundToFourDecimalPlaces(beta!);
    } else {
      beta = null;
      roundedBeta = null;
    }

    // as
    if (colClass == 'Interior') {
      as = 40;
    } else if (colClass == 'Edge') {
      as = 30;
    } else if (colClass == 'Corner') { // Corner column
      as = 20;
    } else {
      as = null;
    }

    if (b1 != null && b2 != null) {
      if (colClass == 'Interior') {
        bo = 2*(b1! + b2!);
      } else if (colClass == 'Edge') {
        bo = 2*b1! + b2!;
      } else if (colClass == 'Corner') {
        bo = b1! + b2!;
      } else { // null
        bo = 0.05;
      }
    } else {
      bo = null;
    }

    if (lambda != null && fc != null) {
      lambdaFc = lambda! * sqrt(fc!);
    } else {
      lambdaFc = null;
    }

    if (lambdaFc != null && beta != null && as != null && dp != null && bo != null) {
      vc1 = 0.33*lambdaFc!;
      vc2 = 0.17*(1 + (2/beta!))*lambdaFc!;
      vc3 = 0.083*(2 + (as! * dp!)/(1000*bo!))*lambdaFc!;

      roundedVc1 = roundToFourDecimalPlaces(vc1!);
      roundedVc2 = roundToFourDecimalPlaces(vc2!);
      roundedVc3 = roundToFourDecimalPlaces(vc3!);
    } else {
      vc1 = null;
      vc2 = null;
      vc3 = null;

      roundedVc1 = null;
      roundedVc2 = null;
      roundedVc3 = null;
    }

    if (vc1 != null && vc2 != null && vc3 != null) {
      min1 = min(vc1!, vc2!);
      vcPunch = min(min1!, vc3!);
      roundedVcPunch = roundToFourDecimalPlaces(vcPunch!);
    } else {
      min1 = null;
      vcPunch = null;
      roundedVcPunch = null;
    }

    if (phiFinal != null && vcPunch != null && dp != null && bo != null) {
      phiVcPunch = 0.75*vcPunch!*bo!*dp!;
      widget.state.finalVcPunch = roundToFourDecimalPlaces(phiVcPunch!);
    } else {
      phiVcPunch = null;
      widget.state.finalVcPunch = null;
    }

    if (vuPunch != null && phiVcPunch != null) {
      if (vuPunch! > phiVcPunch!) {
        safetyPunch = false;
      } else { // Vu ≤ ΦVc
        safetyPunch = true;
      }
    } else {
      safetyPunch = null;
    }

    // error handling
    if (uplift == false) {
      if (safetyPunch != null) {
        setState(() {
          widget.state.showResultsDesign = true;
        });
      } else {
        setState(() {
          widget.state.showResultsDesign = false;
        });
      }
    } else if (uplift == true) {
      setState(() {
        widget.state.showResultsDesign = true;
      });
    } else { // uplift = null
      setState(() {
        widget.state.showResultsDesign = false;
      });
    }
 //ololol
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
      cc = $ccFinal,
      dtop = $dtopFinal,
      dbot = $dbotFinal,
      d1 = $depth1,
      d2 = $depth2,
      dp = $dp,
      x3 = $x3,
      q3 = $q3,
      wide Vu = $vu,
      phi = $phiFinal,
      fc = $fc,
      b = $b,
      lambda = $lambda,
      wide Vc = $phiVc,
      xc = $xc,
      x4 = $x4,
      x5 = $x5,
      quc = $quc,
      b1 = $b1,
      b2 = $b2,
      Fu = $fu,
      punching Vu = $vu,
      as = $as,
      beta = $beta,
      bo = $bo,
      vc1 = $vc1,
      vc2 = $vc2,
      vc3 = $vc3,
      punching Vc = $phiVcPunch,
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
                      radioDesign(),
                      header(),
                      dropdownColClass(),

                      if (colClass == 'Edge')
                        dropdownEdge(),

                      dropdownLoadingCase(),

                      if (widget.state.design)
                        dropdownModFactor(),
        
                      if (widget.state.design)
                        entryFc(),

                      if (showEte)
                        entryEte(),

                      entryB(),
                      entryL(),

                      if (widget.state.design)
                        entryC1(),

                      entryC2(),
                      entryT(),
                      if (!widget.state.design)
                        entryDf(),
                      if (loadingCase == 'Axial vertical load (P) and lateral force (H)')
                        entryHf(),
                      if (!widget.state.design)
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

                      if (!widget.state.design)
                        switchSoilProp(),
                      if (!widget.state.design)
                        Stack(
                          children: [
                            containerSoilPropOn(),
                            containerSoilPropOff(),
                          ]
                        ),

                      if (!widget.state.design)
                        switchWP(),
                      if (!widget.state.design)
                        containerWPOn(),


                      if (!widget.state.design)
                        switchConcreteDet(),
                      if (!widget.state.design)
                        containerConcreteOn(),

                      if (widget.state.soilProp && !widget.state.design)
                        switchWaterDet(),
                      if (widget.state.soilProp && !widget.state.design)
                        containerWaterOn(),

                      if (!widget.state.design)
                        buttonAnalysis(),

                      if (!widget.state.design && widget.state.showResultsAnalysis)
                        SizedBox(height: 10),
                      if (!widget.state.design && widget.state.showResultsAnalysis)
                        resultAnalysis(),
                      if (!widget.state.design && widget.state.showResultsAnalysis)
                        SizedBox(height: 10),

                      if (!widget.state.design && widget.state.showResultsAnalysis)
                        solutionButtonAnalysis(),
                      if (!widget.state.design && widget.state.showSolutionAnalysis)
                        solutionContainerAnalysis(),

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
                        switchFactorShear(),
                      if (widget.state.design)
                        containerFactorShear(),

                      if (widget.state.design)
                        buttonDesign(),
                      
                      if (widget.state.design && widget.state.showResultsDesign)
                        SizedBox(height: 10),
                      if (widget.state.design && widget.state.showResultsDesign)
                        resultDesign(),

                      if (widget.state.design && widget.state.showResultsDesign)
                        SizedBox(height: 10),
                      if (widget.state.design && widget.state.showResultsDesign)
                        solutionButtonDesign(),
                      if (widget.state.design && widget.state.showSolutionDesign)
                        SizedBox(height: 10),
                      if (widget.state.design && widget.state.showSolutionDesign)
                        solutionContainerDesign(),                  

                      SizedBox(height: 10),
                      clearbuttonAll(),
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
  Widget header() {
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
  }
  
  Widget radioDesign() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                width: 120,
                child: Text(
                  'Select calculation type:',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Row(
              children: [
                Radio<bool>(
                  value: false, // Analysis
                  groupValue: widget.state.design,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.state.design = newValue ?? false;
                      widget.onStateChanged(widget.state);
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                Text(
                  'Analysis',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 20),
                Radio<bool>(
                  value: true, // Design
                  groupValue: widget.state.design,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.state.design = newValue ?? false;
                      widget.onStateChanged(widget.state);
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                Text(
                  'Design',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
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
          setState(() {
            widget.state.showSolutionAnalysis = false;
            widget.state.solutionToggleAnalysis = true;
          });
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
  Widget resultAnalysis() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              "e = $roundedEcc mm",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "B/6 = $rounded_eUplift mm",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
  } // resultAnalysis
  
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
  Widget solutionContainerAnalysis() {  // sca
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
                  'qₒ = $roundedQo',
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
  
  Widget clearbuttonAnalysis() {
    return ElevatedButton(
      onPressed: () {        
        loadingCase = null;

        inputEte.clear();
        inputB.clear();
        inputL.clear();
        inputC2.clear();
        inputT.clear();
        inputDf.clear();
        inputHf.clear();
        inputDw.clear();

        inputPDL.clear();
        inputPLL.clear();
        inputPUlt.clear();

        inputMDL.clear();
        inputMLL.clear();
        inputMUlt.clear();
        mDirection = null;

        inputHDL.clear();
        inputHLL.clear();
        inputHUlt.clear();
        hDirection = null;

        inputGs.clear();
        inputE.clear();
        inputW.clear();

        inputGammaDry.clear();
        inputGammaMoist.clear();
        inputGammaSat.clear();

        inputFloorLoading.clear();
        inputFloorThickness.clear();
        inputOtherUnitWeight.clear();

        inputYc.clear();
        inputYw.clear();

        setState(() {
          widget.state.toggleP = false;
          widget.state.toggleM = false;
          widget.state.toggleH = false;

          widget.state.weightPressures = false;
          widget.state.concreteDet = false;
          widget.state.waterDet = false;

          widget.state.showResultsAnalysis = false;
          widget.state.solutionToggleAnalysis = true;
          widget.state.showSolutionAnalysis = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text("Clear all values"),
    );
  } // clearbuttonAnalysis
  
  // design widgets
  
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
  Widget dropdownColClass() {
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
                'Classification of column:',
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
                value: colClass,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    colClass = newValue;
                    _updateState();
                    });
                  },
                items: colClassValues.map((String value) {
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
  } // dropdownColClass
  Widget dropdownEdge() {
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
                'Dimension of footing the column touches:',
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
                value: edge,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    edge = newValue;
                    _updateState();
                    });
                  },
                items: edgeOptions.map((String value) {
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
  } // dropdownEdge
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

  Widget switchFactorShear() {
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
                  'Shear (assumed as 0.75 if not given)',
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
                    value: widget.state.factorShearToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.factorShearToggle = newValue;
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
  } // switchFactorShear
  Widget containerFactorShear() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.factorShearToggle,
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
                subFactorShear(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerFactorShear
  Widget subFactorShear() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Shear factor, Φ:',
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
    );
  } // subFactorShear

  Widget buttonDesign() {
    return ElevatedButton(
      onPressed: () {
        calcDesign();
        if (!widget.state.showResultsDesign) {
          setState(() {
            widget.state.showSolutionDesign = false;
            widget.state.solutionToggleDesign = true;
          });
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
      child: Text('Determine shear capacity'),
    );
  } // buttonDesign
  Widget resultDesign() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              "e = $roundedEcc mm",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "B/6 = $rounded_eUplift mm",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  RichText(
                    text: TextSpan(
                      text: "For wide-beam shear:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Vu = ${widget.state.finalVuWide} kN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "ΦVc = ${widget.state.finalVcWide} kN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (safetyWideBeam == true)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Vu ≤ ΦVc, ∴ wide-beam shear strength is ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "adequate",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (safetyWideBeam == false)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Vu > ΦVc, ∴ wide-beam shear strength is",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "inadequate",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  RichText(
                    text: TextSpan(
                      text: "For punching shear:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Vu = ${widget.state.finalVuPunch} kN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "ΦVc = ${widget.state.finalVcPunch} kN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (safetyPunch == true)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Vu ≤ ΦVc, ∴ punching shear strength is ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "adequate",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (safetyPunch == false)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Vu > ΦVc, ∴ wide-beam shear strength is ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "inadequate",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  } // resultDesign
  void toggleSolutionDesign() {
    if (widget.state.solutionToggleDesign) {
      widget.state.showSolutionDesign = true;
    } else {
      widget.state.showSolutionDesign = false;
    }
    setState(() {
      widget.state.solutionToggleDesign = !widget.state.solutionToggleDesign; // Toggle between functions
    });
  }
  Widget solutionButtonDesign() {
    return ElevatedButton(
      onPressed: toggleSolutionDesign,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(solutionButtonLabelDesign),
    );
  }
  Widget solutionContainerDesign() { // scd
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
              Visibility(
                visible: !isThereUplift,
                child: Column(
                  children: [
                    Text(
                        'q = $roundedPoverbl ± $roundedSixMfOverBL2',
                        style: TextStyle(color: Colors.white),
                    ),
                    Text(
                        'qmin = $roundedQmin',
                        style: TextStyle(color: Colors.white),
                    ),
                    Text(
                        'qmax = $roundedQmax',
                        style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "d₁ = $depth1 mm",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "d₂ = $depth2 mm",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "dₚ = $dp mm",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: "For wide-beam shear:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "x₃ = $x3 m",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "qᵤ₃ = $roundedQ3 kPa",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Vᵤ = ${widget.state.finalVuWide} kN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ΦVc = ${widget.state.finalVcWide} kN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (safetyWideBeam == true)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Vu ≤ ΦVc, ∴ wide-beam shear strength is ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "adequate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (safetyWideBeam == false)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Vu > ΦVc, ∴ wide-beam shear strength is",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "inadequate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 10),

                    RichText(
                      text: TextSpan(
                        text: "For punching shear:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "xc = $xc m",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "x₄ = $x4 m",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "x₅ = $x5 m",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "b₁ = $roundedB1 m",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "b₂ = $roundedB2 m",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "quc = $roundedQuc kPa",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Fu = $roundedFu kN",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Vu = ${widget.state.finalVuPunch} kN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "β = $roundedBeta",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "bₒ = $bo m",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "aₛ = $as",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Vc₁ = $roundedVc1",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Vc₂ = $roundedVc2",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Vc₃ = $roundedVc3",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Vc = $roundedVcPunch",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "ΦVc = ${widget.state.finalVcPunch} kN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (safetyPunch == true)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Vu ≤ ΦVc, ∴ punching shear strength is ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "adequate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (safetyPunch == false)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Vu > ΦVc, ∴ punching shear strength is",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "inadequate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // solutionContainerDesign

  Widget clearbuttonDesign() {
    return ElevatedButton(
      onPressed: () {        
        modFactor = 'Normal-lightweight';

        inputC1.clear();
        inputFc.clear();

        inputTop.clear();
        inputBot.clear();
        inputCc.clear();
        inputFactorShear.clear();

        setState(() {
          widget.state.topToggle = false;
          widget.state.botToggle = false;
          widget.state.concreteCover = false;
          widget.state.factorShearToggle = false;

          widget.state.showResultsDesign = false;
          widget.state.solutionToggleDesign = false;
          widget.state.showSolutionDesign = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text("Clear all values"),
    );
  }

  Widget clearbuttonAll() {
    return ElevatedButton(
      onPressed: () {        

        // analysis

        loadingCase = null;

        inputEte.clear();
        inputB.clear();
        inputL.clear();
        inputC2.clear();
        inputT.clear();
        inputDf.clear();
        inputHf.clear();
        inputDw.clear();

        inputPDL.clear();
        inputPLL.clear();
        inputPUlt.clear();

        inputMDL.clear();
        inputMLL.clear();
        inputMUlt.clear();
        mDirection = null;

        inputHDL.clear();
        inputHLL.clear();
        inputHUlt.clear();
        hDirection = null;

        inputGs.clear();
        inputE.clear();
        inputW.clear();

        inputGammaDry.clear();
        inputGammaMoist.clear();
        inputGammaSat.clear();

        inputFloorLoading.clear();
        inputFloorThickness.clear();
        inputOtherUnitWeight.clear();

        inputYc.clear();
        inputYw.clear();

        setState(() {
          widget.state.toggleP = false;
          widget.state.toggleM = false;
          widget.state.toggleH = false;

          widget.state.weightPressures = false;
          widget.state.concreteDet = false;
          widget.state.waterDet = false;

          widget.state.showResultsAnalysis = false;
          widget.state.showSolutionAnalysis = false;
        });

        // design

        modFactor = 'Normal-lightweight';
        colClass = null;

        inputC1.clear();
        inputFc.clear();

        inputTop.clear();
        inputBot.clear();
        inputCc.clear();
        inputFactorShear.clear();

        setState(() {
          widget.state.topToggle = false;
          widget.state.botToggle = false;
          widget.state.concreteCover = false;
          widget.state.factorShearToggle = false;

          widget.state.showResultsAnalysis = false;
          widget.state.solutionToggleAnalysis = true;
          widget.state.showSolutionAnalysis = false;

          widget.state.showResultsDesign = false;
          widget.state.solutionToggleDesign = true;
          widget.state.showSolutionDesign = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text("Clear all values"),
    );
  } // clearbuttonAll

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

// testinggggggg

