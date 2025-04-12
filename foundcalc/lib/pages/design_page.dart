import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/design_state.dart';
import 'dart:math';

class DesignPage extends StatefulWidget {
  final String title;
  final DesignState state;
  final Function(DesignState) onStateChanged;


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

  late TextEditingController inputQAll;
  late TextEditingController inputQUlt;
  late TextEditingController inputFS;
  late TextEditingController inputfcPrime;
  late TextEditingController inputDf;
  late TextEditingController inputDw;
  late TextEditingController inputPDL;
  late TextEditingController inputPLL;
  late TextEditingController inputTop;
  late TextEditingController inputBot;

  late TextEditingController inputGs;
  late TextEditingController inputE;
  late TextEditingController inputW;

  late TextEditingController inputGammaDry;
  late TextEditingController inputGammaMoist;
  late TextEditingController inputGammaSat;

  late TextEditingController inputFloorLoading;
  late TextEditingController inputFloorThickness;

  late TextEditingController inputFootingThickness;

  late TextEditingController inputYw;
  late TextEditingController inputYc;

  late TextEditingController inputOtherUnitWeight;
  late TextEditingController inputColBase;
  late TextEditingController inputCc;

  // solvar

  double? gs;
  double? w;
  double? e;
  double? fc;
  double? df; 
  double? dw;
  double? y; 
  double? yDry;
  double? ySat;
  double? yw;
  double? yc;
  double? fs;
  double? t;
  double? qa;
  double? qult;
  double? qn;
  double? qo;
  double? yMat;
  double? yMatInput;
  double? fLoad;
  double? fThick;
  double? qall;
  double? pLL;
  double? pDL;
  double? sumP;
  double? b;
  double? pu;
  double? qnu;
  double? C;
  double? x;
  double? cc;
  double? dtop;
  double? dbot;
  double? depth;
  double? vuOWS;
  double? vucOWS;
  double? newDepthOWS;
  double? newtOWS;
  double? safetyOWS;
  double? lambda;
  double? bo;
  double? ao;
  double? vuTWS;
  double? fcbod;
  double? vc1;
  double? vc2;
  double? as;
  double? vc3;
  double? vucTWS;
  double? min1;
  double? newDepthTWS;
  double? safetyTWS;
  double? a_quad;
  double? b_quad;
  double? c_quad;
  double? new_vuOWS;
  double? new_vucOWS;

  double? newtTWS;
  double? new_vuTWS;
  double? fcbod2;
  double? vc1_new;
  double? vc2_new;
  double? vc3_new;
  double? min2;
  double? new_vucTWS;
  double? bo2;

  double beta = 1;
  int? bRound;

  // for tws first

  double? depth1;
  double? depth2;

  // toggles
  bool showSolution = false;
  bool showSolutionOWS = false;
  bool showSolutionTWS = false;

  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    // Initialize controllers with saved state
    inputQAll = TextEditingController(text: widget.state.inputQAll);
    inputQUlt = TextEditingController(text: widget.state.inputQUlt);
    inputFS = TextEditingController(text: widget.state.inputFS);
    inputfcPrime = TextEditingController(text: widget.state.inputfcPrime);
    inputDf = TextEditingController(text: widget.state.inputDf);
    inputPDL = TextEditingController(text: widget.state.inputPDL);
    inputPLL = TextEditingController(text: widget.state.inputPLL);
    inputTop = TextEditingController(text: widget.state.inputTop);
    inputBot = TextEditingController(text: widget.state.inputBot);
    inputGs = TextEditingController(text: widget.state.inputGs);
    inputE = TextEditingController(text: widget.state.inputE);
    inputW = TextEditingController(text: widget.state.inputW);
    inputGammaDry = TextEditingController(text: widget.state.inputGammaDry);
    inputGammaMoist = TextEditingController(text: widget.state.inputGammaMoist);
    inputGammaSat = TextEditingController(text: widget.state.inputGammaSat);
    inputDw = TextEditingController(text: widget.state.inputDw);
    inputFloorLoading = TextEditingController(text: widget.state.inputFloorLoading);
    inputFloorThickness = TextEditingController(text: widget.state.inputFloorThickness);
    inputFootingThickness = TextEditingController(text: widget.state.inputFootingThickness);
    inputYw = TextEditingController(text: widget.state.inputYw);
    inputYc = TextEditingController(text: widget.state.inputYc);
    inputOtherUnitWeight = TextEditingController(text: widget.state.inputOtherUnitWeight);
    inputColBase = TextEditingController(text: widget.state.inputColBase);
    inputCc = TextEditingController(text: widget.state.inputCc);

    colClass = widget.state.colClass;

    modFactor = "Normal-lightweight"; // Set default value here
    widget.state.modFactor = modFactor; // Update the state

    material = "Concrete"; // Set default value here
    widget.state.material = material; // Update the state

