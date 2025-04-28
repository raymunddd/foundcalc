import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
  late TextEditingController inputk1;
  late TextEditingController inputk2;
  late TextEditingController inputActiveGamma;
  late TextEditingController inputActiveSoilFrictionAngle;
  late TextEditingController inputActiveEarthPressure;
  late TextEditingController inputActiveCohesion;
  late TextEditingController input_D;
  late TextEditingController input_H;
  late TextEditingController input_a;
  late TextEditingController input_b;
  late TextEditingController input_c;
  late TextEditingController input_d;
  late TextEditingController input_e;
  late TextEditingController input_f;
  late TextEditingController inputYc;
  late TextEditingController inputStripLength;

  String? KaString;
  double? incline;
  double? g;
  double? mu;
  double? muFinal;
  double? passiveGamma;
  double? passiveTheta;
  double? passiveC;
  String? k1String;
  String? k2String;
  double? k1;
  double? k2;
  double? activeGamma;
  double? activeTheta;
  double? activeK;
  double? activeC;
  double? D;
  double? H;
  double? a;
  double? b;
  double? c;
  double? d;
  double? e;
  double? f;
  double? yc;
  double? ycFinal;
  double? stripLength;
  double? stripLengthFinal;

  int? operation;
// solvar
  double? Pa;
  double? OM;
  double? Ph;
  double? PhFinal;
  double? Pv;
  double? W1;
  double? W2;
  double? W3;
  double? W4;
  double? x1;
  double? x2;
  double? x3;
  double? x4;
  double? sumW;
  double? RM;
  double? FSo;
  double? FSs;
  double? xbar;
  double? eccentricity;
  double? Bover6;
  bool? adequacy;
  double? qmin;
  double? qmax;

  double? passiveK;
  double? Pp;
  double? MPp;
  // if operation == 2
  double? W5;
  double? x5;
  // rounded
  double? roundedPa;
  double? roundedPh;
  double? roundedPv;
  double? roundedOM;
  double? roundedKp;
  double? roundedPp;
  double? roundedMPp;
  double? roundedSumW;
  double? roundedRM;
  double? roundedXbar;

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

    inputIncline = TextEditingController(text: widget.state.inputIncline);
    input_g = TextEditingController(text: widget.state.input_g);
    input_yPassive = TextEditingController(text: widget.state.input_yPassive);
    inputBaseFriction = TextEditingController(text: widget.state.inputBaseFriction);
    inputPassiveSoilFrictionAngle = TextEditingController(text: widget.state.inputPassiveSoilFrictionAngle);
    inputPassiveEarthPressure = TextEditingController(text: widget.state.inputPassiveEarthPressure);
    inputPassiveCohesion = TextEditingController(text: widget.state.inputPassiveCohesion);
    inputActiveGamma = TextEditingController(text: widget.state.inputActiveGamma);
    inputActiveSoilFrictionAngle = TextEditingController(text: widget.state.inputActiveSoilFrictionAngle);
    inputActiveEarthPressure = TextEditingController(text: widget.state.inputActiveEarthPressure);
    inputActiveCohesion = TextEditingController(text: widget.state.inputActiveCohesion);
    input_D = TextEditingController(text: widget.state.input_D);
    input_H = TextEditingController(text: widget.state.input_H);
    input_a = TextEditingController(text: widget.state.input_a);
    input_b = TextEditingController(text: widget.state.input_b);
    input_c = TextEditingController(text: widget.state.input_c);
    input_d = TextEditingController(text: widget.state.input_d);
    input_e = TextEditingController(text: widget.state.input_e);
    input_f = TextEditingController(text: widget.state.input_f);
    inputYc = TextEditingController(text: widget.state.inputYc);
    inputStripLength = TextEditingController(text: widget.state.inputStripLength);
    inputk1 = TextEditingController(text: widget.state.inputk1);
    inputk2 = TextEditingController(text: widget.state.inputk2);

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
    inputActiveGamma.addListener(_updateState);
    inputActiveSoilFrictionAngle.addListener(_updateState);
    inputActiveEarthPressure.addListener(_updateState);
    inputActiveCohesion.addListener(_updateState);
    input_D.addListener(_updateState);
    input_H.addListener(_updateState);
    input_a.addListener(_updateState);
    input_b.addListener(_updateState);
    input_c.addListener(_updateState);
    input_d.addListener(_updateState);
    input_e.addListener(_updateState);
    input_f.addListener(_updateState);
    inputYc.addListener(_updateState);
    inputStripLength.addListener(_updateState);
    inputk1.addListener(_updateState);
    inputk2.addListener(_updateState);

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
      widget.state.inputActiveGamma = inputActiveGamma.text;
      widget.state.inputActiveSoilFrictionAngle = inputActiveSoilFrictionAngle.text;
      widget.state.inputActiveEarthPressure = inputActiveEarthPressure.text;
      widget.state.inputActiveCohesion = inputActiveCohesion.text;
      widget.state.input_D = input_D.text;
      widget.state.input_H = input_H.text;
      widget.state.input_a = input_a.text;
      widget.state.input_b = input_b.text;
      widget.state.input_c = input_c.text;
      widget.state.input_d = input_d.text;
      widget.state.input_e = input_e.text;
      widget.state.input_f = input_f.text;
      widget.state.inputYc = inputYc.text;
      widget.state.inputStripLength = inputStripLength.text;
      widget.state.inputk1 = inputk1.text;
      widget.state.inputk2 = inputk2.text;

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
    inputActiveGamma.dispose();
    inputActiveSoilFrictionAngle.dispose();
    inputActiveEarthPressure.dispose();
    inputActiveCohesion.dispose();
    input_D.dispose();
    input_H.dispose();
    input_a.dispose();
    input_b.dispose();
    input_c.dispose();
    input_d.dispose();
    input_e.dispose();
    input_f.dispose();
    inputYc.dispose();
    inputStripLength.dispose();
    inputk1.dispose();
    inputk2.dispose();

    super.dispose();
  }
  
  void parseFractionKa() {
    if (KaString!.contains('/')) {
      var parts = KaString!.split('/');
      if (parts.length == 2) {
        int? numerator = int.tryParse(parts[0].trim());
        int? denominator = int.tryParse(parts[1].trim());

        if (numerator != null && denominator != null && denominator != 0) {
          activeK = numerator / denominator;
        } else {
          activeK = null;
        }
      }
    } else {
      double? wholeNumber = double.tryParse(KaString!);
      if (wholeNumber != null) {
        activeK = wholeNumber.toDouble();
      } else {
        activeK = null;
      }
    }
  }
  void parseFractionk1() {
    if (k1String!.contains('/')) {
      var parts = k1String!.split('/');
      if (parts.length == 2) {
        int? numerator = int.tryParse(parts[0].trim());
        int? denominator = int.tryParse(parts[1].trim());

        if (numerator != null && denominator != null && denominator != 0) {
          k1 = numerator / denominator;
        } else {
          k1 = null;
        }
      }
    } else {
      double? wholeNumber = double.tryParse(k1String!);
      if (wholeNumber != null) {
        k1 = wholeNumber.toDouble();
      } else {
        k1 = null;
      }
    }
  }
  void parseFractionk2() {
    if (k2String!.contains('/')) {
      var parts = k2String!.split('/');
      if (parts.length == 2) {
        int? numerator = int.tryParse(parts[0].trim());
        int? denominator = int.tryParse(parts[1].trim());

        if (numerator != null && denominator != null && denominator != 0) {
          k2 = numerator / denominator;
        } else {
          k2 = null;
        }
      }
    } else {
      double? wholeNumber = double.tryParse(k2String!);
      if (wholeNumber != null) {
        k2 = wholeNumber.toDouble();
      } else {
        k2 = null;
      }
    }
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
  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
  }

  void solve() {

    if (widget.state.resultantPa == false && widget.state.passiveSoil == false && widget.state.slopedSoil == false) {
      operation = 1;
    } else if (widget.state.resultantPa == true && widget.state.passiveSoil == false && widget.state.slopedSoil == false) {
      operation = 2;
    } else if (widget.state.resultantPa == true && widget.state.passiveSoil == false && widget.state.slopedSoil == true) {
      operation = 3;
    } else if (widget.state.resultantPa == false && widget.state.passiveSoil == false && widget.state.slopedSoil == true) {
      operation = 4;
    } else if (widget.state.resultantPa == true && widget.state.passiveSoil == true && widget.state.slopedSoil == false) {
      operation = 5;
    } else if (widget.state.resultantPa == false && widget.state.passiveSoil == true && widget.state.slopedSoil == false) {
      operation = 6;
    } else if (widget.state.resultantPa == true && widget.state.passiveSoil == true && widget.state.slopedSoil == true) {
      operation = 7;
    } else if (widget.state.resultantPa == false && widget.state.passiveSoil == true && widget.state.slopedSoil == true) {
      operation = 8;
    } else {
      operation = null;
    }

    activeGamma = double.tryParse(inputActiveGamma.text);
    activeTheta = double.tryParse(inputActiveSoilFrictionAngle.text);
    KaString = inputActiveEarthPressure.text.trim();
    k1String = inputk1.text.trim();
    k2String = inputk2.text.trim();
    activeC = double.tryParse(inputActiveCohesion.text);
    a = double.tryParse(input_a.text);
    b = double.tryParse(input_b.text);
    c = double.tryParse(input_c.text);
    d = double.tryParse(input_d.text);
    e = double.tryParse(input_e.text);
    f = double.tryParse(input_f.text);
    yc = double.tryParse(inputYc.text);
    stripLength = double.tryParse(inputStripLength.text);

    g = double.tryParse(input_g.text);
    incline = double.tryParse(inputIncline.text);

    mu = double.tryParse(inputBaseFriction.text);

    passiveGamma = double.tryParse(input_yPassive.text);
    passiveTheta = double.tryParse(inputPassiveSoilFrictionAngle.text);
    passiveC = double.tryParse(inputPassiveCohesion.text);
    D = double.tryParse(input_D.text);

    k1 = double.tryParse(inputk1.text);
    k2 = double.tryParse(inputk2.text);

    if (KaString != null) {
      parseFractionKa();
    } else {
      activeK = null;
    }

    if (k1String != null) {
      parseFractionk1();
    } else {
      k1 = null;
    }

    if (k2String != null) {
      parseFractionk2();
    } else {
      k2 = null;
    }

    if (!widget.state.passiveSoil) {
      if (mu != null) {
        muFinal = mu!;
      } else {
        muFinal = null;
      }
    } else { // passive on
      muFinal = 1;
    }

    if (widget.state.concreteDet) {
      if (yc != null) {
        ycFinal = yc!;
      } else {
        ycFinal = null;
      }
    } else {
      ycFinal = 24;
    }

    if (widget.state.stripDet) {
      if (stripLength != null) {
        stripLengthFinal = stripLength!;
      } else {
        stripLengthFinal = null;
      }
    } else {
      stripLengthFinal = 1;
    }

    if (activeGamma != null && activeK != null && 
    a != null && b != null && c != null && d != null && e != null && f != null && ycFinal != null
    && muFinal != null && stripLengthFinal != null) {
      
        if (widget.state.slopedSoil) {
          if (g != null) {
            H = d! + e! + g!;
          } else {
            H = null;
          }
        } else {
          H = d! + e!;
        }

        if (H != null) {
          Pa = 0.5 * activeK! * activeGamma! * H! * H!;
          roundedPa = roundToFourDecimalPlaces(Pa!);
        } else {
          Pa = null;
          roundedPa = null;
        }

        if (Pa != null) {
          if (widget.state.resultantPa) {
            if (incline != null) {
              Ph = Pa! * cos(incline! * pi/180);
              roundedPh = roundToFourDecimalPlaces(Ph!);
              PhFinal = Ph!;
              Pv = Pa! * sin(incline! * pi/180);
              roundedPv = roundToFourDecimalPlaces(Pv!);
            } else {
              Ph = null;
              roundedPh = null;
              PhFinal = null;
              Pv = null;
              roundedPv = null;
            }
          } else {
            Ph = null;
            roundedPh = null;
            PhFinal = Pa!;
            Pv = 0;
            roundedPv = null;
          }
        } else {
          Ph = null;
          roundedPh = null;
          PhFinal = null;
          Pv = null;
          roundedPv = null;
        }

        if (PhFinal != null && H != null) {
          OM = (PhFinal! * H!)/3;
          roundedOM = roundToFourDecimalPlaces(OM!);
        } else {
          OM = null;
          roundedOM = null;
        }

        if (widget.state.passiveSoil) {
          if (passiveTheta != null && passiveC != null && D != null && passiveGamma != null) {
            passiveK = tan((45 + passiveTheta!/2) * pi/180) * tan((45 + passiveTheta!/2) * pi/180);
            roundedKp = roundToFourDecimalPlaces(passiveK!);
            Pp = 0.5 * passiveK! * passiveGamma! * D! * D! + 2 * passiveC! * sqrt(passiveK!) * D!;
            roundedPp = roundToFourDecimalPlaces(Pp!);
            MPp = Pp! * D!/3;
            roundedMPp = roundToFourDecimalPlaces(MPp!);
          } else {
            passiveK = null;
            roundedKp = null;
            Pp = null;
            roundedPp = null;
            MPp = null;
            roundedMPp = null;
            roundedKp = null;
            roundedPp = null;
            roundedMPp = null;
          }
        } else {
          passiveK = 0;
          Pp = 0;
          MPp = 0;
          roundedKp = null;
          roundedPp = null;
          roundedMPp = null;
        }

        // moment 1
        W1 = activeGamma! * (a! - b! - c!) * e! * stripLengthFinal!;
        x1 = a! - (a! - b! - c!)/2;
        // moment 2
        W2 = ycFinal! * a! * d! * stripLengthFinal!;
        x2 = a! / 2;
        // moment 3
        W3 = ycFinal! * f! * e! * stripLengthFinal!;
        x3 = b! + c! - f!/2;
        // moment 4
        W4 = ycFinal! * ((b! - f!) * (e!))/2 * stripLengthFinal!;
        x4 = c! + (2/3) * (b! - f!);
        // moment 5
        if (widget.state.slopedSoil) {
          W5 = activeGamma! * ((a! - b! - c!) * g!)/2 * stripLengthFinal!;
          x5 = b! + c! + (2/3) * (a! - b! - c!);
        } else {
          W5 = 0;
          x5 = 0;
        }

        if (W1 != null && W2 != null && W3 != null && W4 != null && W5 != null && x1 != null
        && x2 != null && x3 != null && x4 != null && x5 != null && Pv != null && MPp != null) {
          sumW = W1! + W2! + W3! + W4! + W5! + Pv!;
          roundedSumW = roundToFourDecimalPlaces(sumW!);
          RM = (W1! * x1!) + (W2! * x2!) + (W3! * x3!) + (W4! * x4!) + (W5! * x5!) + MPp!;
          roundedRM = roundToFourDecimalPlaces(RM!);
        } else {
          sumW = 5;
          roundedSumW = null;
          RM = null;
          roundedRM = null;
        }
        
        if (RM != null && OM != null && sumW != null) {
          FSo = RM! / OM!;
          widget.state.FSo = roundToFourDecimalPlaces(FSo!);
          xbar = (RM! - OM!) / sumW!;
          roundedXbar = roundToFourDecimalPlaces(xbar!);
        } else {
          FSo = null;
          widget.state.FSo = null;
          xbar = null;
          roundedXbar = null;
        }

        if (sumW != null && PhFinal != null) {
          if (widget.state.passiveSoil) {
            if (k1 != null && passiveTheta != null && k2 != null && passiveC != null && Pp != null) {
              FSs = ((sumW! * tan(k1! * passiveTheta! * pi/180)) + (a! * k2! * passiveC!) + Pp!) / PhFinal!;
              widget.state.FSs = roundToFourDecimalPlaces(FSs!);
            } else {
              FSs = null;
              widget.state.FSs = null;
            }
          } else {
            FSs = (muFinal! * sumW!) / PhFinal!;
            widget.state.FSs = roundToFourDecimalPlaces(FSs!);
          }
        } else {
          FSs = null;
          widget.state.FSs = null;
        }

        if (xbar != null) {
          eccentricity = (a! / 2) - xbar!;
          widget.state.eccentricity = roundToFourDecimalPlaces(eccentricity!);
        } else {
          eccentricity = null;
          widget.state.eccentricity = null;
        }

        Bover6 = a! / 6;
        widget.state.Bover6 = roundToFourDecimalPlaces(Bover6!);

        if (eccentricity != null && Bover6 != null) {
          if (eccentricity! < Bover6!) {
            adequacy = true;
          } else {
            adequacy = false;
          }
        } else {
          adequacy = null;
        }

        if (adequacy != null) {
          if (adequacy == true) {
            if (sumW != null && eccentricity != null) {
              qmin = (sumW! / (a! * stripLengthFinal!)) * (1 - (6 * eccentricity!) / a!);
              qmax = (sumW! / (a! * stripLengthFinal!)) * (1 + (6 * eccentricity!) / a!);
              widget.state.qmin = roundToFourDecimalPlaces(qmin!);
              widget.state.qmax = roundToFourDecimalPlaces(qmax!);
            } else {
              qmin = null;
              qmax = null;
              widget.state.qmin = null;
              widget.state.qmax = null;
            }
          } else if (adequacy == false) {
            qmin = null;
            qmax = null;
            widget.state.qmin = null;
            widget.state.qmax = null;
          }
        } else {
          qmin = null;
          qmax = null;
          widget.state.qmin = null;
          widget.state.qmax = null;
        }
    } else {
      H = null;
      Pa = null;
      Pv = null;
      PhFinal = null;
      OM = null;
      W1 = null;
      W2 = null;
      W3 = null;
      W4 = null;
      W5 = null;
      x1 = null;
      x2 = null;
      x3 = null;
      x4 = null;
      x5 = null;
      sumW = null;
      passiveK = null;
      MPp = null;
      Pp = null;
      RM = null;
      FSo = null;
      widget.state.FSo = null;
      FSs = null;
      widget.state.FSs = null;
      xbar = null;
      eccentricity = null;
      widget.state.eccentricity = null;
      Bover6 = null;
      widget.state.Bover6 = null;
      adequacy = null;
      qmin = null;
      qmax = null;
      widget.state.qmin = null;
      widget.state.qmax = null;
    }

    if (FSs != null && FSo != null && adequacy != null) {
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

    print("FSs = $FSs, FSo = $FSo || Ry = $sumW, Kp = $passiveK, Pp = $Pp, Pa = $Pa, Ph = $PhFinal, Pv = $Pv || x̄ = $xbar, eccentricity = $eccentricity, B/6 = $Bover6, adequacy = $adequacy, qmin = $qmin, qmax = $qmax, Ry = $sumW, k1 = $k1, k2 = $k2");
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
                          child: Image.asset('assets/images/retWall1-1.png'),
                        ),
                      if (!widget.state.resultantPa && !widget.state.passiveSoil && !widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retWall2-1.png'),
                        ),
                      if (widget.state.resultantPa && !widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retWall3-1.png'),
                        ),
                      if (!widget.state.resultantPa && !widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retWall4-1.png'),
                        ),
                      if (widget.state.resultantPa && widget.state.passiveSoil && !widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retWall5-1.png'),
                        ),
                      if (!widget.state.resultantPa && widget.state.passiveSoil && !widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retWall6-1.png'),
                        ),
                      if (widget.state.resultantPa && widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retWall7-1.png'),
                        ),
                      if (!widget.state.resultantPa && widget.state.passiveSoil && widget.state.slopedSoil)
                        Container(
                          width: 380,
                          height: 365,
                          child: Image.asset('assets/images/retWall8-1.png'),
                        ),

                      switchResultantPa(),
                      switchSlopedSoil(),
                      switchPassive(),

                      // resultant on
                      if (widget.state.resultantPa)
                        entryInclinePa(),
                      
                      // passive off
                      if (!widget.state.passiveSoil)
                        entryBaseFriction(),

                      entryActiveGamma(),
                      entryActiveEarthPressure(),

                      // passive on
                      if (widget.state.passiveSoil)
                        entryGammaPassive(),
                      if (widget.state.passiveSoil)
                        entryPassiveCohesion(),
                      if (widget.state.passiveSoil)
                        entryPassiveSoilFrictionAngle(),
                      if (widget.state.passiveSoil)
                        entry_D(),
                      if (widget.state.passiveSoil)
                        entryk1(),
                      if (widget.state.passiveSoil)
                        entryk2(),

                      entry_a(),
                      entry_b(),
                      entry_c(),
                      entry_d(),
                      entry_e(),
                      entry_f(),
                      
                      // slope on
                      if (widget.state.slopedSoil)
                        entry_g(),

                      switchStrip(),
                      containerStripOn(),

                      switchConcreteDet(),
                      containerConcreteOn(),

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
  Widget entry_D() {
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
                  'D (in m):',
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
                    controller: input_D,
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
                          input_D.clear();
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
  } // entry_D
  Widget entryk1() {
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
                  'k₁:',
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
                    controller: inputk1,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      SingleDotSlashInputFormatter(),
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
                          inputk1.clear();
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
  } // entryk1
  Widget entryk2() {
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
                  'k₂:',
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
                    controller: inputk2,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      SingleDotSlashInputFormatter(),
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
                          inputk2.clear();
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
  } // entryk2

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

  // always there
  Widget entryActiveGamma() {
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
                  'Unit weight of active soil, γₐ (in kN/m³):',
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
                    controller: inputActiveGamma,
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
                          inputActiveGamma.clear();
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
  } // entryActiveGamma
  Widget entryActiveSoilFrictionAngle() {
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
                  'Active friction angle, θ₁ (in degrees):',
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
                    controller: inputActiveSoilFrictionAngle,
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
                          inputActiveSoilFrictionAngle.clear();
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
  } // entryActiveSoilFrictionAngle
  Widget entryActiveEarthPressure() {
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
                  'Active earth pressure coefficient, Kₐ:',
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
                    controller: inputActiveEarthPressure,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      SingleDotSlashInputFormatter(),
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
                          inputActiveEarthPressure.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),        
    );
  } // entryActiveEarthPressure
  Widget entryActiveCohesion() {
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
                  'Active soil cohesion, c₁ (in kPa):',
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
                    controller: inputActiveCohesion,
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
                          inputActiveCohesion.clear();
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
  Widget entry_a() {
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
                  'a (in m):',
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
                    controller: input_a,
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
                          input_a.clear();
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
  } // entry_a
  Widget entry_b() {
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
                  'b (in m):',
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
                    controller: input_b,
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
                          input_b.clear();
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
  } // entry_b
  Widget entry_c() {
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
                  'c (in m):',
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
                    controller: input_c,
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
                          input_c.clear();
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
  } // entry_c
  Widget entry_d() {
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
                  'd (in m):',
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
                    controller: input_d,
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
                          input_d.clear();
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
  } // entry_d
  Widget entry_e() {
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
                  'e (in m):',
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
                    controller: input_e,
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
                          input_e.clear();
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
  } // entry_e
  Widget entry_f() {
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
                  'f (in m):',
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
                    controller: input_f,
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
                          input_f.clear();
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
  } // entry_f
  
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

  Widget switchStrip() {
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
                  'Strip of wall length (assumed as 1 m if not given)',
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
                    value: widget.state.stripDet,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.stripDet = newValue;
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
  Widget containerStripOn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.stripDet,
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
                subStripLength(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerConcreteOn
  Widget subStripLength() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Strip length (in m):',
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
                  controller: inputStripLength,
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
                        inputStripLength.clear();
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
  } // subStripLength

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
  // for FAB to scroll to top

  Widget resultText() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              "FSꜱ = ${widget.state.FSo}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "FSᴏ = ${widget.state.FSs}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "e = ${widget.state.eccentricity}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "B/6 = ${widget.state.Bover6}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (adequacy == true)
            Text(
              "e < B/6, ∴ no uplift occurs",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (adequacy == false)
            Text(
              "e ≥ B/6, ∴ uplift occurs",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (adequacy == true)
              Text(
                "qmin = ${widget.state.qmin}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (adequacy == true)
              Text(
                "qmax = ${widget.state.qmax}",
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
              Text(
                'Pa = $roundedPa kN',
                style: TextStyle(color: Colors.white),
              ),

              if (widget.state.resultantPa)
                Text(
                  'Ph = $roundedPh kN',
                  style: TextStyle(color: Colors.white),
                ),
              if (widget.state.resultantPa)
                Text(
                  'Pv = $roundedPv kN',
                  style: TextStyle(color: Colors.white),
                ),
              
              Text(
                'Overturning moment, OM = $roundedOM kN-m',
                style: TextStyle(color: Colors.white),
              ),

              if (widget.state.passiveSoil)
                Text(
                  'Passive earth pressure coefficient, Kₚ = $roundedKp',
                  style: TextStyle(color: Colors.white),
                ),
              if (widget.state.passiveSoil)
                Text(
                  'Pₚ = $roundedPp kN',
                  style: TextStyle(color: Colors.white),
                ),
              if (widget.state.passiveSoil)
                Text(
                  'Moment caused by Pₚ, MPₚ = $roundedPp kN-m',
                  style: TextStyle(color: Colors.white),
                ),

              Text(
                'Ry = $roundedSumW kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Righting moment, RM = $roundedRM kN-m',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "FSꜱ = ${widget.state.FSo}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "FSᴏ = ${widget.state.FSs}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'x̄ = $roundedXbar m',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "e = ${widget.state.eccentricity}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "B/6 = ${widget.state.Bover6}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (adequacy == true)
              Text(
                "e < B/6, ∴ no uplift occurs",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (adequacy == false)
              Text(
                "e ≥ B/6, ∴ uplift occurs",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (adequacy == true)
                Text(
                  "qmin = ${widget.state.qmin}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (adequacy == true)
                Text(
                  "qmax = ${widget.state.qmax}",
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

  Widget clearButton() {
    return ElevatedButton(
      onPressed: () { 
        inputIncline.clear();
        input_g.clear();
        input_yPassive.clear();
        inputBaseFriction.clear();
        inputPassiveSoilFrictionAngle.clear();
        inputPassiveEarthPressure.clear();
        inputPassiveCohesion.clear();
        inputActiveGamma.clear();
        inputActiveSoilFrictionAngle.clear();
        inputActiveEarthPressure.clear();
        inputActiveCohesion.clear();
        input_D.clear();
        input_H.clear();
        input_a.clear();
        input_b.clear();
        input_c.clear();
        input_d.clear();
        input_e.clear();
        input_f.clear();
        inputYc.clear();
        inputStripLength.clear();
        inputk1.clear();
        inputk2.clear();
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

class SingleDotSlashInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Allow only digits, one dot, and one slash
    final regex = RegExp(r'^[0-9]*[./]?[0-9]*$');

    int dotCount = '.'.allMatches(text).length;
    int slashCount = '/'.allMatches(text).length;

    if (dotCount > 1 || slashCount > 1) {
      return oldValue;
    }

    if (!regex.hasMatch(text)) {
      return oldValue;
    }

    return newValue;
  }
}
