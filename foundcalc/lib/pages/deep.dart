import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/deep_state.dart';
import 'dart:math';

class DeepPage extends StatefulWidget {
  final String title;
  final DeepState state;
  final Function(DeepState) onStateChanged;

  DeepPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _DeepState createState() => _DeepState();
}

class _DeepState extends State<DeepPage> 
with AutomaticKeepAliveClientMixin<DeepPage>{

  // scrollbar
  late ScrollController _scrollController;

  late TextEditingController inputNq;

  late TextEditingController inputPdim;
  late TextEditingController inputDf;
  late TextEditingController inputDw;
  late TextEditingController inputK;
  late TextEditingController inputFS;

  late TextEditingController inputGs;
  late TextEditingController inputE;
  late TextEditingController inputW;

  late TextEditingController inputGammaDry;
  late TextEditingController inputGammaMoist;
  late TextEditingController inputGammaSat;

  late TextEditingController inputYw;

  late TextEditingController inputMu;
  late TextEditingController inputFrictionAngle;
// alpha
  late TextEditingController inputNc;
  late TextEditingController inputAlpha1;
  late TextEditingController inputAlpha2;
  late TextEditingController inputC1;
  late TextEditingController inputC2;
  late TextEditingController inputQu1;
  late TextEditingController inputQu2;

  late TextEditingController inputLambda;

  late TextEditingController inputThetaR;
  late TextEditingController inputOCR1;
  late TextEditingController inputOCR2;

  late TextEditingController inputS;
  late TextEditingController inputNvert;
  late TextEditingController inputNhori;

  @override
  bool get wantKeepAlive => true; 

  int? singular;
  int? soil;
  int method = 1;
  int? behavior;

  double? nq;
  double? pDim;
  double? df;
  double? dw;
  double? K;
  double? Kfinal;
  double? FS;
  double? gs;
  double? e;
  double? w;
  double? y;
  double? yDry;
  double? ySat;

  double? mu;
  double? frictionAngle;
  double? yw;

  double? nc;
  double? ncFinal;
  double? alpha1;
  double? alpha2;
  double? C1;
  double? C2;
  double? C1final;
  double? C2final;
  double? qu1;
  double? qu2;

  double? lambda;

  double? thetaR;
  double? OCR1;
  double? OCR2;

  double? s;
  double? nVert;
  double? nHori;
  
  int? operation;

  // solvar (solution variables)
  double? muFinal;
  double? ywFinal;
  double? yFinal;

  double? dc;
  double? A;
  bool? waterTable;
  double? Pv1;
  double? Pv2;
  bool? dwLessThanDc;
  double? Qb;
  double? perimeter;
  double? A1;
  double? A2;
  double? A3;
  double? Apv;
  double? Qf;
  double? Qult;
  double? Qall;
  
  double? C;
  double? Qv;

  double? Qave1;
  double? Qave2;
  double? FavePart;
  double? Fave1;
  double? Fave2;

  double? totalN;
  double? QallGroupAction;
  double? Agroup;
  double? Lg;
  double? Bg;
  double? Eg;
  double? minS;
  
  // rounded
  double? roundedAtip;
  double? roundedPerimeter;
  double? roundedPv1;
  double? roundedPv2;
  double? roundedMu;
  double? roundedA1;
  double? roundedA2;
  double? roundedA3;
  double? roundedApv;

  double? roundedQv;

  double? roundedQave1;
  double? roundedQave2;
  double? roundedFave1;
  double? roundedFave2;

  double? roundedBg;
  double? roundedLg;
  double? roundedAgroup;

  // string getters
  String get displayTitle {
    if (widget.title.startsWith('Deep')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Deep Foundation $index";
    }

    return widget.title; 

  }

  String? xsection;
  final List<String> sectionValues = [
    'Circular',
    'Square',
  ];
  String? compaction;
  final List<String> compactionValues = [
    'Densely compacted',
    'Loosely compacted',
  ];
  
  String? consolidation1;
  final List<String> cons1Values = [
    'Normally consolidated',
    'Over consolidated',
  ];
  String? consolidation2;
  final List<String> cons2Values = [
    'Normally consolidated',
    'Over consolidated',
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
  String get alpha1Label {
    if (!widget.state.isGammaSatEnabled) {
      return 'Adhesion factor, α:';
    } else {
      return 'Adhesion factor of the top layer, α₁:';
    }
  }
  String get C1Label {
    if (!widget.state.isGammaSatEnabled) {
      return 'Cohesion, C (in kPa):';
    } else {
      return 'Cohesion of the top layer, C₁ (in kPa):';
    }
  }
  String get Qu1Label {
    if (!widget.state.isGammaSatEnabled) {
      return 'Unconfined compressive strength of the clay, Qu (in kPa):';
    } else {
      return 'Unconfined compressive strength of the clay in the top layer, Qu₁ (in kPa):';
    }
  }
  String get cons1Label {
    if (!widget.state.isGammaSatEnabled) {
      return 'Consolidation of soil:';
    } else {
      return 'Consolidation of soil (top layer):';
    }
  }
  String get pileDimLabel {
    switch (xsection) {
      case 'Square':
        return 'Base of pile, B (in m):';
      case 'Circular':
        return 'Diameter of pile, D (in m):';
      default:
        return 'Dimension of pile (in m):';
    }
  }
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

    // for input
    
    inputPdim = TextEditingController(text: widget.state.inputPdim);
    inputDf = TextEditingController(text: widget.state.inputDf);
    inputDw = TextEditingController(text: widget.state.inputDw);
    inputNq = TextEditingController(text: widget.state.inputNq);
    inputK = TextEditingController(text: widget.state.inputK);
    inputFS = TextEditingController(text: widget.state.inputFS);

    inputGs = TextEditingController(text: widget.state.inputGs);
    inputE = TextEditingController(text: widget.state.inputE);
    inputW = TextEditingController(text: widget.state.inputW);

    inputGammaDry = TextEditingController(text: widget.state.inputGammaDry);
    inputGammaMoist = TextEditingController(text: widget.state.inputGammaMoist);
    inputGammaSat = TextEditingController(text: widget.state.inputGammaSat);

    inputYw = TextEditingController(text: widget.state.inputYw);

    inputMu = TextEditingController(text: widget.state.inputMu);
    inputFrictionAngle = TextEditingController(text: widget.state.inputFrictionAngle);

    inputNc = TextEditingController(text: widget.state.inputNc);
    inputAlpha1 = TextEditingController(text: widget.state.inputAlpha1);
    inputAlpha2 = TextEditingController(text: widget.state.inputAlpha2);
    inputC1 = TextEditingController(text: widget.state.inputC1);
    inputC2 = TextEditingController(text: widget.state.inputC2);
    inputQu1 = TextEditingController(text: widget.state.inputQu1);
    inputQu2 = TextEditingController(text: widget.state.inputQu2);

    inputLambda = TextEditingController(text: widget.state.inputLambda);

    inputThetaR = TextEditingController(text: widget.state.inputThetaR);
    inputOCR1 = TextEditingController(text: widget.state.inputOCR1);
    inputOCR2 = TextEditingController(text: widget.state.inputOCR2);

    inputS = TextEditingController(text: widget.state.inputS);
    inputNvert = TextEditingController(text: widget.state.inputNvert);
    inputNhori = TextEditingController(text: widget.state.inputNhori);

    // for dropdowns

    xsection = widget.state.xsection;

    /*
    calculation = "Factor of safety"; // Set default value here
    widget.state.calculation = calculation;
    */

    // listeners

    inputPdim.addListener(_updateState);
    inputDf.addListener(_updateState);
    inputDw.addListener(_updateState);
    inputNq.addListener(_updateState);
    inputK.addListener(_updateState);
    inputFS.addListener(_updateState);
    
    inputGs.addListener(_updateState);
    inputE.addListener(_updateState);
    inputW.addListener(_updateState);

    inputGammaDry.addListener(_updateState);
    inputGammaMoist.addListener(_updateState);
    inputGammaSat.addListener(_updateState);

    inputYw.addListener(_updateState);

    inputMu.addListener(_updateState);
    inputFrictionAngle.addListener(_updateState);

    inputNc.addListener(_updateState);
    inputAlpha1.addListener(_updateState);
    inputAlpha2.addListener(_updateState);
    inputC1.addListener(_updateState);
    inputC2.addListener(_updateState);
    inputQu1.addListener(_updateState);
    inputQu2.addListener(_updateState);

    inputLambda.addListener(_updateState);

    inputThetaR.addListener(_updateState);
    inputOCR1.addListener(_updateState);
    inputOCR2.addListener(_updateState);

    inputS.addListener(_updateState);
    inputNvert.addListener(_updateState);
    inputNhori.addListener(_updateState);

  }
  void _updateState() {
    setState(() {
      widget.state.inputPdim = inputPdim.text;
      widget.state.inputDf = inputDf.text;
      widget.state.inputDw = inputDw.text;
      widget.state.inputNq = inputNq.text;
      widget.state.inputK = inputK.text;
      widget.state.inputFS = inputFS.text;

      widget.state.inputGs = inputGs.text;
      widget.state.inputE = inputE.text;
      widget.state.inputW = inputW.text;

      widget.state.inputGammaDry = inputGammaDry.text;
      widget.state.inputGammaMoist = inputGammaMoist.text;
      widget.state.inputGammaSat = inputGammaSat.text;
   
      widget.state.inputYw = inputYw.text;

      widget.state.inputMu = inputMu.text;
      widget.state.inputFrictionAngle = inputFrictionAngle.text;

      widget.state.inputNc = inputNc.text;
      widget.state.inputAlpha1 = inputAlpha1.text;
      widget.state.inputAlpha2 = inputAlpha2.text;
      widget.state.inputC1 = inputC1.text;
      widget.state.inputC2 = inputC2.text;
      widget.state.inputQu1 = inputQu1.text;
      widget.state.inputQu2 = inputQu2.text;

      widget.state.inputLambda = inputLambda.text;

      widget.state.inputThetaR = inputThetaR.text;
      widget.state.inputOCR1 = inputOCR1.text;
      widget.state.inputOCR2 = inputOCR2.text;

      widget.state.inputS = inputS.text;
      widget.state.inputNvert = inputNvert.text;
      widget.state.inputNhori = inputNhori.text;

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

      // solve();

      widget.onStateChanged(widget.state);
    });
  }
  void dispose() {
    _scrollController.dispose();

    inputPdim.dispose();
    inputDf.dispose();
    inputDw.dispose();
    inputNq.dispose();
    inputK.dispose();
    inputFS.dispose();

    inputGs.dispose();
    inputE.dispose();
    inputW.dispose();

    inputGammaDry.dispose();
    inputGammaMoist.dispose();
    inputGammaSat.dispose();

    inputYw.dispose();

    inputMu.dispose();
    inputFrictionAngle.dispose();

    inputNc.dispose();
    inputAlpha1.dispose();
    inputAlpha2.dispose();
    inputC1.dispose();
    inputC2.dispose();
    inputQu1.dispose();
    inputQu2.dispose();

    inputLambda.dispose();

    inputThetaR.dispose();
    inputOCR1.dispose();
    inputOCR2.dispose();

    inputS.dispose();
    inputNvert.dispose();
    inputNhori.dispose();
    
    super.dispose();
  }

  void printer() {
    print('pDim = $pDim, Atip = $A, A1 = $A1, A2 = $A2, Qv = $Qv, yFinal = $yFinal, ySat = $ySat, operation = $operation, watertable = $waterTable, C1 = $C1, C2 = $C2, perimeter = $perimeter, showresults = ${widget.state.showResults}, showsSol = ${widget.state.showSolution}, cohesionSwitch = ${widget.state.cohesion}');
    print('Pv1 = $Pv1, Pv2 = $Pv2, Qb = $Qb, Qf = $Qf, Qult = $Qult, Qall = $Qall');
  }

  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
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
  void solve() {
    nq = double.tryParse(inputNq.text);
    pDim = double.tryParse(inputPdim.text);
    df = double.tryParse(inputDf.text);
    dw = double.tryParse(inputDw.text);

    gs = double.tryParse(inputGs.text);
    e = double.tryParse(inputE.text);
    w = double.tryParse(inputW.text);

    y = double.tryParse(inputGammaMoist.text);
    yDry = double.tryParse(inputGammaDry.text);

    yw = double.tryParse(inputYw.text);

    mu = double.tryParse(inputMu.text);
    frictionAngle = double.tryParse(inputFrictionAngle.text);

    FS = double.tryParse(inputFS.text) ?? 3; // Default to 3 if null

    if (widget.state.waterDet) {
      if (yw != null) {
        ywFinal = yw;
      } else {
        ywFinal = null;
      }
    } else {
      ywFinal = 9.81;
    }

    if (widget.state.soilProp) { // Soil Prop is ON
      if (gs != null && e != null && w != null) {
        yFinal = ((gs!*yw!)*(1+w!))/(1+e!);
        ySat = (yw! * (gs! + e!)) / (1 + e!);
      } else if (gs != null && e != null) {
        yFinal = (gs!*yw!)/(1+e!);
        ySat = (yw! * (gs! + e!)) / (1 + e!);
      } else {
        yFinal = null;
        ySat = null;
      }
    } else { // Soil Prop is OFF
      ySat = double.tryParse(inputGammaSat.text);
      if (y != null && yDry == null) {
        yFinal = y;
      } else if (y == null && yDry != null) {
        yFinal = yDry;
      } else {
        yFinal = null;
      }
    }

    if (dw != null && df != null) {
      if (dw! < df!) {
        waterTable = true;
      } else {
        waterTable = false;
      }
    } else if (df != null) {
      waterTable = false;
    } else {
      waterTable = null;
    }

    if (singular == 1) { // singular
      if (soil == 1) { // sand
        operation = 1;
      } else { // clay
        if (method == 1) { // α method
          operation = 2;
        } else if (method == 2) { // λ method
          operation = 3;
        } else { // β method
          operation = 4;
        }
      }
    } else { // group
      if (behavior == 1) { // individually
        operation = 5;
      } else { // as a block
        operation = 6;
      }
    }

    nc = double.tryParse(inputNc.text);
    if (widget.state.ncDet) {
      if (nc != null) {
        ncFinal = nc!;
      } else {
        ncFinal = null;
      }
    } else {
      ncFinal = 9;
    }

    // area and perimeter
    if (pDim != null && xsection != null) {
      if (xsection == 'Circular') {
        A = 0.25 * pi * pDim! * pDim!;
        perimeter = pi * pDim!;
        roundedAtip = roundToFourDecimalPlaces(A!);
        roundedPerimeter = roundToFourDecimalPlaces(perimeter!);
      } else if (xsection == 'Square') {
        A = pDim! * pDim!;
        perimeter = 4 * pDim!;
        roundedAtip = roundToFourDecimalPlaces(A!);
        roundedPerimeter = roundToFourDecimalPlaces(perimeter!);
      } else {
        A = null;
        perimeter = null;
      }
    }

    // main calc
    if (operation == 1) { // sand calc
      if (nq != null && pDim != null && yFinal != null && ywFinal != null && waterTable != null &&
      xsection != null && compaction != null) {
        
        if (compaction == 'Densely compacted') {
          dc = 20 * pDim!;
        } else if (compaction == 'Loosely compacted') {
          dc = 10 * pDim!;
        } else {
          dc = null;
        }

        // bearing capacity
        if (waterTable == false) {
          Pv1 = yFinal! * df!;
          Pv2 = null;
          Qb = Pv1! * nq! * A!;
        } else if (waterTable == true) {
          if (dw != null && dc != null && ySat != null) {
            if (dw! < dc!) {
              Pv1 = yFinal! * dw!;
              Pv2 = Pv1! + (ySat! - ywFinal!) * (dc! - dw!);
              Qb = Pv2! * nq! * A!;
              dwLessThanDc = true;
            } else {
              Pv1 = yFinal! * df!;
              Pv2 = null;
              Qb = Pv1! * nq! * A!;
              dwLessThanDc = false;
            }
          } else {
            Pv1 = null;
            Pv2 = null;
            Qb = null;
          }
        } else {
          Pv1 = null;
          Pv2 = null;
          Qb = null;
        }

        if (Pv1 != null && Pv2 != null) {
          roundedPv1 = roundToFourDecimalPlaces(Pv1!);
          roundedPv2 = roundToFourDecimalPlaces(Pv2!);
        } else if (Pv1 != null) {
          roundedPv1 = roundToFourDecimalPlaces(Pv1!);
        }

        K = double.tryParse(inputK.text);
        if (widget.state.kDet) {
          if (K != null) {
            Kfinal = K;
          } else {
            Kfinal = null;
          }
        } else {
          Kfinal = 1.25;
        }

        if (widget.state.frictionDet) {
          if (mu != null) {
            muFinal = mu!; 
          } else {
            muFinal = null;
          }   
        } else {
          if (frictionAngle != null) {
            muFinal = tan(frictionAngle! * (pi / 180));
          } else {
            muFinal = null;
          }
        }

        if (muFinal != null) {
          roundedMu = roundToFourDecimalPlaces(muFinal!);
        }

        if (dc != null && Pv1 != null) {
          if (waterTable == false) {
            A1 = 0.5 * dc! * Pv1!;
            A2 = (df! - dc!) * Pv1!;
            A3 = 0;
            roundedA1 = roundToFourDecimalPlaces(A1!);
            roundedA2 = roundToFourDecimalPlaces(A2!);
          } else if (waterTable == true) {
            if (dw != null && Pv2 != null) {
              if (dw! < dc!) {
                A1 = 0.5 * dw! * Pv1!;
                A2 = 0.5 * (dc! - dw!) * (Pv1! + Pv2!);
                A3 = (df! - dc!) * Pv2!;
                roundedA1 = roundToFourDecimalPlaces(A1!);
                roundedA2 = roundToFourDecimalPlaces(A2!);
                roundedA3 = roundToFourDecimalPlaces(A3!);
              } else { // Dw ≥ Dc
                A1 = 0.5 * dc! * Pv1!;
                A2 = (df! - dc!) * Pv1!;
                A3 = 0;
                roundedA1 = roundToFourDecimalPlaces(A1!);
                roundedA2 = roundToFourDecimalPlaces(A2!);
              }
            } else {
              A1 = A2 = A3 = null;
            }
          } else {
            A1 = A2 = A3 = null;
          }
        } else {
          A1 = A2 = A3 = null;
        }

        if (A1 != null && A2 != null && A3 != null) {
          Apv = A1! + A2! + A3!;
          roundedApv = roundToFourDecimalPlaces(Apv!);
        } else {
          Apv = null;
        }

        if (Kfinal != null && muFinal != null && perimeter != null && Apv != null) {
          Qf = Kfinal! * muFinal! * perimeter! * Apv!;
        } else {
          Qf = null;
        }

        if (Qb != null && Qf != null) {
          Qult = Qb! + Qf!;
        } else {
          Qult = null;
        }

        if (Qult != null && FS != null) {
          Qall = Qult! / FS!;
        } else {
          Qall = null;
        }
      } else {
        Qb = null;
        Qf = null;
        Qult = null;
        Qall = null;
      }
    } else if (operation == 2) { // alpha calc
      if (ncFinal != null && pDim != null && yFinal != null && ywFinal != null && waterTable != null && xsection != null && A != null && perimeter != null) {
        alpha1 = double.tryParse(inputAlpha1.text);
        alpha2 = double.tryParse(inputAlpha2.text);
        C1 = double.tryParse(inputC1.text);
        C2 = double.tryParse(inputC2.text);
        qu1 = double.tryParse(inputQu1.text);
        qu2 = double.tryParse(inputQu2.text);

        if (widget.state.cohesion) {
          if (waterTable == true) {
            if (C1 != null && C2 != null) {
              C1final = C1!;
              C2final = C2!;  
            } else {
              C1final = null;
              C2final = null;
            }
          } else {
            if (C1 != null) {
              C1final = C1!;
            } else {
              C1final != null;
            }
          }
        } else {
          if (qu1 != null && qu2 != null) {
            C1final = 0.5 * qu1!;
            C2final = 0.5 * qu2!;
          } else {
            C1final = null;
            C2final = null;
          }
        }

        if (nc != null && A != null) {
          if (C1final != null && C2final != null) {
            Qb = C2final! * ncFinal! * A!;
          } else if (C1 != null) {
            Qb = C1final! * ncFinal! * A!;
          } else {
            Qb = null;
          }
        } else {
          Qb = null;
        }

        if (waterTable == false) {
          if (alpha1 != null && C1final != null) {
            Qf = alpha1! * C1final! * perimeter! * df!;
          } else {
            Qf = null;
          }
        } else if (waterTable == true) {
          if (dw != null) {
            if (alpha1 != null && alpha2 != null && C1final != null && C2final != null) {
              Qf = perimeter! * ((alpha1! * C1final! * dw!) + (alpha2! * C2final! * (df! - dw!)));
            } else {
              Qf = null;
            }
          } else { // no Dw
            Qf = null;
          }
        } else { // waterTable = null
          Qf = null;
        }

        if (Qb != null && Qf != null) {
          Qult = Qb! + Qf!;
        } else {
          Qult = null;
        }

        if (Qult != null && FS != null) {
          Qall = Qult! / FS!;
        } else {
          Qall = null;
        }

      } else {
        Qb = null;
        Qf = null;
        Qult = null;
        Qall = null;
      }
    } else if (operation == 3) { // lambda calc
      if (ncFinal != null && pDim != null && yFinal != null && ywFinal != null && waterTable != null && xsection != null && A != null && perimeter != null) {
        C1 = double.tryParse(inputC1.text);
        C2 = double.tryParse(inputC2.text);
        qu1 = double.tryParse(inputQu1.text);
        qu2 = double.tryParse(inputQu2.text);
        lambda = double.tryParse(inputLambda.text);

        if (widget.state.cohesion) {
          if (waterTable == true) {
            if (C1 != null && C2 != null) {
              C1final = C1!;
              C2final = C2!;  
            } else {
              C1final = null;
              C2final = null;
            }
          } else {
            if (C1 != null) {
              C1final = C1!;
            } else {
              C1final != null;
            }
          }
        } else {
          if (qu1 != null && qu2 != null) {
            C1final = 0.5 * qu1!;
            C2final = 0.5 * qu2!;
          } else {
            C1final = null;
            C2final = null;
          }
        }

        if (nc != null) {
          if (C1final != null && C2final != null) {
            Qb = C2final! * ncFinal! * A!;
          } else if (C1final != null) {
            Qb = C1final! * ncFinal! * A!;
          } else {
            Qb = null;
          }
        } else {
          Qb = null;
        }

        if (waterTable == false) {
          Pv1 = yFinal! * df!;
          Pv2 = null;
        } else if (waterTable == true) {
          if (dw != null && ySat != null) {
            Pv1 = yFinal! * dw!;
            Pv2 = Pv1! + (ySat! - ywFinal!) * (df! - dw!);
          } else {
            Pv1 = null;
            Pv2 = null;
          }
        } else {
          Pv1 = null;
          Pv2 = null;
        }

        if (C1final != null && lambda != null) {
          if (waterTable == false) {
            C = C1final;
            A1 = 0.5 * Pv1! * df!;
            A2 = null;
            Qv = Pv1! / 2;
            Qf = perimeter! * df! * lambda! * (Qv! + 2*C!);
          } else if (waterTable == true) {
            if (dw != null) {
              if (C2final != null && Pv2 != null) {
                C = ((C1final! * dw!) + (C2final! * (df! - dw!))) / df!;
                A1 = 0.5 * Pv1! * dw!;
                A2 = 0.5 * (Pv1! + Pv2!) * (df! - dw!);
                Qv = (A1! + A2!) / df!;
                Qf = perimeter! * df! * lambda! * (Qv! + 2*C!);
              } else {
                C = null;
                A1 = null;
                A2 = null;
                Qv = 4;
                Qf = null;
              }
            } else { // no Dw
              C = null;
              A1 = null;
              A2 = null;
              Qv = 3;
              Qf = null;
            }
          } else { // waterTable = null
            C = null;
            A1 = null;
            A2 = null;
            Qv = 2;
            Qf = null;
          }
        } else { // no perimeter, lambda, C1 and PV1
          Qf = null;
          C = null;
          A1 = null;
          A2 = null;
          Qv = 1;
          Qf = null;
        }

        if (Qv != null) {
          roundedQv = roundToFourDecimalPlaces(Qv!);
        }

        if (Qb != null && Qf != null) {
          Qult = Qb! + Qf!;
        } else {
          Qult = null;
        }

        if (Qult != null && FS != null) {
          Qall = Qult! / FS!;
        } else {
          Qall = null;
        }

      } else {
        Qb = null;
        Qf = null;
        Qult = null;
        Qall = null;
      }
    } else if (operation == 4) { // beta calc
      if (ncFinal != null && pDim != null && yFinal != null && ywFinal != null && waterTable != null && xsection != null && A != null && perimeter != null) {
        C1 = double.tryParse(inputC1.text);
        C2 = double.tryParse(inputC2.text);
        qu1 = double.tryParse(inputQu1.text);
        qu2 = double.tryParse(inputQu2.text);
        thetaR = double.tryParse(inputThetaR.text);
        OCR1 = double.tryParse(inputOCR1.text);
        OCR2 = double.tryParse(inputOCR2.text);

        if (widget.state.cohesion) {
          if (waterTable == true) {
            if (C1 != null && C2 != null) {
              C1final = C1!;
              C2final = C2!;  
            } else {
              C1final = null;
              C2final = null;
            }
          } else {
            if (C1 != null) {
              C1final = C1!;
            } else {
              C1final != null;
            }
          }
        } else {
          if (qu1 != null && qu2 != null) {
            C1final = 0.5 * qu1!;
            C2final = 0.5 * qu2!;
          } else {
            C1final = null;
            C2final = null;
          }
        }

        if (thetaR != null) { //klklkl
          FavePart = (1 - sin(thetaR! * pi / 180)) * tan(thetaR! * pi / 180);
        } else {
          FavePart = null;
        }


        if (C1final != null && C2final != null) {
          Qb = C2final! * ncFinal! * A!;
        } else if (C1final != null) {
          Qb = C1final! * ncFinal! * A!;
        } else {
          Qb = null;
        }

        if (FavePart != null) {
          if (waterTable == false) {
            Qave1 = yFinal! * 0.5 * df!;
            if (consolidation1 == 'Normally consolidated') {
              Fave1 = FavePart! * Qave1!;
              Qf = perimeter! * df! * Fave1!;
            } else if (consolidation1 == 'Over consolidated') {
              if (OCR1 != null) {
                Fave1 = FavePart! * Qave1! * sqrt(OCR1!);
                Qf = perimeter! * df! * Fave1!;
              } else {
                Fave1 = null;
                Qf = null;
              }
            } else {
              Fave1 = null;
              Qf = null;
            }
          } else if (waterTable == true) {
            if (dw != null && ySat != null) {
              Qave1 = yFinal! * 0.5 * dw!;
              Qave2 = (yFinal! * dw!) + (ySat! - ywFinal!) * 0.5 * (df! - dw!);
              if (consolidation1 == 'Normally consolidated') {
                Fave1 = FavePart! * Qave1!;
              } else if (consolidation1 == 'Over consolidated') {
                if (OCR1 != null) {
                  Fave1 = FavePart! * Qave1! * sqrt(OCR1!);
                } else {
                  Fave1 = null;
                }
              } else {
                Fave1 = null;
              }
              if (consolidation2 == 'Normally consolidated') {
                Fave2 = FavePart! * Qave2!;
              } else if (consolidation2 == 'Over consolidated') {
                if (OCR2 != null) {
                  Fave2 = FavePart! * Qave2! * sqrt(OCR2!);
                } else {
                  Fave2 = null;
                }
              } else {
                Fave2 = null;
              }

              if (Fave1 != null && Fave2 != null) {
                Qf = perimeter! * ((dw! * Fave1!) + ((df! - dw!) * Fave2!));
              } else {
                Qf = null;
              }
            } else { // no Dw
              Qf = null;
            }
          } else { // waterTable = null
            Qf = null;
          }
        } else { // no perimeter
          Qf = null;
        }

        if (Fave1 != null && Fave2 != null && Qave1 != null && Qave2 != null) {
          roundedFave1 = roundToFourDecimalPlaces(Fave1!);
          roundedFave2 = roundToFourDecimalPlaces(Fave2!);
          roundedQave1 = roundToFourDecimalPlaces(Qave1!);
          roundedQave2 = roundToFourDecimalPlaces(Qave2!);
        } else if (Fave1 != null && Qave1 != null) {
          roundedFave1 = roundToFourDecimalPlaces(Fave1!);
          roundedFave2 = null;
          roundedQave1 = roundToFourDecimalPlaces(Qave1!);
          roundedQave2 = null;
        } else {
          roundedFave1 = null;
          roundedFave2 = null;
          roundedQave1 = null;
          roundedQave2 = null;
        }

        if (Qb != null && Qf != null) {
          Qult = Qb! + Qf!;
        } else {
          Qult = null;
        }

        if (Qult != null && FS != null) {
          Qall = Qult! / FS!;
        } else {
          Qall = null;
        }
      } else {
        Qb = null;
        Qf = null;
        Qult = null;
        Qall = null;
      }
    } else if (operation == 5) { // indiv calc
      if (ncFinal != null && pDim != null && yFinal != null && ywFinal != null && waterTable != null && xsection != null && A != null && perimeter != null) {
        C1 = double.tryParse(inputC1.text);
        C2 = double.tryParse(inputC2.text);
        qu1 = double.tryParse(inputQu1.text);
        qu2 = double.tryParse(inputQu2.text);
        s = double.tryParse(inputS.text);
        nVert = double.tryParse(inputNhori.text);
        nHori = double.tryParse(inputNvert.text);

        if (widget.state.cohesion) {
          if (waterTable == true) {
            if (C1 != null && C2 != null) {
              C1final = C1!;
              C2final = C2!;  
            } else {
              C1final = null;
              C2final = null;
            }
          } else {
            if (C1 != null) {
              C1final = C1!;
            } else {
              C1final != null;
            }
          }
        } else {
          if (qu1 != null && qu2 != null) {
            C1final = 0.5 * qu1!;
            C2final = 0.5 * qu2!;
          } else {
            C1final = null;
            C2final = null;
          }
        }

        if (nHori != null && nVert != null && s != null) {
          totalN = nVert! * nHori!;
          Eg = (((2 * s!) * (nHori! + nVert! - 2)) + (4 * pDim!)) / (perimeter! * nHori! * nVert!);
          minS = (0.5 * ((perimeter! * nHori! * nVert!) - (4 * pDim!))) / (nHori! + nVert! - 2);
          widget.state.Eg = roundToFourDecimalPlaces(Eg!);
          widget.state.minS = roundToFourDecimalPlaces(minS!);
        }

        if (totalN != null) {
          if (C1final != null && C2final != null) {
            Qb = C2final! * ncFinal! * A!  * totalN!;
          } else if (C1final != null) {
            Qb = C1final! * ncFinal! * A!  * totalN!;
          } else {
            Qb = null;
          }
        } else {
          Qb = null;
        }

        if (C1final != null) {
          if (waterTable == false) {
            Qf = C1final! * perimeter! * df!;
          } else if (waterTable == true) {
            if (dw != null) {
              if (C1final != null && C2final != null) {
                Qf = perimeter! * ((C1final! * dw!) + (C2final! * (df! - dw!)));
              } else {
                Qf = null;
              }
            } else { // no Dw
              Qf = null;
            }
          } else { // waterTable = null
            Qf = null;
          }

          if (Qb != null && Qf != null) {
            Qult = Qb! + Qf!;
          } else {
            Qult = null;
          }

          if (Qult != null && FS != null) {
            Qall = Qult! / FS!;
          } else {
            Qall = null;
          }

          if (Qall != null && Eg != null) {
            QallGroupAction = Qall! * Eg!;
            widget.state.QallGroupAction = roundToFourDecimalPlaces(QallGroupAction!);
          } else {
            QallGroupAction = null;
            widget.state.QallGroupAction = null;
          }

        }
      } else {
        Qb = null;
        Qf = null;
        Qult = null;
        Qall = null;
        Eg = null;
        minS = null;
      }
    } else { // operation == 6; group calc
      if (ncFinal != null && pDim != null && yFinal != null && ywFinal != null && waterTable != null && xsection != null && A != null && perimeter != null) {
        C1 = double.tryParse(inputC1.text);
        C2 = double.tryParse(inputC2.text);
        qu1 = double.tryParse(inputQu1.text);
        qu2 = double.tryParse(inputQu2.text);
        s = double.tryParse(inputS.text);
        nVert = double.tryParse(inputNhori.text);
        nHori = double.tryParse(inputNvert.text);

        if (widget.state.cohesion) {
          if (waterTable == true) {
            if (C1 != null && C2 != null) {
              C1final = C1!;
              C2final = C2!;  
            } else {
              C1final = null;
              C2final = null;
            }
          } else {
            if (C1 != null) {
              C1final = C1!;
            } else {
              C1final != null;
            }
          }
        } else {
          if (qu1 != null && qu2 != null) {
            C1final = 0.5 * qu1!;
            C2final = 0.5 * qu2!;
          } else {
            C1final = null;
            C2final = null;
          }
        }

        if (nHori != null && nVert != null && s != null) {
          Lg = (((nHori! - 1) * s!) + pDim!);
          Bg = (((nVert! - 1) * s!) + pDim!);
          Agroup = Lg! * Bg!;
          roundedLg = roundToFourDecimalPlaces(Lg!);
          roundedBg = roundToFourDecimalPlaces(Bg!);
          roundedAgroup = roundToFourDecimalPlaces(Agroup!);
          Eg = (((2 * s!) * (nHori! + nVert! - 2)) + (4 * pDim!)) / (perimeter! * nHori! * nVert!);
          minS = (0.5 * ((perimeter! * nHori! * nVert!) - (4 * pDim!))) / (nHori! + nVert! - 2);
          widget.state.Eg = roundToFourDecimalPlaces(Eg!);
          widget.state.minS = roundToFourDecimalPlaces(minS!);
        } else {
          Lg = null;
          Bg = null;
          Agroup = null;
          roundedLg = null;
          roundedBg = null;
          roundedAgroup = null;
          Eg = null;
          minS = null;
          widget.state.Eg = null;
          widget.state.minS = null;
        }

        if (Agroup != null) {
          if (C1final != null && C2final != null) {
            Qb = C2final! * ncFinal! * Agroup!;
          } else if (C1final != null) {
            Qb = C1final! * ncFinal! * Agroup!;
          } else {
            Qb = null;
          }
        } else {
          Qb = null;
        }

        if (C1final != null) {
          if (waterTable == false) {
            Qf = C1final! * perimeter! * df!;
          } else if (waterTable == true) {
            if (dw != null) {
              if (C1final != null && C2final != null) {
                Qf = perimeter! * ((C1final! * dw!) + (C2final! * (df! - dw!)));
              } else {
                Qf = null;
              }
            } else { // no Dw
              Qf = null;
            }
          } else { // waterTable = null
            Qf = null;
          }

          if (Qb != null && Qf != null) {
            Qult = Qb! + Qf!;
          } else {
            Qult = null;
          }

          if (Qult != null && FS != null) {
            Qall = Qult! / FS!;
          } else {
            Qall = null;
          }



        }

      }
    }

    if (operation == 1) {
      if (Qb != null && Qf != null && Qult != null && Qall != null) {
        widget.state.Qb = roundToFourDecimalPlaces(Qb!);
        widget.state.Qf = roundToFourDecimalPlaces(Qf!);
        widget.state.Qult = roundToFourDecimalPlaces(Qult!);
        widget.state.Qall = roundToFourDecimalPlaces(Qall!);
        setState(() {
          widget.state.showResults = true;
        });
        return;
      } else {
        showSnackBarIncorrect(context);
        setState(() {
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
        return;
      }
    } else if (operation == 2 || operation == 3 || operation == 4) {
      if (waterTable == false) {
        if (Qb != null && Qf != null && Qult != null && Qall != null && C1final != null) {
          widget.state.Qb = roundToFourDecimalPlaces(Qb!);
          widget.state.Qf = roundToFourDecimalPlaces(Qf!);
          widget.state.Qult = roundToFourDecimalPlaces(Qult!);
          widget.state.Qall = roundToFourDecimalPlaces(Qall!);
          setState(() {
            widget.state.showResults = true;
          });
        } else {
          showSnackBarIncorrect(context);
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          return;
        }
      } else if (waterTable == true) {
        if (Qb != null && Qf != null && Qult != null && Qall != null && C1final != null && C2final != null) {
          widget.state.Qb = roundToFourDecimalPlaces(Qb!);
          widget.state.Qf = roundToFourDecimalPlaces(Qf!);
          widget.state.Qult = roundToFourDecimalPlaces(Qult!);
          widget.state.Qall = roundToFourDecimalPlaces(Qall!);
          setState(() {
            widget.state.showResults = true;
          });
        } else {
          showSnackBarIncorrect(context);
          setState(() {
            widget.state.showResults = false;
            widget.state.showSolution = false;
            widget.state.solutionToggle = true;
          });
          return;
        }
      } else {
        showSnackBarIncorrect(context);
        setState(() {
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
        return;
      }
    } else { // operation == 5 || operation == 6
      if (Qb != null && Qf != null && Qult != null && Qall != null && Eg != null && minS != null && C1final != null && C2final != null) {
        widget.state.Qb = roundToFourDecimalPlaces(Qb!);
        widget.state.Qf = roundToFourDecimalPlaces(Qf!);
        widget.state.Qult = roundToFourDecimalPlaces(Qult!);
        widget.state.Qall = roundToFourDecimalPlaces(Qall!);
        setState(() {
          widget.state.showResults = true;
        });
      } else {
        showSnackBarIncorrect(context);
        setState(() {
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
      }
    }

    /*
    if (operation == 1 || operation == 2 || operation == 3 || operation == 4) {
      if (widget.state.Qb == null && widget.state.Qf == null && widget.state.Qult == null && widget.state.Qall == null) {
        setState(() {
          showSnackBarIncorrect(context);
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
        dwLessThanDc = true; // ololol
      } else {
        setState(() {
          widget.state.showResults = true;
        });
      }
    } else { // operation == 5 || operation == 6
      if (widget.state.Qb != null && widget.state.Qf != null && widget.state.Qult != null && widget.state.Qall != null && widget.state.Eg != null && widget.state.minS != null) {
        setState(() {
          widget.state.showResults = true;
        });
      } else {
        setState(() {
          showSnackBarIncorrect(context);
          widget.state.showResults = false;
          widget.state.showSolution = false;
          widget.state.solutionToggle = true;
        });
      }
    }
    */

    printer();
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
                      headerSingle(),
                      radioSingle(),

                      if (singular == 1)
                        headerSoil(),
                      if (singular == 1)
                        radioSoil(),

                      if (singular == 1 && soil == 2)
                        headerMethod(),
                      if (singular == 1 && soil == 2)
                        radioMethod(),

                      if (singular == 2)
                        headerBehavior(),
                      if (singular == 2)
                        radioBehavior(),

                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                        dropdownXsection(),

                      if (singular == 1 && soil == 1)
                        dropdownCompact(),

                      if (singular == 1 && soil == 2 && method == 3)
                        dropdownCons1(),
                      if (singular == 1 && soil == 2 && method == 3 && consolidation1 == 'Over consolidated')
                        entryOCR1(),
                      if (singular == 1 && soil == 2 && method == 3 && widget.state.isGammaSatEnabled)
                        dropdownCons2(),
                      if (singular == 1 && soil == 2 && method == 3 && consolidation2 == 'Over consolidated')
                        entryOCR2(),

                      if (singular == 1 && soil == 1)
                        entryNq(),

                      if (singular == 1 && soil == 2 && method == 1)
                        entryAlpha1(),
                      if (singular == 1 && soil == 2 && method == 1 && widget.state.isGammaSatEnabled)
                        entryAlpha2(),

                      if (singular == 1 && soil == 2 && method == 2)
                        entryLambda(),

                      if (singular == 1 && soil == 2 && method == 3)
                        entryThetaR(),

                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                        entryPdim(),

                      if (singular == 2)
                        entryS(),
                      if (singular == 2)
                        entryNhori(),
                      if (singular == 2)
                        entryNvert(),

                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                        entryDf(),

                      // optional 
                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                        entryDw(),
                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                        entryFS(),

                      // switching containers
                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                        switchSoilProp(),
                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                        Stack(
                          children: [
                            containerSoilPropOn(),
                            containerSoilPropOff(),
                          ]
                        ),

                      if ((singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3)) || (singular == 2))
                        switchCohesion(),
                      if ((singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3)) || (singular == 2))
                        Stack(
                          children: [
                            containerCohesionOn(),
                            containerCohesionOff(),
                          ]
                        ),

                      // optional containers
                      if (singular == 1 && soil == 1)
                        switchFriction(),
                      if (singular == 1 && soil == 1)
                        Stack(
                          children: [
                            containerFrictionOn(),
                            containerFrictionOff(),
                          ]
                        ),

                      if (widget.state.isGammaSatEnabled)
                        switchWaterDet(),
                      if (widget.state.isGammaSatEnabled)
                        containerWaterOn(),

                      if (singular == 1 && soil == 1)
                        switchKDet(),
                      if (singular == 1 && soil == 1)
                        containerKOn(),

                      if ((singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3)) || (singular == 2))
                        switchNc(),
                      if ((singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3)) || (singular == 2))
                        containerNcOn(),

                      SizedBox(height: 10),
                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
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
                      
                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
                      SizedBox(height: 10),
                      if ((singular == 1 && soil == 1) || (singular == 1 && soil == 2 && (method == 1 || method == 2 || method == 3))
                      || singular == 2) // all included
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

  Widget headerSingle() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        'Select calculation type:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerSingle
  Widget radioSingle() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxWidth: 450),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: singular,
                  onChanged: (val) {
                    setState(() {
                      singular = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Singular pile',
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
                  groupValue: singular,
                  onChanged: (val) {
                    setState(() {
                      singular = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Group of piles',
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
  
  Widget headerSoil() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        'Type of soil:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerSoil
  Widget radioSoil() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxWidth: 450),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: soil,
                  onChanged: (val) {
                    setState(() {
                      soil = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Piles on sand',
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
                  groupValue: soil,
                  onChanged: (val) {
                    setState(() {
                      soil = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Piles on clay',
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
  
  Widget headerMethod() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        'Select method:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerMethod
  Widget radioMethod() {
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
                  groupValue: method,
                  onChanged: (val) {
                    setState(() {
                      method = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'α method',
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
                  groupValue: method,
                  onChanged: (val) {
                    setState(() {
                      method = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'λ method',
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
                  groupValue: method,
                  onChanged: (val) {
                    setState(() {
                      method = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'β method',
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
  
  Widget headerBehavior() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        'Behavior of piles:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  } // headerBehavior
  Widget radioBehavior() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxWidth: 450),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: behavior,
                  onChanged: (val) {
                    setState(() {
                      behavior = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Piles act individually',
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
                  groupValue: behavior,
                  onChanged: (val) {
                    setState(() {
                      behavior = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Piles act as a block',
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
  
  Widget dropdownXsection() {
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
                'Cross section of pile:',
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
                value: xsection,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    xsection = newValue;
                    });
                  },
                items: sectionValues.map((String value) {
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
  } // dropdownXsection
  Widget dropdownCompact() {
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
                'Type of compaction:',
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
                value: compaction,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    compaction = newValue;
                    });
                  },
                items: compactionValues.map((String value) {
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
  } // dropdownCompact
  
  Widget entryNq() {
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
                  'Bearing capacity factor, Nq:',
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
                    controller: inputNq, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputNq.clear();
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
  } // entryNq
  Widget entryPdim() {
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
                  pileDimLabel,
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
                    controller: inputPdim,
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
                          inputPdim.clear();
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
  } // entryPdim
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
                  'Length of pile, L (in m):',
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
  Widget entryFS() {
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
                    controller: inputFS, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputFS.clear();
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
  } // entryFS

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

  Widget switchFriction() {
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
                  'Coefficient of friction',
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
                    value: widget.state.frictionDet,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.frictionDet = newValue;
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
  } // switchFriction
  
  Widget containerFrictionOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.frictionDet,
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
                subMu(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerFrictionOn
  Widget subMu() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Coefficient of friction, μ:',
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
                  controller: inputMu,
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
                        inputMu.clear();
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
  } // subMu
 
  Widget containerFrictionOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.frictionDet,
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
                  subFrictionAngle(),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  } // containerFrictionOff
  Widget subFrictionAngle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Angle of friction between the pile and the sand, θ (in degrees):',
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
                  controller: inputFrictionAngle,
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
                        inputFrictionAngle.clear();
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
  } // subFrictionAngle
  
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

  Widget switchKDet() {
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
                  'Shaft lateral pressure factor (assumed as 1.25 if not given)',
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
                    value: widget.state.kDet,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.kDet = newValue;
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
  } // switchKDet
  Widget containerKOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.kDet,
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
                subK(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerKOn
  Widget subK() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Shaft lateral pressure factor, K:',
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
                  controller: inputK,
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
                        inputK.clear();
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
  } // subK
// clay
  Widget switchNc() {
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
                  'Cohesion factor (assumed as 9 if not given)',
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
                    value: widget.state.ncDet,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.ncDet = newValue;
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
  } // switchNc
  Widget containerNcOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.ncDet,
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
                subNc(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerNcOn
  Widget subNc() {
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
                  controller: inputNc,
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
                        inputNc.clear();
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
  } // subNc

// alpha
  Widget entryAlpha1() {
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
                  alpha1Label,
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
                    controller: inputAlpha1, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputAlpha1.clear();
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
  } // entryAlpha1
  Widget entryAlpha2() {
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
                  "Adhesion factor of the bottom layer, α₂:",
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
                    controller: inputAlpha2, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputAlpha2.clear();
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
  } // entryAlpha2

  Widget switchCohesion() {
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
                  'Cohesion',
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
                    value: widget.state.cohesion,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.cohesion = newValue;
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
  } // switchCohesion
  
  Widget containerCohesionOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.cohesion,
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
                subC1(),
                if (widget.state.isGammaSatEnabled)
                  subC2(),
              ]
            ),
          ),
        ),
      ),
    );
  } // containerCohesionOn
  Widget subC1() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                C1Label,
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
                  controller: inputC1,
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
                        inputC1.clear();
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
  Widget subC2() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Cohesion of the bottom layer, C₂ (in kPa):',
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
                  controller: inputC2,
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
                        inputC2.clear();
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
  } // subC2

  Widget containerCohesionOff() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: !widget.state.cohesion,
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
                  subQu1(),
                  if (widget.state.isGammaSatEnabled)
                    subQu2(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // containerCohesionOff
  Widget subQu1() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                Qu1Label,
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
                  controller: inputQu1,
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
                        inputQu1.clear();
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
  } // subQu1
  Widget subQu2() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Unconfined compressive strength of the clay in the bottom layer, Qu₂ (in kPa):',
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
                  controller: inputQu2,
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
                        inputQu2.clear();
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
  } // subQu2
// lambda
  Widget entryLambda() {
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
                  'λ:',
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
                    controller: inputLambda, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputLambda.clear();
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
  } // entryLambda
// beta
  Widget entryThetaR() {
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
                  'Drained friction angle of the remolded clay, θʀ (in degrees):',
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
                    controller: inputThetaR, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputThetaR.clear();
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
  } // entryThetaR
  Widget dropdownCons1() {
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
                cons1Label,
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
                value: consolidation1,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    consolidation1 = newValue;
                    });
                  },
                items: cons1Values.map((String value) {
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
  } // dropdownCons1
  Widget entryOCR1() {
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
                  'Over consolidation ratio (OCR):',
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
                    controller: inputOCR1, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputOCR1.clear();
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
  } // entryOCR1
  Widget dropdownCons2() {
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
                'Consolidation of soil (bottom layer):',
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
                value: consolidation2,
                hint: Text('Select option', style: TextStyle(color: Colors.white54)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    consolidation2 = newValue;
                    });
                  },
                items: cons2Values.map((String value) {
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
  } // dropdownCons2
  Widget entryOCR2() {
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
                  'Over consolidation ratio (OCR):',
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
                    controller: inputOCR2, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputOCR2.clear();
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
  } // entryOCR2
// group
  Widget entryS() {
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
                  'Spacing between piles, s (in m):',
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
                    controller: inputS, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
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
                          inputS.clear();
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
  } // entryS
  Widget entryNhori() {
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
                  'Number of columns in plan view, m',
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
                    controller: inputNhori, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allows only whole numbers
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
                          inputNhori.clear();
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
  } // entryNhori
  Widget entryNvert() {
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
                  'Number of rows in plan view, n',
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
                    controller: inputNvert, //Ito yun pampalagay sa variable hahaha. Dapat di to mawawala
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allows only whole numbers
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
                          inputNvert.clear();
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
  } // entryNvert
    
// ////////////////////////////////////
  Widget buttonSubmit() {
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
  Widget resultText() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              "Bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qb = ${widget.state.Qb} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            /////////////////
            Text(
              "Frictional capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qf = ${widget.state.Qf} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Ultimate bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qult = ${widget.state.Qult} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Allowable bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall = ${widget.state.Qall} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (operation == 5 || operation == 6)
              Text(
                "Group efficiency, Eg = ${widget.state.Eg}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (operation == 5 || operation == 6)
              Text(
              "Minimum pile spacing to be",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (operation == 5 || operation == 6)
              Text(
                "100% efficient = ${widget.state.minS} m",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        )
      )
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
              if (operation == 1) 
                solution1(),
              if (operation == 2) 
                solution2(),
              if (operation == 3) 
                solution3(),
              if (operation == 4) 
                solution4(),
              if (operation == 5) 
                solution5(),
              if (operation == 6) 
                solution6(),
            ],
          ),
        ),
      ),
    );
  }
  // sand
  Widget solution1() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Atip = $roundedAtip m²',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Pv₁ = $roundedPv1 kPa',
              style: TextStyle(color: Colors.white),
            ),
            if (waterTable == true)
              Text(
                'Pv₂ = $roundedPv2 kPa',
                style: TextStyle(color: Colors.white),
              ),
            Text(
              "Bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qb = ${widget.state.Qb} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Critical depth, Dc = $dc',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'μ = $roundedMu',
              style: TextStyle(color: Colors.white),
            ),
            /////////////////////////////////////////
            if (waterTable == false || dwLessThanDc == false)
              Text(
                'Area from 0 m to $dc m',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == false || dwLessThanDc == false)
              Text(
                'A₁ = $roundedA1',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == false || dwLessThanDc == false)
              Text(
                'Area from $dc m to $df m',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == false || dwLessThanDc == false)
              Text(
                'A₂ = $roundedA2',
                style: TextStyle(color: Colors.white),
              ),
            ////////////////////////
            if (dwLessThanDc == true)
              Text(
                'Area from 0 m to $dw m',
                style: TextStyle(color: Colors.white),
              ),
            if (dwLessThanDc == true)
              Text(
                'A₁ = $roundedA1',
                style: TextStyle(color: Colors.white),
              ),
            if (dwLessThanDc == true)
              Text(
                'Area from $dw m to $dc m',
                style: TextStyle(color: Colors.white),
              ),
            if (dwLessThanDc == true)
              Text(
                'A₂ = $roundedA2',
                style: TextStyle(color: Colors.white),
              ),
            if (dwLessThanDc == true)
              Text(
                'Area from $dc m to $df m',
                style: TextStyle(color: Colors.white),
              ),
            if (dwLessThanDc == true)
              Text(
                'A₃ = $roundedA3',
                style: TextStyle(color: Colors.white),
              ),
            /////////////////
            Text(
              'Apv = $roundedApv',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'P = $roundedPerimeter m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Frictional capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qf = ${widget.state.Qf} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Ultimate bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qult = ${widget.state.Qult} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Allowable bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall = ${widget.state.Qall} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
  // alpha
  Widget solution2() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Atip = $roundedAtip m²',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qb = ${widget.state.Qb} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            /////////////////
            Text(
              'P = $roundedPerimeter m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Frictional capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qf = ${widget.state.Qf} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Ultimate bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qult = ${widget.state.Qult} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Allowable bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall = ${widget.state.Qall} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
  // lambda (sol3)
  Widget solution3() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Atip = $roundedAtip m²',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qb = ${widget.state.Qb} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Pv₁ = $roundedPv1 kPa',
              style: TextStyle(color: Colors.white),
            ),
            if (waterTable == true)
              Text(
                'Pv₂ = $roundedPv2 kPa',
                style: TextStyle(color: Colors.white),
              ),
            /////////////////////////////////////////
            if (waterTable == false)
              Text(
                'Area from 0 m to $df m',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == false)
              Text(
                'A₁ = $roundedA1',
                style: TextStyle(color: Colors.white),
              ),
            /////////////////////////////////////////
            if (waterTable == true)
              Text(
                'Area from 0 m to $dw m',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == true)
              Text(
                'A₁ = $roundedA1',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == true)
              Text(
                'Area from $dw m to $df m',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == true)
              Text(
                'A₂ = $roundedA2',
                style: TextStyle(color: Colors.white),
              ),
            /////////////////
            Text(
              'Apv = $roundedApv',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Qᵥ = $roundedQv',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'P = $roundedPerimeter m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Frictional capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qf = ${widget.state.Qf} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Ultimate bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qult = ${widget.state.Qult} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Allowable bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall = ${widget.state.Qall} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
  // beta (sol4)
  Widget solution4() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Atip = $roundedAtip m²',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qb = ${widget.state.Qb} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            /////////////////////////////////////////
            if (waterTable == false)
              Text(
                'Qave = $roundedQave1',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == false)
              Text(
                'Fave = $roundedFave1',
                style: TextStyle(color: Colors.white),
              ),
            /////////////////////////////////////////
            if (waterTable == true)
              Text(
                'Qave₁ = $roundedQave1',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == true)
              Text(
                'Qave₂ = $roundedQave2',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == true)
              Text(
                'Fave₁ = $roundedFave1',
                style: TextStyle(color: Colors.white),
              ),
            if (waterTable == true)
              Text(
                'Fave₂ = $roundedFave2',
                style: TextStyle(color: Colors.white),
              ),
            /////////////////
            Text(
              'P = $roundedPerimeter m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Frictional capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qf = ${widget.state.Qf} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Ultimate bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qult = ${widget.state.Qult} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Allowable bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall = ${widget.state.Qall} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
  // indiv
  Widget solution5() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Atip = $roundedAtip m²',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Total number of piles = $totalN',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qb = ${widget.state.Qb} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            /////////////////
            Text(
              'P = $roundedPerimeter m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Frictional capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qf = ${widget.state.Qf} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Ultimate bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qult = ${widget.state.Qult} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Allowable bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall = ${widget.state.Qall} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Group efficiency, Eg = ${widget.state.Eg}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall considering group action = ${widget.state.QallGroupAction} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Minimum pile spacing to be 100% efficient = ${widget.state.minS}m",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
  // group
  Widget solution6() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Bg = $roundedBg m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Lg = $roundedLg m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'A = $roundedAgroup m²',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qb = ${widget.state.Qb} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            /////////////////
            Text(
              'P = $roundedPerimeter m',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Frictional capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qf = ${widget.state.Qf} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Ultimate bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qult = ${widget.state.Qult} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Allowable bearing capacity of pile,",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Qall = ${widget.state.Qall} kPa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Group efficiency, Eg = ${widget.state.Eg}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Minimum pile spacing to be",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "100% efficient = ${widget.state.minS} m",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
  

  Widget clearButton() {
    return ElevatedButton(
      onPressed: () { 
        xsection = null;
        compaction = null;
        consolidation1 = null;
        consolidation2 = null;

        inputPdim.clear();
        inputDf.clear();
        inputDw.clear();
        inputNq.clear();
        inputK.clear();
        inputFS.clear();

        inputGs.clear();
        inputE.clear();
        inputW.clear();

        inputGammaDry.clear();
        inputGammaMoist.clear();
        inputGammaSat.clear();

        inputYw.clear();

        inputMu.clear();
        inputFrictionAngle.clear();

        inputNc.clear();
        inputAlpha1.clear();
        inputAlpha2.clear();
        inputC1.clear();
        inputC2.clear();
        inputQu1.clear();
        inputQu2.clear();
        
        inputLambda.clear();

        inputThetaR.clear();
        inputOCR1.clear();
        inputOCR2.clear();
                                
        inputS.clear();
        inputNvert.clear();
        inputNhori.clear();
        
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
  
  // for FAB to scroll to top
  @override
  void didUpdateWidget(DeepPage oldWidget) {
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