    inputQAll.addListener(_updateState);
    inputQUlt.addListener(_updateState);
    inputFS.addListener(_updateState);
    inputfcPrime.addListener(_updateState);
    inputDf.addListener(_updateState);
    inputPDL.addListener(_updateState);
    inputPLL.addListener(_updateState);
    inputTop.addListener(_updateState);
    inputBot.addListener(_updateState);
    inputGs.addListener(_updateState);
    inputE.addListener(_updateState);
    inputW.addListener(_updateState);
    inputGammaDry.addListener(_updateState);
    inputGammaMoist.addListener(_updateState);
    inputGammaSat.addListener(_updateState);
    inputDw.addListener(_updateState);
    inputFloorLoading.addListener(_updateState);
    inputFloorThickness.addListener(_updateState);
    inputFootingThickness.addListener(_updateState);
    inputYw.addListener(_updateState);
    inputYc.addListener(_updateState);
    inputOtherUnitWeight.addListener(_updateState);
    inputColBase.addListener(_updateState);
    inputCc.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      widget.state.inputQAll = inputQAll.text;
      widget.state.inputQUlt = inputQUlt.text;
      widget.state.inputFS = inputFS.text;
      widget.state.inputfcPrime = inputfcPrime.text;
      widget.state.inputDf = inputDf.text;
      widget.state.inputPDL = inputPDL.text;
      widget.state.inputPLL = inputPLL.text;
      widget.state.inputTop = inputTop.text;
      widget.state.inputBot = inputBot.text;
      widget.state.inputGs = inputGs.text;
      widget.state.inputE = inputE.text;
      widget.state.inputW = inputW.text;
      widget.state.inputGammaDry = inputGammaDry.text;
      widget.state.inputGammaMoist = inputGammaMoist.text;
      widget.state.inputGammaSat = inputGammaSat.text;
      widget.state.inputDw = inputDw.text;
      widget.state.inputFloorLoading = inputFloorLoading.text;
      widget.state.inputFloorThickness = inputFloorThickness.text;
      widget.state.inputFootingThickness = inputFootingThickness.text;
      widget.state.inputYw = inputYw.text;
      widget.state.inputYc = inputYc.text;
      widget.state.inputOtherUnitWeight = inputOtherUnitWeight.text;
      widget.state.inputColBase = inputColBase.text;
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

