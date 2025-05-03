import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/combined_footing_state.dart';
import 'dart:math';
import 'dart:io';

class CombinedPage extends StatefulWidget {
  final String title;
  final CombinedFootingState state;
  final Function(CombinedFootingState) onStateChanged;


  CombinedPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });


  @override
  _CombinedPageState createState() => _CombinedPageState();
}

class _CombinedPageState extends State<CombinedPage> 
with AutomaticKeepAliveClientMixin<CombinedPage> {
  // You can add state variables and methods here

@override
  bool get wantKeepAlive => true; // 2. Override wantKeepAlive and return true
  String get displayTitle {
  if (widget.title.startsWith('Combined')) {
        int index = int.tryParse(widget.title.split(' ').last) ?? 0;
        return "Combined Footing $index"; // Shorter for tab
      }

      return widget.title; 
    }

  late ScrollController _scrollController;

//COLUMN DIMENSIONS
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

  String get solutionButtonLabelPunchWide {
    if (widget.state.showSolutionPunchWide) {
      return 'Hide solution';
    } else {
      return 'View solution';
    }
  }

  String get solutionButtonLabelSteel {
    if (widget.state.showSolutionPunchWide) {
      return 'Hide solution';
    } else {
      return 'View solution';
    }
  }

  // solvar (solution variables)
  // punching shear
  double? Wu; // Uniformly distributed soil pressure from Col A load (kN/m)
  double? qu; // Net ultimate soil pressure (kPa or kN/m^2)
  double? depth_d; // Effective depth (mm)
  double? depth_d_m; // Effective depth (m)
  double? Wuc; // Force contribution from Wu over length c (kN)
  double? WA; // Load per unit length under Col A area (kN/m)
  double? WB; // Load per unit length under Col B area (kN/m)
  double? PA; // Total factored load from Col A area (kN)
  double? PB; // Total factored load from Col B area (kN)
  double? VUA; // Factored punching shear force at Col A (kN)
  double? VUB; // Factored punching shear force at Col B (kN)
  double? bo; // Critical perimeter for punching shear (m)
  double? phi_s; // Shear reduction factor used
  double? VPA; // Punching shear stress at Col A (kPa)
  double? VPB; // Punching shear stress at Col B (kPa)
  double? Vp; // Critical punching shear stress (kPa)
  // wide beam shear
  double? Vu_WBA;
  double? Vu_WBB;
  double? VWA;
  double? VWB;
  double? Vw;
  // design of steel reinforcement
  double? s;
  double? Mu;
  double? phi_m;
  double? Rn;
  double? rho;
  double? rhoMin;
  double? rhoFinal;
  double? As;
  double? dbar;
  double? Ab;
  double? n;
  // rounded punchwide
  double? roundedWu;
  double? roundedqu;
  double? roundedWA;
  double? roundedWB;
  double? roundedPA;
  double? roundedPB;
  double? roundedVUA;
  double? roundedVUB;
  // rounded punchwide
  double? roundedVu_WBA;
  double? roundedVu_WBB;
  // rounded steel
  double? roundedMu;
  double? roundedRn;
  double? roundedrho;
  double? roundedrhoMin;
  double? roundedrhoFinal;
  bool? rhoGoverns;
  double? roundedAs;
  double? roundedAb;
  double? roundedn;




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

    side = "Left side (within Column A)"; // Set default value here
    widget.state.side = side;

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

  double roundToSixDecimalPlaces(double value) {
    return (value * 1000000).round() / 1000000;
  }

  double roundToOneDecimalPlace(double value) {
    return (value * 10).round() / 10;
  }

  void showSnackBarIncorrect(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please provide input for all parameters."),
        backgroundColor: const Color.fromARGB(255, 201, 40, 29),
        duration: Duration(seconds: 3),
      ),
    );
  }
  void showSnackBarZero(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please provide an input other than zero."),
        backgroundColor: const Color.fromARGB(255, 201, 40, 29),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void calc() {
    // --- Input Parsing ---
    length_a = double.tryParse(inputLength_a.text);
    length_b = double.tryParse(inputLength_b.text);
    length_c = double.tryParse(inputLength_c.text);
    length_e = double.tryParse(inputLength_e.text);
    length_H = double.tryParse(inputLength_H.text);

    depth_d = double.tryParse(inputDepth.text); // Depth in mm

    shear_f = double.tryParse(inputShear_f.text);
    shear_g = double.tryParse(inputShear_g.text);
    shear_h = double.tryParse(inputShear_h.text);
    shear_i = double.tryParse(inputShear_i.text);

    factorShear = double.tryParse(inputFactorShear.text);
    // --- End Input Parsing ---

    // Determine actual shear reduction factor (phi_s)
    if (widget.state.factorShearToggle) {
      if (factorShear != null) {
        phi_s = factorShear;
      } else {
        phi_s = null;
      }
    } else {
      phi_s = 0.75; // Default value
    }

    if (length_a != null && length_b != null && length_c != null && length_e != null && length_H != null && depth_d != null &&
    shear_f != null && shear_g != null && shear_h != null && shear_i != null && phi_s != null) {
      if (length_a != 0 && length_b != 0 && length_c != 0 && length_e != 0 && length_H != 0 && depth_d != 0 &&
      shear_f != 0 && shear_g != 0 && shear_h != 0 && shear_i != 0 && phi_s != 0) {
      
        // Convert depth_d (mm) to depth_d_m (m)
        if (depth_d != null) {
          depth_d_m = depth_d! / 1000.0;
        } else {
          depth_d_m = null;
        }

        // 1. Calculate Wu = f / a
        if (shear_f != null && length_a != null && length_a != 0) {
          Wu = shear_f! / length_a!;
          if (Wu != null) {
            roundedWu = roundToFourDecimalPlaces(Wu!);
          } else {
            roundedWu = null;
          }
        } else {
          Wu = null;
          roundedWu = null;
        }

        // 2. Calculate qu = Wu / H
        if (Wu != null && length_H != null && length_H != 0) {
          qu = Wu! / length_H!;
          if (qu != null) {
            roundedqu = roundToFourDecimalPlaces(qu!);
          } else {
            roundedqu = null;
          }
        } else {
          qu = null;
          roundedqu = null;
        }

        // Intermediate Wuc = Wu * c
        if (Wu != null && length_c != null) {
          Wuc = Wu! * length_c!;
        } else {
          Wuc = null;
        }

        // 3. Calculate WA = (f + g + Wuc) / c
        if (shear_f != null && shear_g != null && Wuc != null && length_c != null && length_c != 0) {
          WA = (shear_f! + shear_g! + Wuc!) / length_c!;
          if (WA != null) {
            roundedWA = roundToFourDecimalPlaces(WA!);
          } else {
            roundedWA = null;
          }
        } else {
          WA = null;
          roundedWA = null;
        }

        // 4. Calculate WB = (h + i + Wuc) / c
        if (shear_h != null && shear_i != null && Wuc != null && length_c != null && length_c != 0) {
          WB = (shear_h! + shear_i! + Wuc!) / length_c!;
          if (WB != null) {
            roundedWB = roundToFourDecimalPlaces(WB!);
          } else {
            roundedWB = null;
          }
        } else {
          WB = null;
          roundedWB = null;
        }

        // 5. Calculate PA = WA * c
        if (WA != null && length_c != null) {
          PA = WA! * length_c!;
          if (PA != null) {
            roundedPA = roundToFourDecimalPlaces(PA!);
          } else {
            roundedPA = null;
          }
        } else {
          PA = null;
          roundedPA = null;
        }

        // 6. Calculate PB = WB * c
        if (WB != null && length_c != null) {
          PB = WB! * length_c!;
          if (PB != null) {
            roundedPB = roundToFourDecimalPlaces(PB!);
          } else {
            roundedPB = null;
          }
        } else {
          PB = null;
          roundedPB = null;
        }

        // 7. Calculate VUA = PA - qu * (c + d_m)^2
        if (PA != null && qu != null && length_c != null && depth_d_m != null) {
          VUA = PA! - qu! * pow((length_c! + depth_d_m!), 2);
          VUB = PB! - qu! * pow((length_c! + depth_d_m!), 2);
          if (VUA != null) {
            roundedVUA = roundToFourDecimalPlaces(VUA!);
          } else {
            roundedVUA = null;
          }
          if (VUA != null) {
            roundedVUB = roundToFourDecimalPlaces(VUB!);
          } else {
            roundedVUB = null;
          }
        } else {
          VUA = null;
          VUB = null;
          roundedVUA = null;
          roundedVUB = null;
        }

        // 9. Calculate bo = 4 * (c + d_m)
        if (length_c != null && depth_d_m != null) {
          bo = 4 * (length_c! + depth_d_m!);
        } else {
          bo = null;
        }

        // 10. Calculate VPA = VUA / (phi_s * bo * d_m)
        if (VUA != null && phi_s != null && bo != null && depth_d_m != null && bo! * depth_d_m! != 0) {
          VPA = VUA! / (1000 * phi_s! * bo! * depth_d_m!);
          if (VPA != null) {
            widget.state.VPA = roundToFourDecimalPlaces(VPA!);
          } else {
            widget.state.VPA = null;
          }
        } else {
          VPA = null;
          widget.state.VPA = null;
        }

        // 11. Calculate VPB = VUB / (phi_s * bo * d_m)
        if (VUB != null && phi_s != null && bo != null && depth_d_m != null && bo! * depth_d_m! != 0) {
          VPB = VUB! / (1000 * phi_s! * bo! * depth_d_m!);
          if (VPB != null) {
            widget.state.VPB = roundToFourDecimalPlaces(VPB!);
          } else {
            widget.state.VPB = null;
          }
        } else {
          VPB = null;
          widget.state.VPB = null;
        }

        // 12. Calculate Vp = max(VPA, VPB)
        if (VPA != null && VPB != null) {
          Vp = max(VPA!, VPB!);
          if (Vp != null) {
            widget.state.Vp = roundToFourDecimalPlaces(Vp!);
          } else {
            widget.state.Vp = null;
          }
        } else {
          Vp = null;
          widget.state.Vp = null;
        }

        // wide beam shear
        if (shear_h != null && Wu != null && depth_d_m != null) {
          Vu_WBA = shear_h! - Wu! * depth_d_m!;
          Vu_WBB = shear_g! - Wu! * depth_d_m!;
          if (Vu_WBA != null) {
            roundedVu_WBA = roundToFourDecimalPlaces(Vu_WBA!);
          } else {
            roundedVu_WBA = null; 
          }
          if (Vu_WBB != null) {
            roundedVu_WBB = roundToFourDecimalPlaces(Vu_WBB!);
          } else {
            roundedVu_WBB = null; 
          }
        } else {
          Vu_WBA = null;
          Vu_WBB = null; 
          roundedVu_WBA = null; 
          roundedVu_WBB = null; 
        }

        if (Vu_WBA != null && Vu_WBB != null && phi_s != null && length_H != null && depth_d != null) {
          VWA = Vu_WBA! / (phi_s! * length_H! * depth_d!);
          VWB = Vu_WBB! / (phi_s! * length_H! * depth_d!);
          if (VWA != null) {
            widget.state.VWA = roundToFourDecimalPlaces(VWA!);
          } else {
            widget.state.VWA = null; 
          }
          if (VWB != null) {
            widget.state.VWB = roundToFourDecimalPlaces(VWB!);
          } else {
            widget.state.VWB = null; 
          }
        } else {
          VWA = null;
          VWB = null; 
          widget.state.VWA = null; 
          widget.state.VWB = null; 
        }
        
        if (VWA != null && VWB != null) {
          Vw = max(VWA!, VWB!);
          if (Vw != null) {
            widget.state.Vw = roundToFourDecimalPlaces(Vw!);
          } else {
            widget.state.Vw = null;
          }
        } else {
          Vw = null;
          widget.state.Vw = null;
        }

      } else {
        showSnackBarZero(context);
        setState(() {
          widget.state.showResultsPunchWide = false;
          widget.state.showSolutionPunchWide = false;
          widget.state.solutionTogglePunchWide = true;
        });
        depth_d_m = null;
        Wu = null;
        roundedWu = null;
        qu = null;
        roundedqu = null;
        Wuc = null;
        WA = null;
        roundedWA = null;
        WB = null;
        roundedWB = null;
        PA = null;
        roundedPA = null;
        PB = null;
        roundedPB = null;
        VUA = null;
        VUB = null;
        roundedVUA = null;
        roundedVUB = null;
        bo = null;
        VPA = null;
        widget.state.VPA = null;
        VPB = null;
        widget.state.VPB = null;
        Vp = null;
        widget.state.Vp = null;
        Vu_WBA = null;
        Vu_WBB = null; 
        roundedVu_WBA = null; 
        roundedVu_WBB = null; 
        VWA = null;
        VWB = null; 
        widget.state.VWA = null; 
        widget.state.VWB = null;
        Vw = null;
        widget.state.Vw = null;
        return;
      }
    } else {
      showSnackBarIncorrect(context);
      setState(() {
        widget.state.showResultsPunchWide = false;
        widget.state.showSolutionPunchWide = false;
        widget.state.solutionTogglePunchWide = true;
      });
      depth_d_m = null;
      Wu = null;
      roundedWu = null;
      qu = null;
      roundedqu = null;
      Wuc = null;
      WA = null;
      roundedWA = null;
      WB = null;
      roundedWB = null;
      PA = null;
      roundedPA = null;
      PB = null;
      roundedPB = null;
      VUA = null;
      VUB = null;
      roundedVUA = null;
      roundedVUB = null;
      bo = null;
      VPA = null;
      widget.state.VPA = null;
      VPB = null;
      widget.state.VPB = null;
      Vp = null;
      widget.state.Vp = null;
      Vu_WBA = null;
      Vu_WBB = null; 
      roundedVu_WBA = null; 
      roundedVu_WBB = null; 
      VWA = null;
      VWB = null; 
      widget.state.VWA = null; 
      widget.state.VWB = null;
      Vw = null;
      widget.state.Vw = null;
      return;
    }

    if (widget.state.VPA != null && widget.state.VPB != null && widget.state.Vp != null &&
    widget.state.VWA != null && widget.state.VWB != null && widget.state.Vw != null) {
      setState(() {
        widget.state.showResultsPunchWide = true;
      });
    } else {
      showSnackBarIncorrect(context);
      setState(() {
        widget.state.showResultsPunchWide = false;
        widget.state.showSolutionPunchWide = false;
        widget.state.solutionTogglePunchWide = true;
      });
    }
    // --- End Placeholder Result Toggle ---

    // --- Debug Prints ---
    print('Inputs: f=$shear_f, g=$shear_g, h=$shear_h, i=$shear_i, a=$length_a, c=$length_c, H=$length_H, d(mm)=$depth_d, phi_s_input=$factorShear');
    print('Calculated: Wu=$Wu, qu=$qu, Wuc=$Wuc, WA=$WA, WB=$WB, PA=$PA, PB=$PB, d(m)=$depth_d_m, VUA=$VUA, VUB=$VUB, bo=$bo, phi_s_used=$phi_s');
    print('Punching Shear Stress: VPA=$VPA, VPB=$VPB, Vp=$Vp');
    print('Vu A = $Vu_WBA, Vu B = $Vu_WBB, VWA=$VWA, VWB=$VWB, Vw=$Vw, Mu = $Mu, Rn = $Rn, rho = $rho, rhomin = $rhoMin, rhofinal = $rhoFinal, As = $As, Ab = $Ab, n = $n');
    print('showResults = ${widget.state.showResultsPunchWide}');
    // --- End Debug Prints ---
  }

  void steel() {
    length_a = double.tryParse(inputLength_a.text);
    shear_f = double.tryParse(inputShear_f.text);
    length_e = double.tryParse(inputLength_e.text);
    shear_i = double.tryParse(inputShear_i.text);
    length_H = double.tryParse(inputLength_H.text);
    depth_d = double.tryParse(inputDepth.text);
    factorMoment = double.tryParse(inputFactorMoment.text);
    otherDia = double.tryParse(inputOtherDia.text);
    fc = double.tryParse(inputFc.text);
    fy = double.tryParse(inputFy.text);

    if (widget.state.factorMomentToggle) {
      if (factorMoment != null && factorMoment != 0) {
        phi_m = factorMoment;
      } else {
        phi_m = null;
      }
    } else {
      phi_m = 0.9; // Default value
    }

    if (barDia == "10 mm") {
      dbar = 10;
    } else if (barDia == "12 mm") {
      dbar = 12;
    } else if (barDia == "16 mm") {
      dbar = 16;
    } else if (barDia == "20 mm") {
      dbar = 20;
    } else if (barDia == "25 mm") {
      dbar = 25;
    } else if (barDia == "28 mm") {
      dbar = 28;
    } else if (barDia == "32 mm") {
      dbar = 32;
    } else if (barDia == "36 mm") {
      dbar = 36;
    } else if (barDia == "Others") {
      if (otherDia != null) {
        dbar = otherDia;
      } else {
        dbar = null;
      }
    } else {
      dbar = null;
    }

    // design of steel reinforcement

    if (length_H != null && depth_d != null && phi_m != null && dbar != null && fc != null && fy != null) {
      if (length_H != 0 && depth_d != 0 && phi_m != 0 && dbar != 0 && fc != 0 && fy != 0) {

        if (side != null) {
          if (side == "Left side (within Column A)") {
            if (length_a != null && shear_f != null) {
              if (length_a != 0 && shear_f != 0) {
                s = length_a;
                Wu = shear_f! / length_a!;
              } else {
                showSnackBarZero(context);
                setState(() {
                  widget.state.showResultsSteel = false;
                  widget.state.showSolutionSteel = false;
                  widget.state.solutionToggleSteel = true;
                });
                s = null;
                Wu = null;
                return;
              }
              if (Wu != null) {
                roundedWu = roundToFourDecimalPlaces(Wu!);
              } else {
                roundedWu = null;
              }
            } else {
              s = null;
              Wu = null;
              roundedWu = null;
            }
          } else {
            if (length_e != null && shear_i != null) {
              if (length_e != 0 && shear_i != 0) {
                s = length_e;
                Wu = shear_i! / length_e!;
              } else {
                showSnackBarZero(context);
                setState(() {
                  widget.state.showResultsSteel = false;
                  widget.state.showSolutionSteel = false;
                  widget.state.solutionToggleSteel = true;
                });
                s = null;
                Wu = null;
                return;
              }
              if (Wu != null) {
                roundedWu = roundToFourDecimalPlaces(Wu!);
              } else {
                roundedWu = null;
              }
            } else {
              s = null;
              Wu = null;
              roundedWu = null;
            }
          }
        } else {
          showSnackBarIncorrect(context);
          s = null;
          Wu = null;
          roundedWu = null;
        }

        if (Wu != null && length_H != null && length_H != 0) {
          qu = Wu! / length_H!;
          if (qu != null) {
            roundedqu = roundToFourDecimalPlaces(qu!);
          } else {
            roundedqu = null;
          }
        } else {
          qu = null;
          roundedqu = null;
        }

        if (qu != null && s != null) {
          Mu = 2 * qu! * s! * s!;
          if (Mu != null) {
            roundedMu = roundToFourDecimalPlaces(Mu!);
          } else {
            roundedMu = null;
          }
        } else {
          Mu = null;
          roundedMu = null;
        }

        if (Mu != null && phi_m != null && length_H != null && depth_d != null) {
          Rn = (1000000 * Mu!) / (1000 * phi_m! * length_H! * depth_d! * depth_d!);
          if (Rn != null) {
            roundedRn = roundToSixDecimalPlaces(Rn!);
          } else {
            roundedRn = null;
          }
        } else {
          Rn = null;
          roundedRn = null;
        }

        if (Mu != null && phi_m != null && length_H != null && depth_d != null && fc != null && fy != null) {
          rho = ((0.85 * fc!) / (fy!)) * (1 - sqrt(1 - ((2 * Rn!)/(0.85 * fc!))));
          if (rho != null) {
            roundedrho = roundToSixDecimalPlaces(rho!);
          } else {
            roundedrho = null;
          }
        } else {
          rho = null;
          roundedrho = null;
        }

        if (fy != null) {
          rhoMin = 1.4/fy!;
          if (rhoMin != null) {
            roundedrhoMin = roundToSixDecimalPlaces(rhoMin!);
          } else {
            roundedrhoMin = null;
          }
        } else {
          rhoMin = null;
          roundedrhoMin = null;
        }

        if (rho != null && rhoMin != null) {
          if (rho! < rhoMin!) {
            rhoFinal = rhoMin!;
            roundedrhoFinal = roundedrhoMin;
            rhoGoverns = false;
          } else {
            rhoFinal = rho!;
            roundedrhoFinal = roundedrho;
            rhoGoverns = true;
          }
        } else {
          rhoFinal = null;
          roundedrhoFinal = null;
          rhoGoverns = null;
        }

        if (rhoFinal != null && length_H != null && depth_d != null) {
          As = 1000 * rhoFinal! * length_H! * depth_d!;
          if (As != null) {
            roundedAs = roundToFourDecimalPlaces(As!);
          } else {
            roundedAs = null;
          }
        } else {
          As = null;
          roundedAs = null;
        }

        if (dbar != null) {
          Ab = 0.25 * pi * dbar! * dbar!;
          if (Ab != null) {
            roundedAb = roundToFourDecimalPlaces(Ab!);
          } else {
            roundedAb = null;
          }
        } else {
          Ab = null;
          roundedAb = null;
        }

        if (As != null && Ab != null) {
          n = As! / Ab!;
          if (n != null) {
            widget.state.n = roundToFourDecimalPlaces(n!);
            widget.state.roundedn = n!.ceilToDouble();
          } else {
            widget.state.n = null;
            widget.state.roundedn = null;
          }
        } else {
          n = null;
          widget.state.n = null;
          widget.state.roundedn = null;
        }
      } else { // one input has zero
        showSnackBarZero(context);
        setState(() {
          widget.state.showResultsSteel = false;
          widget.state.showSolutionSteel = false;
          widget.state.solutionToggleSteel = true;
        });
        Wu = null;
        roundedWu = null;
        qu = null;
        roundedqu = null;
        s = null;
        Wu = null;
        roundedWu = null;
        Mu = null;
        roundedMu = null;
        Rn = null;
        roundedRn = null;
        rho = null;
        roundedrho = null;
        rhoMin = null;
        roundedrhoMin = null;
        rhoFinal = null;
        roundedrhoFinal = null;
        rhoGoverns = null;
        As = null;
        roundedAs = null;
        Ab = null;
        roundedAb = null;
        n = null;
        widget.state.n = null;
        widget.state.roundedn = null;
        return;
      }
    } else { // one input is null
      showSnackBarIncorrect(context);
        setState(() {
          widget.state.showResultsSteel = false;
          widget.state.showSolutionSteel = false;
          widget.state.solutionToggleSteel = true;
        });
      Wu = null;
      roundedWu = null;
      qu = null;
      roundedqu = null;
      s = null;
      Wu = null;
      roundedWu = null;
      Mu = null;
      roundedMu = null;
      Rn = null;
      roundedRn = null;
      rho = null;
      roundedrho = null;
      rhoMin = null;
      roundedrhoMin = null;
      rhoFinal = null;
      roundedrhoFinal = null;
      rhoGoverns = null;
      As = null;
      roundedAs = null;
      Ab = null;
      roundedAb = null;
      n = null;
      widget.state.n = null;
      widget.state.roundedn = null;
      return;
    }

    if (widget.state.roundedn != null) {
      setState(() {
        widget.state.showResultsSteel = true;
      });
    } else {
      setState(() {
        showSnackBarIncorrect(context);
        widget.state.showResultsSteel = false;
      });
    }

    print('Mu = $Mu, Rn = $Rn, rho = $rho, rhomin = $rhoMin, rhofinal = $rhoFinal, As = $As, Ab = $Ab, n = $n');
    print('showResults = ${widget.state.showResultsSteel}');
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
                      header1(),
                      Container(
                        width: 350,
                        height: 350,
                        child: Image.asset('assets/images/combined.png'),
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

                      SizedBox(height: 10),

                      switchFactorShear(),
                      containerFactorShear(),

                      SizedBox(height: 10),
                      buttonSubmitPunchWide(),

                      if (widget.state.showResultsPunchWide)
                        SizedBox(height: 10),
                      if (widget.state.showResultsPunchWide)
                        resultTextPunchWide(),

                      if (widget.state.showResultsPunchWide)
                        SizedBox(height: 10),
                      if (widget.state.showResultsPunchWide)
                        buttonSolutionPunchWide(),
                                             
                      if (widget.state.showSolutionPunchWide)
                        SizedBox(height: 10),
                      if (widget.state.showSolutionPunchWide)
                        containerSolutionPunchWide(),
                      
                      SizedBox(height: 10),
                      buttonClearPunchWide(),

                      switchSteel(),

                      if (widget.state.steelToggle)
                        header2(),
                      if (widget.state.steelToggle && side == "Left side (within Column A)")
                        Container(
                          width: 350,
                          height: 350,
                          child: Image.asset('assets/images/combined/reinforcementLeft.png'),
                        ),
                      if (widget.state.steelToggle && side == "Right side (within Column B)")
                        Container(
                          width: 350,
                          height: 350,
                          child: Image.asset('assets/images/combined/reinforcementRight.png'),
                        ),
                      if (widget.state.steelToggle)
                        dropdownBarDia(),
                      if (widget.state.steelToggle && barDia == 'Others')
                        entryOtherDia(),
                      if (widget.state.steelToggle)
                        entry_lengthH(),
                      if (widget.state.steelToggle)
                        entryDepth(),
                      if (widget.state.steelToggle)
                        dropdownSide(),
                      if (widget.state.steelToggle && side == "Left side (within Column A)")
                        entry_lengthA(),
                      if (widget.state.steelToggle && side == "Left side (within Column A)")
                        entry_shearF(),
                      if (widget.state.steelToggle && side == "Right side (within Column B)")
                        entry_lengthE(),
                      if (widget.state.steelToggle && side == "Right side (within Column B)")
                        entry_shearI(),
                      if (widget.state.steelToggle)
                        entryFc(),
                      if (widget.state.steelToggle)
                        entryFy(),

                      if (widget.state.steelToggle)
                        switchFactorMoment(),
                      if (widget.state.steelToggle)
                        containerFactorMoment(),

                      if (widget.state.steelToggle)
                        SizedBox(height: 10),
                      if (widget.state.steelToggle)
                        buttonSubmitSteel(),

                      if (widget.state.steelToggle && widget.state.showResultsSteel)
                        SizedBox(height: 10),
                      if (widget.state.steelToggle && widget.state.showResultsSteel)
                        resultTextSteel(),

                      if (widget.state.steelToggle && widget.state.showResultsSteel)
                        SizedBox(height: 10),
                      if (widget.state.steelToggle && widget.state.showResultsSteel)
                        buttonSolutionSteel(),
                                             
                      if (widget.state.steelToggle && widget.state.showSolutionSteel)
                        SizedBox(height: 10),
                      if (widget.state.steelToggle && widget.state.showSolutionSteel)
                        containerSolutionSteel(),
                      
                      if (widget.state.steelToggle)
                        SizedBox(height: 10),
                      if (widget.state.steelToggle)
                        buttonClearSteel(),
                      if (widget.state.steelToggle)
                        SizedBox(height: 30),
                      if (widget.state.steelToggle)
                        buttonClearAll(),
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
  
  Widget header1() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "For punching and wide-beam shear",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
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
                  "Effective depth (in mm):",
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
                  'Shear reduction factor (assumed as 0.75 if not given)',
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
                subentryFactorShear(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerFactorShear
  Widget subentryFactorShear() {
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
  } // subentryFactorShear
  
  Widget buttonSubmitPunchWide() {
    return ElevatedButton(
      onPressed: () {
        calc();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Calculate punching and wide-beam shear'),
    );
  }

  Widget resultTextPunchWide() { // Under
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              "For punching shear:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Punching shear at A, Vp(A) = ${widget.state.VPA} kN',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Punching shear at B, Vp(B) = ${widget.state.VPB} kN',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Critical punching shear, Vp = ${widget.state.Vp} kN',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "For wide-beam shear:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Wide-beam shear at A, Vw(A) = ${widget.state.VWA} kN',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Wide-beam shear at B, Vw(B) = ${widget.state.VWB} kN',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Critical Wide-beam shear, Vp = ${widget.state.Vw} kN',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }

  void toggleSolutionPunchWide() {
    if (widget.state.solutionTogglePunchWide) {
      widget.state.showSolutionPunchWide = true;
    } else {
      widget.state.showSolutionPunchWide = false;
    }
    setState(() {
      widget.state.solutionTogglePunchWide = !widget.state.solutionTogglePunchWide; // Toggle between functions
    });
  }
  Widget buttonSolutionPunchWide() {
    return ElevatedButton(
      onPressed: toggleSolutionPunchWide,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(solutionButtonLabelPunchWide),
    );
  }
  Widget containerSolutionPunchWide() {
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
                "For punching shear:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Wᵤ = $roundedWu kN/m',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'qᵤ = $roundedqu kPa',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Wᴀ = $roundedWA kN/m',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Wʙ = $roundedWB kN/m',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Pᴀ = $roundedPA kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Pʙ = $roundedPB kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Vᵤᴀ = $roundedVUA kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Vᵤʙ = $roundedVUB kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Punching shear at A, Vp(A) = ${widget.state.VPA} kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Punching shear at B, Vp(B) = ${widget.state.VPB} kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Critical punching shear, Vp = ${widget.state.Vp} kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "For wide-beam shear:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Vᵤᴀ = $roundedVu_WBA kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Vᵤʙ = $roundedVu_WBB kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Wide-beam shear at A, Vw(A) = ${widget.state.VWA} kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Wide-beam shear at B, Vw(B) = ${widget.state.VWB} kN',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Critical Wide-beam shear, Vw = ${widget.state.Vw} kN',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonClearPunchWide() {
    return ElevatedButton(
      onPressed: () {

        inputLength_a.clear();
        inputLength_b.clear();
        inputLength_c.clear();
        inputLength_e.clear();
        inputLength_H.clear();
        inputDepth.clear();
        inputShear_f.clear();
        inputShear_g.clear();
        inputShear_h.clear();
        inputShear_i.clear();
        inputFactorShear.clear();

        setState(() {
          widget.state.factorShearToggle = false;
          widget.state.showResultsPunchWide = false;
          widget.state.showSolutionPunchWide = false;
          widget.state.solutionTogglePunchWide = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text("Clear all values for this part"),
    );
  }

  Widget switchSteel() {
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
                  'Design of steel reinforcements',
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
                    value: widget.state.steelToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.steelToggle = newValue;
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
  } // switchSteel
  
  // design widgets

  Widget header2() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "For design of steel reinforcements",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget switchFactorMoment() {
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
                  'Moment reduction factor (assumed as 0.9 if not given)',
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
                    value: widget.state.factorMomentToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        widget.state.factorMomentToggle = newValue;
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
  } // switchFactorMoment
  Widget containerFactorMoment() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Visibility(
        visible: widget.state.factorMomentToggle,
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
                subentryFactorMoment(),
              ],
            ),
          ),
        ),
      ),
    );
  } // containerFactorMoment
  Widget subentryFactorMoment() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Centers row children horizontally
        children: [
          Flexible(
            child: Container(
              width: 120,
              child: Text(
                'Moment factor, Φ:',
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
    );
  } // subentryFactorMoment
  
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

  Widget buttonSubmitSteel() {
    return ElevatedButton(
      onPressed: () {
        steel();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Calculate the required number of rebars'),
    );
  }

  Widget resultTextSteel() {
    return Flexible(
      child: Container(
        width: 445,
        child: Column(
          children: [
            Text(
              'Number of bars, n = ${widget.state.roundedn}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      )
    );
  }
  void toggleSolutionSteel() {
    if (widget.state.solutionToggleSteel) {
      widget.state.showSolutionSteel = true;
    } else {
      widget.state.showSolutionSteel = false;
    }
    setState(() {
      widget.state.solutionToggleSteel = !widget.state.solutionToggleSteel; // Toggle between functions
    });
  }
  Widget buttonSolutionSteel() {
    return ElevatedButton(
      onPressed: toggleSolutionSteel,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text(solutionButtonLabelSteel),
    );
  }
  Widget containerSolutionSteel() {
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
                'Wᵤ = $roundedWu kN/m',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'qᵤ = $roundedqu kPa',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Flexural strength, Mᵤ = $roundedMu kN-m',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Nominal resistance, Rₙ = $roundedRn MPa',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Reinforcement ratio, ρ = $roundedrho',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'ρmin = $roundedrhoMin',
                style: TextStyle(color: Colors.white),
              ),
              if (rhoGoverns == true)
                Text(
                  'ρ ≥ ρmin, ∴ ρ = ρ',
                  style: TextStyle(color: Colors.white),
                ),
              if (rhoGoverns == false)
                Text(
                  'ρ < ρmin, ∴ ρ = ρmin',
                  style: TextStyle(color: Colors.white),
                ),
              Text(
                'Aₛ = $roundedAs',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Ab = $roundedAb',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'n = ${widget.state.n} ≈ ${widget.state.roundedn}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonClearSteel() {
    return ElevatedButton(
      onPressed: () {        
        barDia = null;
        side = null;

        inputLength_a.clear();
        inputLength_e.clear();
        inputLength_H.clear();
        inputDepth.clear();
        inputShear_f.clear();
        inputShear_i.clear();
        inputFactorMoment.clear();
        inputOtherDia.clear();

        setState(() {
          widget.state.factorMomentToggle = false;
          widget.state.showResultsSteel = false;
          widget.state.showSolutionSteel = false;
          widget.state.solutionToggleSteel = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text("Clear all values for this part"),
    );
  }
  Widget buttonClearAll() {
    return ElevatedButton(
      onPressed: () {        
        barDia = null;
        side = null;

        inputLength_a.clear();
        inputLength_b.clear();
        inputLength_c.clear();
        inputLength_e.clear();
        inputLength_H.clear();
        inputDepth.clear();
        inputShear_f.clear();
        inputShear_g.clear();
        inputShear_h.clear();
        inputShear_i.clear();
        inputFactorShear.clear();
        inputFactorMoment.clear();
        inputOtherDia.clear();

        setState(() {
          widget.state.factorShearToggle = false;
          widget.state.factorMomentToggle = false;
          widget.state.showResultsPunchWide = false;
          widget.state.showSolutionPunchWide = false;
          widget.state.solutionTogglePunchWide = true;
          widget.state.showResultsSteel = false;
          widget.state.showSolutionSteel = false;
          widget.state.solutionToggleSteel = true;
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
  void didUpdateWidget(CombinedPage oldWidget) {
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