      widget.onStateChanged(widget.state);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    inputQAll.dispose();
    inputQUlt.dispose();
    inputFS.dispose();
    inputfcPrime.dispose();
    inputDf.dispose();
    inputPLL.dispose();
    inputPDL.dispose();
    inputTop.dispose();
    inputBot.dispose();
    inputGs.dispose();
    inputE.dispose();
    inputW.dispose();
    inputGammaDry.dispose();
    inputGammaMoist.dispose();
    inputGammaSat.dispose();
    inputDw.dispose();
    inputFloorLoading.dispose();
    inputFloorThickness.dispose();
    inputFootingThickness.dispose();
    inputYw.dispose();
    inputYc.dispose();
    inputOtherUnitWeight.dispose();
    inputColBase.dispose();
    inputCc.dispose();
  }

  // string getters

  String? material;
  final List<String> materials = [
    'Concrete',
    'Others',
  ];

  String? colClass;
  final List<String> colClassValues = [
    'Interior',
    'Edge',
    'Corner',
  ];

  String? modFactor;
  final List<String> modFactorValues = [
    'All-lightweight',
    'Sand-lightweight',
    'Normal-lightweight',
  ];

  String get soilPropOffHeaderrr {
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

  String get gammaSatHint {
    if (widget.state.isGammaSatEnabled) {
      return 'Input required';
    } else {
      return 'Input not required';
    }
  }

  String get solutionButtonLabel {
    if (showSolution) {
      return 'Hide solution';
    } else {
      return 'View solution';
    }
  }

  ////////////

  String get boolOWS {
    if (widget.state.showResultsOWSFirst) {
      return 'solution OWS = true';
    } else {
      return 'solution OWS = false';
    }
  }

  String get boolTWS {
    if (showSolutionOWS) {
      return 'solution TWS = true';
    } else {
      return 'solution TWS = false';
    }
  }

  ////////////

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
    qa = double.tryParse(inputQAll.text);
    qult = double.tryParse(inputQUlt.text);

    df = double.tryParse(inputDf.text);
    dw = double.tryParse(inputDw.text);
    fc = double.tryParse(inputfcPrime.text);
      // Nullable
    t = double.tryParse(inputFootingThickness.text);
    gs = double.tryParse(inputGs.text);
    w = double.tryParse(inputW.text);
    e = double.tryParse(inputE.text);

    yDry = double.tryParse(inputGammaDry.text);
    y = double.tryParse(inputGammaMoist.text);
    ySat = double.tryParse(inputGammaSat.text);

    yMatInput = double.tryParse(inputOtherUnitWeight.text);
    fLoad = double.tryParse(inputFloorLoading.text);
    fThick= double.tryParse(inputFloorThickness.text);

    pLL= double.tryParse(inputPLL.text);
    pDL = double.tryParse(inputPDL.text);

    C = double.tryParse(inputColBase.text);
    cc = double.tryParse(inputCc.text);

    dtop = double.tryParse(inputTop.text);
    dbot = double.tryParse(inputBot.text);

      // Default values
    yw = double.tryParse(inputYw.text) ?? 9.81; // Default to 9.81 if null
    yc = double.tryParse(inputYc.text) ?? 24; // Default to 24 if null
    fs = double.tryParse(inputFS.text) ?? 3; // Default to 3 if null
    cc = double.tryParse(inputCc.text) ?? 75; // Default to 3 if null

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

    if (widget.state.modFactor == "Normal-lightweight") {
      lambda = 1;
    } else if (widget.state.modFactor == "Sand-lightweight") {
      lambda = 0.85;
    } else { // All-lightweight
      lambda = 0.75;
    }

    if (widget.state.qToggle) { //using qall
      if (qa != null) {
        qall = qa!;
      } else {
        qall = null;
      } 
    } else { // using qult
      if (qult != null) {
        qall = qult!/fs!;
      } else {
        qall = null;
      }     
    } 
    
    if (widget.state.soilProp) {
      if (gs != null && e != null && w != null) {
        y = ((gs!*yw!)*(1+w!))/(1+e!);
      } else if (gs != null && e != null) {
        y = (gs!*yw!)/(1+e!);
      } else {
        y = null;
      }
    } else { //Soil Prop is OFF
      if (y != null && yDry == null) {
        y = y;
      } else if (y == null && yDry != null) {
        y = yDry;
      } else {
        y = null;
      }
    }
    
    if (df != null && t != null && y != null) {
      if (dw != null) {
        if (dw! < df!) {
          if (ySat != null) {
            qo = yc!*t!+y!*dw!+ySat!*(df!-dw!-t!);
          } else {
            qo = null;
          }
        } else {
          qo = yc!*t!+y!*(df!-t!);
        }
      } else {
        qo = yc!*t!+y!*(df!-t!);
      }
    } else {
      qo = null;
    }


    if (widget.state.weightPressures) {
      if (widget.state.material == 'Concrete') {
        yMat = yc!;
      } else { //others
        if (yMatInput != null) {
          yMat = yMatInput!;
        } else {
          yMat = null;
        }
      }
      if (qall != null && fLoad != null && yMat != null && fThick != null && qo != null) {
        qn = qall! - fLoad! - yMat!*(fThick!/1000) - qo!;
        //qp = yMat!*(fThick!/1000);
      } else {
        qn = null;
        //qp = 4;
      }
    } else { // no weight pressures
      if (qall != null && qo != null) {
        qn = qall! - qo!;
      } else {
        qn = 2;
      }     
    }

    if (pLL != null && pDL != null) {
      sumP = pLL! + pDL!;
      pu = 1.2*pDL! + 1.6*pLL!;
    } else {
      sumP = null;
      pu = null;
    }

    if (qn != null && sumP != null) {
      b = ((sqrt(sumP!/qn!))/0.025);
      
      if (b != null) {
        bRound = b!.ceil();  
      } else {
        bRound = null;
      }
      if (bRound != null) {
        b = 0.025 * (bRound!.toDouble());
        widget.state.finalAnswerB = b;
      } else {
        b = null; // Or any other default behavior
      }
    } else {
      bRound = null;
      b = null;
    }

    if (pu != null) {
      if (b != null) {
        qnu = pu!/(b!*b!); 
      } else {
        qnu = null;
      }
    } else {
      qnu = null;
    }

    if (t != null) {
      depth = (t!*1000) - cc! - dbot! - 0.5*dtop!;
    } else {
      depth = null;
    }

    if (colClass == "Interior") {
      if (b != null && C != null && depth != null) {
        x = (b!/2) - (C!/2) - (depth!/1000);
      } else {
        x = null;
      }
    } else if (colClass == "Edge") {
      x = null;
    } else { // Corner
      x = 3;
    }

    if (qnu != null && b != null && x != null) {
      vuOWS = qnu!*b!*x!;
    } else {
      vuOWS = null;
    }

    if (fc != null && b != null && depth != null) {
      vucOWS = 0.1275*lambda!*sqrt(fc!)*b!*depth!;
    } else {
      vucOWS = null;
    }

    if (vuOWS != null && vucOWS != null) {
      if (vuOWS! > vucOWS!) {
        safetyOWS = 1; // OWS unsafe
        if (qnu != null && b != null && C != null && fc != null) { // && lambda != null
          newDepthOWS = roundUpToNearest25((0.5*qnu!*(b! - C!))/((0.001*qnu!) + 0.1275*lambda!*sqrt(fc!)));
        } else {
          newDepthOWS = null;
          widget.state.finalAnswerD = null;
        }
      } else { // vuOWS ≤ vuCOWS
        newDepthOWS = depth;
        widget.state.finalAnswerVuows = vuOWS;
        widget.state.finalAnswerVucows = vucOWS;
        safetyOWS = 2; // OWS safe
      }
    } else {
      newDepthOWS = 2;
    }

    if (newDepthOWS != null) {
      newtOWS = newDepthOWS! + cc! + dbot! + 0.5*dtop!;
    } else {
      newtOWS = null;
    }

    if (qnu != null && b != null && newDepthOWS != null) {
      new_vuOWS = qnu!*b!*(0.5*(b!-C!)-0.001*newDepthOWS!);
      widget.state.finalAnswerVuows = new_vuOWS;
    } else {
      new_vuOWS = null;
      widget.state.finalAnswerVuows = null;
    }

    if (fc != null && b != null && newDepthOWS != null) {
      new_vucOWS = 0.1275*lambda!*sqrt(fc!)* b!*newDepthOWS!;
      widget.state.finalAnswerVucows = new_vucOWS;
    } else {
      new_vucOWS = null;
      widget.state.finalAnswerVucows = null;
    }

    // tws solution

    if (colClass == "Interior") {
      if (C != null && newDepthOWS != null) {
        bo = 4*(C!+(newDepthOWS!/1000));
        ao = (C!+(newDepthOWS!/1000))*(C!+(newDepthOWS!/1000));
      } else {
        bo = 1;
        ao = 1;
      }
    } else if (colClass == "Edge") {
      bo = 2;
      ao = 2;
    } else { // Corner
      bo = 3;
      ao = 3;
    }

    if (qnu != null && b != null && ao != null) {
      vuTWS = qnu!*((b!*b!)-ao!);
    } else {
      vuTWS = null;
    }

    if (fc != null && bo != null && newDepthOWS != null) {
      fcbod = 0.75*lambda!*sqrt(fc!)*bo!*newDepthOWS!;
      vc1 = 0.75*0.33*lambda!*sqrt(fc!)*bo!*newDepthOWS!;
    } else {
      fcbod = null;
      vc1 = null;
    }

    if (fcbod != null) {
      vc2 = 0.17*(1+(2/beta))*fcbod!;
    } else {
      vc2 = null;
    }

    if (colClass == 'Interior') {
      as = 40;
    } else if (colClass == 'Edge') {
      as = 30;
    } else { // Corner column
      as = 20;
    }

    if (as != null && newDepthOWS != null && bo != null && fcbod != null) {
      vc3 = 0.083*(2+((as!*newDepthOWS!)/(bo!*1000)))*fcbod!;
    } else {
      vc3 = null;
    }

    if (vc1 != null && vc2 != null && vc3 != null) {
      min1 = min(vc1!, vc2!);
      vucTWS = min(min1!, vc3!);
    } else {
      min1 = null;
      vucTWS = null;
    }

    if (vuTWS != null && vucTWS != null) {
      if (vuTWS! > vucTWS!) {
        safetyTWS = 1; // TWS unsafe
        if (qnu != null && b != null && C != null && fc != null) { // && lambda != null
          a_quad = 990*sqrt(fc!) + qnu!;
          b_quad = 990000*sqrt(fc!)*C!+2000*qnu!*C!;
          c_quad = -1000000*qnu!*(b!*b!-C!*C!);
          // quadratic formula
          newDepthTWS = roundUpToNearest25((-(b_quad!)+sqrt((b_quad!*b_quad!)-(4*a_quad!*c_quad!)))/(2*a_quad!));
        } else {
          newDepthTWS = 1;
        }
      } else { // vuTWS ≤ vuCTWS
        newDepthTWS = depth;
        widget.state.finalAnswerVutws = vuTWS;
        widget.state.finalAnswerVuctws = vucTWS;
        safetyTWS = 2; // TWS safe
      }
    } else {
      newDepthTWS = 2;
    }
    
    if (newDepthTWS != null) {
      newtTWS = newDepthTWS! + cc! + dbot! + 0.5*dtop!;
    } else {
      newtTWS = null;
    }

    if (qnu != null && b != null && C != null && newDepthTWS != null) {
      new_vuTWS = qnu!*(b!*b!-(C!+(newDepthTWS!/1000))*(C!+(newDepthTWS!/1000)));
      widget.state.finalAnswerVutws = new_vuTWS;
    } else {
      new_vuTWS = null;
      widget.state.finalAnswerVutws = null;
    }

    if (colClass == "Interior") {
      if (C != null && depth != null) {
        bo2 = 4*(C!+(newDepthTWS!/1000));
      } else {
        bo2 = 1;
      }
    } else if (colClass == "Edge") {
      bo2 = 2;
    } else { // Corner
      bo2 = 3;
    }

    if (fc != null && bo2 != null && depth != null) {
      fcbod2 = 0.75*lambda!*sqrt(fc!)*bo2!*newDepthTWS!;
      vc1_new = 0.33*0.75*lambda!*sqrt(fc!)*bo2!*newDepthTWS!;
    } else {
      fcbod2 = null;
      vc1_new = null;
    }

    if (fcbod2 != null) {
      vc2_new = 0.17*(1+(2/beta))*fcbod2!;
    } else {
      vc2_new = null;
    }

    if (as != null && newDepthTWS != null && bo2 != null) {
      vc3_new = 0.083*(2+((as!*newDepthTWS!)/(bo2!*1000)))*fcbod2!;
    } else {
      vc3_new = null;
    }

    if (vc1_new != null && vc2_new != null && vc3_new != null) {
      min2 = min(vc1_new!, vc2_new!);
      new_vucTWS = min(min2!, vc3_new!);
      widget.state.finalAnswerVuctws = new_vucTWS;

      setState(() {
        widget.state.showResultsOWSFirst = true;
        widget.state.showResultsTWSFirst = false;
      });
    } else {
      min2 = null;
      new_vucTWS = null;
      widget.state.finalAnswerVuctws = null;
    }

    if (newDepthOWS != null && newDepthTWS != null) {
      widget.state.finalAnswerD = max(newDepthOWS!, newDepthTWS!);
    } else {
      widget.state.finalAnswerD = null;
    }

    if (newtOWS != null && newtTWS != null) {
      widget.state.finalAnswerT = max(newtOWS!, newtTWS!);
    } else {
      widget.state.finalAnswerT = null;
    }

    print('otherMat = ${widget.state.otherMat}');
    print("yc = $yc, yMat = $yMat, fLoad = $fLoad, λ = $lambda");
    print("qa = $qall, qo = $qo, qn = $qn, Pa = $sumP, b = $b, bRound = $bRound, Pu = $pu, qnu = $qnu, depth = $depth, x = $x");
    print("OWS: VUows = $vuOWS, VUcows = $vucOWS, new d = $newDepthOWS, new T = $newtOWS, new VUows = $new_vuOWS, new VUcows = $new_vucOWS");
    print("TWS: bo = $bo, VUtws = $vuTWS, VUctws = $vucTWS, new d = $newDepthTWS, new T = $newtTWS, new bo = $bo2, new VUtws = $new_vuTWS, new VUctws = $new_vucTWS");
    print("vc1 = $vc1, vc2 = $vc2, vc3 = $vc3");
    print("new vc1 = $vc1_new, new vc2 = $vc2_new, new vc3 = $vc3_new");
    print('fcbod = $fcbod, as = $as');
  }

  void calculateTWS() {
    qa = double.tryParse(inputQAll.text);
    qult = double.tryParse(inputQUlt.text);

    df = double.tryParse(inputDf.text);
    dw = double.tryParse(inputDw.text);
    fc = double.tryParse(inputfcPrime.text);
      // Nullable
    t = double.tryParse(inputFootingThickness.text);
    gs = double.tryParse(inputGs.text);
    w = double.tryParse(inputW.text);
    e = double.tryParse(inputE.text);

    yDry = double.tryParse(inputGammaDry.text);
    y = double.tryParse(inputGammaMoist.text);
    ySat = double.tryParse(inputGammaSat.text);

    yMatInput = double.tryParse(inputOtherUnitWeight.text);
    fLoad = double.tryParse(inputFloorLoading.text);
    fThick= double.tryParse(inputFloorThickness.text);

    pLL= double.tryParse(inputPLL.text);
    pDL = double.tryParse(inputPDL.text);

    C = double.tryParse(inputColBase.text);
    cc = double.tryParse(inputCc.text);

    dtop = double.tryParse(inputTop.text);
    dbot = double.tryParse(inputBot.text);

      // Default values
    yw = double.tryParse(inputYw.text) ?? 9.81; // Default to 9.81 if null
    yc = double.tryParse(inputYc.text) ?? 24; // Default to 24 if null
    fs = double.tryParse(inputFS.text) ?? 3; // Default to 3 if null
    cc = double.tryParse(inputCc.text) ?? 75; // Default to 3 if null

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

    if (widget.state.modFactor == "Normal-lightweight") {
      lambda = 1;
    } else if (widget.state.modFactor == "Sand-lightweight") {
      lambda = 0.85;
    } else { // All-lightweight
      lambda = 0.75;
    }

    if (widget.state.qToggle) { //using qall
      if (qa != null) {
        qall = qa!;
      } else {
        qall = null;
      } 
    } else { // using qult
      if (qult != null) {
        qall = qult!/fs!;
      } else {
        qall = null;
      }     
    } 
    
    if (widget.state.soilProp) {
      if (gs != null && e != null && w != null) {
        y = ((gs!*yw!)*(1+w!))/(1+e!);
      } else if (gs != null && e != null) {
        y = (gs!*yw!)/(1+e!);
      } else {
        y = null;
      }
    } else { //Soil Prop is OFF
      if (y != null && yDry == null) {
        y = y;
      } else if (y == null && yDry != null) {
        y = yDry;
      } else {
        y = null;
      }
    }
    
    if (df != null && t != null && y != null) {
      if (dw != null) {
        if (dw! < df!) {
          if (ySat != null) {
            qo = yc!*t!+y!*dw!+ySat!*(df!-dw!-t!);
          } else {
            qo = null;
          }
        } else {
          qo = yc!*t!+y!*(df!-t!);
        }
      } else {
        qo = yc!*t!+y!*(df!-t!);
      }
    } else {
      qo = null;
    }


    if (widget.state.weightPressures) {
      if (widget.state.material == 'Concrete') {
        yMat = yc!;
      } else { //others
        if (yMatInput != null) {
          yMat = yMatInput!;
        } else {
          yMat = null;
        }
      }
      if (qall != null && fLoad != null && yMat != null && fThick != null && qo != null) {
        qn = qall! - fLoad! - yMat!*(fThick!/1000) - qo!;
        //qp = yMat!*(fThick!/1000);
      } else {
        qn = 3;
        //qp = 4;
      }
    } else { // no weight pressures
      if (qall != null && qo != null) {
        qn = qall! - qo!;
      } else {
        qn = 2;
      }     
    }

    if (pLL != null && pDL != null) {
      sumP = pLL! + pDL!;
      pu = 1.2*pDL! + 1.6*pLL!;
    } else {
      sumP = null;
      pu = null;
    }

    if (qn != null && sumP != null) {
      b = ((sqrt(sumP!/qn!))/0.025);
      
      if (b != null) {
        bRound = b!.ceil();  
      } else {
        bRound = null;
      }
      if (bRound != null) {
        b = 0.025 * (bRound!.toDouble());
        widget.state.finalAnswerB = b;
      } else {
        // Handle the case where bRound is null, if necessary
        b = null; // Or any other default behavior
      }
    } else {
      bRound = null;
      b = null;
    }

    if (pu != null) {
      if (b != null) {
        qnu = pu!/(b!*b!); 
      } else {
        qnu = null;
      }
    } else {
      qnu = null;
    }

    if (t != null) {
      depth1 = (t!*1000) - cc! - 0.5*dbot!;
      depth2 = (t!*1000) - cc! - dbot! - 0.5*dtop!;
      depth = (depth1! + depth2!)/2;
    } else {
      depth1 = null;
      depth2 = null;
      depth = null;
    }

    if (colClass == "Interior") {
      if (C != null && depth != null) {
        bo = 4*(C!+(depth!/1000));
        ao = (C!+(depth!/1000))*(C!+(depth!/1000));
      } else {
        bo = 1;
        ao = 1;
      }
    } else if (colClass == "Edge") {
      bo = 2;
      ao = 2;
    } else { // Corner
      bo = 3;
      ao = 3;
    }

    if (qnu != null && b != null && ao != null) {
      vuTWS = qnu!*((b!*b!)-ao!);
    } else {
      vuTWS = null;
    }

    if (fc != null && bo != null && depth != null) {
      fcbod = 0.75*lambda!*sqrt(fc!)*bo!*depth!;
      vc1 = 0.75*0.33*lambda!*sqrt(fc!)*bo!*depth!;
    } else {
      fcbod = null;
      vc1 = null;
    }

    if (fcbod != null) {
      vc2 = 0.17*(1+(2/beta))*fcbod!;
    } else {
      vc2 = null;
    }

    if (colClass == 'Interior') {
      as = 40;
    } else if (colClass == 'Edge') {
      as = 30;
    } else { // Corner column
      as = 20;
    }

    if (as != null && depth != null && bo != null && fcbod != null) {
      vc3 = 0.083*(2+((as!*depth!)/(bo!*1000)))*fcbod!;
    } else {
      vc3 = null;
    }

    if (vc1 != null && vc2 != null && vc3 != null) {
      min1 = min(vc1!, vc2!);
      vucTWS = min(min1!, vc3!);
    } else {
      min1 = null;
      vucTWS = null;
    }

    if (vuTWS != null && vucTWS != null) {
      if (vuTWS! > vucTWS!) {
        safetyTWS = 1; // TWS unsafe
        if (qnu != null && b != null && C != null && fc != null) { // && lambda != null
          a_quad = 990*sqrt(fc!) + qnu!;
          b_quad = 990000*sqrt(fc!)*C!+2000*qnu!*C!;
          c_quad = -1000000*qnu!*(b!*b!-C!*C!);
          // quadratic formula
          newDepthTWS = roundUpToNearest25((-(b_quad!)+sqrt((b_quad!*b_quad!)-(4*a_quad!*c_quad!)))/(2*a_quad!));
        } else {
          newDepthTWS = null;
        }
      } else { // vuOWS ≤ vuCOWS
        newDepthTWS = depth;
        widget.state.finalAnswerVutws = vuTWS;
        widget.state.finalAnswerVuctws = vucTWS;
        safetyTWS = 2; // TWS safe
      }
    } else {
      newDepthTWS = 2;
    }
    
    if (newDepthTWS != null) {
      newtTWS = newDepthTWS! + cc! + dbot! + 0.5*dtop!;
    } else {
      newtTWS = null;
    }

    if (qnu != null && b != null && C != null && newDepthTWS != null) {
      new_vuTWS = qnu!*(b!*b!-(C!+(newDepthTWS!/1000))*(C!+(newDepthTWS!/1000)));
      widget.state.finalAnswerVutws = new_vuTWS;
    } else {
      new_vuTWS = null;
      widget.state.finalAnswerVutws = null;
    }

    if (colClass == "Interior") {
      if (C != null && depth != null) {
        bo2 = 4*(C!+(newDepthTWS!/1000));
      } else {
        bo2 = 1;
      }
    } else if (colClass == "Edge") {
      bo2 = 2;
    } else { // Corner
      bo2 = 3;
    }

    if (fc != null && bo2 != null && depth != null) {
      fcbod2 = 0.75*lambda!*sqrt(fc!)*bo2!*newDepthTWS!;
      vc1_new = 0.33*0.75*lambda!*sqrt(fc!)*bo2!*newDepthTWS!;
    } else {
      fcbod2 = null;
      vc1_new = null;
    }

    if (fcbod2 != null) {
      vc2_new = 0.17*(1+(2/beta))*fcbod2!;
    } else {
      vc2_new = null;
    }

    if (as != null && newDepthTWS != null && bo2 != null && fcbod2 != null) {
      vc3_new = 0.083*(2+((as!*newDepthTWS!)/(bo2!*1000)))*fcbod2!;
    } else {
      vc3_new = null;
    }

    if (vc1_new != null && vc2_new != null && vc3_new != null) {
      min2 = min(vc1_new!, vc2_new!);
      new_vucTWS = min(min2!, vc3_new!);
      widget.state.finalAnswerVuctws = new_vucTWS;
    } else {
      min2 = null;
      new_vucTWS = null;
      widget.state.finalAnswerVuctws = null;
    }

    // OWS solution

    if (colClass == "Interior") {
      if (b != null && C != null && newDepthTWS != null) {
        x = (b!/2) - (C!/2) - (newDepthTWS!/1000);
      } else {
        x = 1;
      }
    } else if (colClass == "Edge") {
      x = 2;
    } else { // Corner
      x = 3;
    }

    if (qnu != null && b != null && x != null) {
      vuOWS = qnu!*b!*x!;
    } else {
      vuOWS = null;
    }

    if (fc != null && b != null && newDepthTWS != null) {
      vucOWS = 0.1275*lambda!*sqrt(fc!)*b!*newDepthTWS!;
    } else {
      vucOWS = null;
    }

    if (vuOWS != null && vucOWS != null) {
      if (vuOWS! > vucOWS!) {
        safetyOWS = 1; // OWS unsafe
        if (qnu != null && b != null && C != null && fc != null) { // && lambda != null
          newDepthOWS = roundUpToNearest25((0.5*qnu!*(b! - C!))/((0.001*qnu!) + 0.1275*lambda!*sqrt(fc!)));
        } else {
          newDepthOWS = 1;
        }
      } else { // vuOWS ≤ vuCOWS
        newDepthOWS = newDepthTWS;
        widget.state.finalAnswerVuows = vuOWS;
        widget.state.finalAnswerVucows = vucOWS;
        safetyOWS = 2; // OWS safe
      }
    } else {
      newDepthOWS = 2;
    }

    if (newDepthOWS != null) {
      newtOWS = newDepthOWS! + cc! + dbot! + 0.5*dtop!;
    } else {
      newtOWS = null;
    }

    if (qnu != null && b != null && newDepthOWS != null) {
      new_vuOWS = qnu!*b!*(0.5*(b!-C!)-0.001*newDepthOWS!);
      widget.state.finalAnswerVuows = new_vuOWS;
    } else {
      new_vuOWS = null;
      widget.state.finalAnswerVuows = null;
    }

    if (fc != null && b != null && newDepthOWS != null) {
      new_vucOWS = 0.1275*lambda!*sqrt(fc!)* b!*newDepthOWS!;
      widget.state.finalAnswerVucows = new_vucOWS;
      setState(() {
        widget.state.showResultsTWSFirst = true;
        widget.state.showResultsOWSFirst = false;
      });
    } else {
      new_vucOWS = null;
      widget.state.finalAnswerVucows = null;
    }

    if (newDepthOWS != null && newDepthTWS != null) {
      widget.state.finalAnswerD = max(newDepthOWS!, newDepthTWS!);
    } else {
      widget.state.finalAnswerD = null;
    }

    if (newtOWS != null && newtTWS != null) {
      widget.state.finalAnswerT = max(newtOWS!, newtTWS!);
    } else {
      widget.state.finalAnswerT = null;
    }

    print('otherMat = ${widget.state.otherMat}');
    print("yc = $yc, yMat = $yMat, fLoad = $fLoad, λ = $lambda");
    print("qa = $qall, qo = $qo, qn = $qn, Pa = $sumP, b = $b, bRound = $bRound, Pu = $pu, qnu = $qnu, depth = $depth, x = $x");
    print("TWS: bo = $bo, VUtws = $vuTWS, VUctws = $vucTWS, new d = $newDepthTWS, new T = $newtTWS, new bo = $bo2, new VUtws = $new_vuTWS, new VUctws = $new_vucTWS");
    print("OWS: VUows = $vuOWS, VUcows = $vucOWS, new d = $newDepthOWS, new T = $newtOWS, new VUows = $new_vuOWS, new VUcows = $new_vucOWS");
    print("vc1 = $vc1, vc2 = $vc2, vc3 = $vc3");
    print("new vc1 = $vc1_new, new vc2 = $vc2_new, new vc3 = $vc3_new");
    print('fcbod = $fcbod, as = $as');
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
                      rowModFactor(),
                      rowColClass(),
                      rowColBase(),
                      rowPdead(),
                      rowPlive(),
                      rowfcPrime(),                     
                      rowDf(),
                      rowThickness(),
                      rowDw(),
                      rowSoilProp(),
                      Stack(
                        children: [
                          containerSoilPropOn(),
                          containerSoilPropOff(),
                        ]
                      ),
                      rowQToggle(),
                      Stack(
                        children: [
                          containerQToggleOn(),
                          containerQToggleOff(),
                        ]
                      ),

                      rowWPToggle(),
                      containerWPOn(),

                      rowTopToggle(),
                      containerTop(),

                      rowBotToggle(),
                      containerBot(),

                      rowCCToggle(),
                      containerCCOn(),

                      rowConcreteDet(),
                      containerConcreteOn(),

                      if (widget.state.soilProp)
                        rowWaterDet(),
                      if (widget.state.soilProp)
                        containerWaterOn(),

                      clearButton(),
                      SizedBox(height: 10),
                      buttonOWSFirst(),
                      SizedBox(height: 10),
                      buttonTWSFirst(),
                      SizedBox(height: 10),

                      if (widget.state.showResultsOWSFirst)
                        resultOWSFirst(),
                      if (widget.state.showResultsTWSFirst)
                        resultTWSFirst(),

                      SizedBox(height: 10),
                      if (widget.state.showResultsOWSFirst || widget.state.showResultsTWSFirst)
                        solutionButton(),
                      SizedBox(height: 10),

                      if (showSolutionOWS)
                        containerSolutionOWS(),
                      if (showSolutionTWS)
                        containerSolutionTWS(),
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
  Widget rowQToggle() {
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
                  'Gross/allowable bearing capacity',
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
                    value: widget.state.qToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.qToggle = newValue;
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
  Widget containerQToggleOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.qToggle,
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
                subQAll(),
              ]
            ),
          ),
        ),
      ),
    );
  }
  Widget subQAll() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Gross/allowable bearing capacity, qa (in kPa):',
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
                  controller: inputQAll,
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
                        inputQAll.clear();
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
  Widget containerQToggleOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.qToggle,
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  subQUlt(),
                  subFS(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget subQUlt() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Ultimate soil bearing capacity, qult (in kPa):',
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
                  controller: inputQUlt,
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
                        inputQUlt.clear();
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
  Widget subFS() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
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
                  controller: inputFS,
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
                        inputFS.clear();
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
  Widget rowfcPrime() {
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
                  "Compressive strength of concrete, fc' (in kPa):",
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
                    controller: inputfcPrime,
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
                          inputfcPrime.clear();
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
  Widget rowColClass() {
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
  }
  Widget rowModFactor() {
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
                'Modification factor for concrete:',
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
  }
  Widget rowDf() {
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
  } 
  Widget rowThickness() {
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
  Widget rowPdead() {
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
                  'Service dead load, PDL (in kN):',
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
      ),
    );
  }
  Widget rowPlive() {
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
                  'Service live load, PLL (in kN):',
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
      ),
    );
  }
  Widget rowColBase() {
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
                  'Base of column (in m):',
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
                    controller: inputColBase,
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
                            inputColBase.clear();
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
  Widget rowTopToggle() {
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
  Widget rowBotToggle() {
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
  Widget rowSoilProp() {
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
  }
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
  }
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
  }
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
  }
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
  }
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
  }
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
  }
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
  }
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
  }
  Widget rowDw() {
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
                    controller: inputDw,
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
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }
  
  Widget rowConcreteDet() {
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
  }
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
  }
  
  Widget rowWaterDet() {
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
  }
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
  }

  Widget rowCCToggle() {
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
  Widget containerCCOn() {
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
                concreteCoverOn()
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget concreteCoverOn() {
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

  Widget rowWPToggle() {
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
                subFloorMaterial(),
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
  Widget subFloorMaterial() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
  }

  Widget buttonOWSFirst() {
    return ElevatedButton(
      onPressed: () {
        calculate();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Solve using one-way shear first'),
    );
  }
  Widget buttonTWSFirst() {
    return ElevatedButton(
      onPressed: () {
        calculateTWS();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Solve using two-way shear first'),
    );
  }

  Widget resultOWSFirst() {
    return Visibility(
      visible: widget.state.showResultsOWSFirst,
      child: Flexible(
        child: Container(
          width: 445,
          child: Column(
            children: [
              Text(
                "B = ${widget.state.finalAnswerB} m",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "T = ${roundToOneDecimalPlace(widget.state.finalAnswerT!)} mm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "d = ${roundToOneDecimalPlace(widget.state.finalAnswerD!)} mm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vuows = ${roundToFourDecimalPlaces(widget.state.finalAnswerVuows!)} kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vucows = ${roundToFourDecimalPlaces(widget.state.finalAnswerVucows!)} kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vutws = ${roundToFourDecimalPlaces(widget.state.finalAnswerVutws!)} kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vuctws = ${roundToFourDecimalPlaces(widget.state.finalAnswerVuctws!)} kN",
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
  Widget resultTWSFirst() {
    return Visibility(
      visible: widget.state.showResultsTWSFirst,
      child: Flexible(
        child: Container(
          width: 445,
          child: Column(
            children: [
              Text(
                "B = ${widget.state.finalAnswerB} m",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "T = ${roundToOneDecimalPlace(widget.state.finalAnswerT!)} mm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "d = ${roundToOneDecimalPlace(widget.state.finalAnswerD!)} mm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vutws = ${roundToFourDecimalPlaces(widget.state.finalAnswerVutws!)} kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vuctws = ${roundToFourDecimalPlaces(widget.state.finalAnswerVuctws!)} kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vuows = ${roundToFourDecimalPlaces(widget.state.finalAnswerVuows!)} kN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                "Vucows = ${roundToFourDecimalPlaces(widget.state.finalAnswerVucows!)} kN",
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
    setState(() {
      showSolution = !showSolution;

      // Hide both solutions when toggling off
      if (!showSolution) {
        showSolutionOWS = false;
        showSolutionTWS = false;
      } else {
        // Show the appropriate solution container based on the state
        if (widget.state.showResultsOWSFirst) {
          showSolutionOWS = true;
          showSolutionTWS = false; // Hide TWS solution
        } else if (widget.state.showResultsTWSFirst) {
          showSolutionOWS = false; // Hide OWS solution
          showSolutionTWS = true;
        }
      }
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
  Widget containerSolutionOWS() {
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
            if (safetyOWS == 2 && safetyTWS == 2)
              safeOWSsafeTWS_ows(),
            if (safetyOWS == 1 && safetyTWS == 2)
              unsafeOWSsafeTWS_ows(),
            if (safetyOWS == 2 && safetyTWS == 1)
              safeOWSunsafeTWS_ows(),
            if (safetyOWS == 1 && safetyTWS == 1)
              unsafeOWSunsafeTWS_ows(),
            ],
          ),
        ),
      ),
    );
  }
  Widget safeOWSsafeTWS_ows() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'safe OWS, safe TWS',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget unsafeOWSsafeTWS_ows() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'unsafe OWS, safe TWS',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget safeOWSunsafeTWS_ows() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'safe OWS, unsafe TWS',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget unsafeOWSunsafeTWS_ows() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'unsafe OWS, unsafe TWS',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }

  Widget containerSolutionTWS() {
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
            if (safetyOWS == 2 && safetyTWS == 2)
              safeOWSsafeTWS_tws(),
            if (safetyOWS == 1 && safetyTWS == 2)
              unsafeOWSsafeTWS_tws(),
            if (safetyOWS == 2 && safetyTWS == 1)
              safeOWSunsafeTWS_tws(),
            if (safetyOWS == 1 && safetyTWS == 1)
              unsafeOWSunsafeTWS_tws(),
            ],
          ),
        ),
      ),
    );
  }
  Widget safeOWSsafeTWS_tws() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'safe OWS, safe TWS',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget unsafeOWSsafeTWS_tws() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'unsafe OWS, safe TWS',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget safeOWSunsafeTWS_tws() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'safe OWS, unsafe TWS',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  Widget unsafeOWSunsafeTWS_tws() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'unsafe OWS, unsafe TWS',
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
        modFactor = "Normal-lightweight";
        colClass = null;

        inputColBase.clear();
        inputFootingThickness.clear();
        inputPDL.clear();
        inputPLL.clear();
        inputfcPrime.clear();
        inputDf.clear();
        inputFootingThickness.clear();
        inputDw.clear();

        inputGs.clear();
        inputE.clear();
        inputW.clear();

        inputGammaDry.clear();
        inputGammaMoist.clear();
        inputGammaSat.clear();

        inputQAll.clear();

        inputQUlt.clear();
        inputFS.clear();

        inputFloorLoading.clear();
        inputFloorThickness.clear();
        inputOtherUnitWeight.clear();

        inputTop.clear();
        inputBot.clear();
        inputCc.clear();
        inputYc.clear();
        inputYw.clear();

        setState(() {
          widget.state.weightPressures = false;
          widget.state.topToggle = false;
          widget.state.botToggle = false;
          widget.state.concreteCover = false;
          widget.state.concreteDet = false;
          widget.state.waterDet = false;

          widget.state.showResultsOWSFirst = false;
          widget.state.showResultsTWSFirst = false;
          
          showSolutionOWS = false;
          showSolutionTWS = false;
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
