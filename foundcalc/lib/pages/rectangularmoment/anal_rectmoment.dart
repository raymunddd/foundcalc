//import 'dart:collection';
//import 'package:excel/excel.dart';
//import 'dart:math';
import 'package:flutter/material.dart';
import '../../settings/anal_rectmoment_state.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:foundcalc/pages/rectangularmoment/widget_rectmoment.dart';
import 'package:foundcalc/pages/rectangularmoment/widget_rectmoment_loads.dart';

//Widget class
  class AnalRectMomentPage extends StatefulWidget {
    final String title;
    final AnalRectMomentState state;
    final Function(AnalRectMomentState) onStateChanged;

    const AnalRectMomentPage({super.key, 
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
    bool get wantKeepAlive => true; // tells Flutter to keep this page in memory even when it's not visible.


//ITO ANG SALARIN ng title
  String get displayTitle {
  if (widget.title.startsWith('RectMoment')) {
        int index = int.tryParse(widget.title.split(' ').last) ?? 0;
        return "Analysis of Rectangular Footing with Moment $index"; // Shorter for tab
      }

      return widget.title; 
    }


//VARIABLES
  

  late ScrollController _scrollController;
  late TextEditingController inputNumberOne;
  late TextEditingController inputNumberTwo;
  late TextEditingController inputNumberThree;

  // Soil Properties Controllers
  late TextEditingController inputSpecificGravity;
  late TextEditingController inputWaterContent;
  late TextEditingController inputVoidRatio;
  late TextEditingController inputGammaDry;
  late TextEditingController inputGammaMoist;
  late TextEditingController inputGammaSat;

  // Concentrated Load Controllers
  late TextEditingController inputPU;
  late TextEditingController inputPDL;
  late TextEditingController inputPLL;
  bool pLoadCombi = false;

  // Moment Controllers
  late TextEditingController inputMU;
  late TextEditingController inputMDL;
  late TextEditingController inputMLL;
  bool mLoadCombi = false;

  double? one;
  double? two;
  double? three;

  double? sum;
  bool soilProp = false; // Add soil properties state

  bool showResults = false;

  //Initializing
  @override
    void initState() {
      super.initState();
      
      _scrollController = ScrollController();

      inputNumberOne = TextEditingController(text: widget.state.inputNumberOne);
      inputNumberTwo = TextEditingController(text: widget.state.inputNumberTwo);
      inputNumberThree = TextEditingController(text: widget.state.inputNumberThree);
      soilProp = widget.state.soilProp; // Initialize soil properties state

      // Soil Properties Controllers
      inputSpecificGravity = TextEditingController(text: widget.state.inputSpecificGravity);
      inputWaterContent = TextEditingController(text: widget.state.inputWaterContent);
      inputVoidRatio = TextEditingController(text: widget.state.inputVoidRatio);
      inputGammaDry = TextEditingController(text: widget.state.inputGammaDry);
      inputGammaMoist = TextEditingController(text: widget.state.inputGammaMoist);
      inputGammaSat = TextEditingController(text: widget.state.inputGammaSat);

      // Concentrated Load Controllers
      inputPU = TextEditingController(text: widget.state.inputPU);
      inputPDL = TextEditingController(text: widget.state.inputPDL);
      inputPLL = TextEditingController(text: widget.state.inputPLL);
      pLoadCombi = widget.state.pLoadCombi;

      // Moment Controllers
      inputMU = TextEditingController(text: widget.state.inputMU);
      inputMDL = TextEditingController(text: widget.state.inputMDL);
      inputMLL = TextEditingController(text: widget.state.inputMLL);
      mLoadCombi = widget.state.mLoadCombi;

      // listeners
      inputNumberOne.addListener(_updateState);
      inputNumberTwo.addListener(_updateState);
      inputNumberThree.addListener(_updateState);
      inputSpecificGravity.addListener(_updateState);
      inputWaterContent.addListener(_updateState);
      inputVoidRatio.addListener(_updateState);
      inputGammaDry.addListener(_updateState);
      inputGammaMoist.addListener(_updateState);
      inputGammaSat.addListener(_updateState);
      inputPU.addListener(_updateState);
      inputPDL.addListener(_updateLoadCombination);
      inputPLL.addListener(_updateLoadCombination);
      inputMU.addListener(_updateState);
      inputMDL.addListener(_updateMomentLoadCombination);
      inputMLL.addListener(_updateMomentLoadCombination);
    }

  //Updating
  @override
    //Scroll
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

  //Ito yun nagsasave
    void _updateState() {
      setState(() {
        widget.state.inputNumberOne = inputNumberOne.text;
        widget.state.inputNumberTwo = inputNumberTwo.text;
        widget.state.inputNumberThree = inputNumberThree.text;
        widget.state.soilProp = soilProp;

        // Update soil properties state
        widget.state.inputSpecificGravity = inputSpecificGravity.text;
        widget.state.inputWaterContent = inputWaterContent.text;
        widget.state.inputVoidRatio = inputVoidRatio.text;
        widget.state.inputGammaDry = inputGammaDry.text;
        widget.state.inputGammaMoist = inputGammaMoist.text;
        widget.state.inputGammaSat = inputGammaSat.text;

        // Update concentrated load state
        widget.state.inputPU = inputPU.text;
        widget.state.inputPDL = inputPDL.text;
        widget.state.inputPLL = inputPLL.text;
        widget.state.pLoadCombi = pLoadCombi;

        // Update moment state
        widget.state.inputMU = inputMU.text;
        widget.state.inputMDL = inputMDL.text;
        widget.state.inputMLL = inputMLL.text;
        widget.state.mLoadCombi = mLoadCombi;

        // Handle mutual exclusivity between GammaDry and GammaMoist
        if (inputGammaDry.text.isNotEmpty) {
          widget.state.isGammaDryEnabled = true;
          widget.state.isGammaMoistEnabled = false;
          inputGammaMoist.clear(); // Clear GammaMoist if GammaDry has input
        } else if (inputGammaMoist.text.isNotEmpty) {
          widget.state.isGammaDryEnabled = false;
          widget.state.isGammaMoistEnabled = true;
          inputGammaDry.clear(); // Clear GammaDry if GammaMoist has input
        } else {
          // If both are empty, both are enabled
          widget.state.isGammaDryEnabled = true;
          widget.state.isGammaMoistEnabled = true;
        }

        // GammaSat is always disabled
        widget.state.isGammaSatEnabled = false;

        widget.onStateChanged(widget.state);
      });
    }

  // Update load combination
  void _updateLoadCombination() {
    if (pLoadCombi) {
      double? pdl = double.tryParse(inputPDL.text);
      double? pll = double.tryParse(inputPLL.text);
      
      if (pdl != null && pll != null) {
        double pu = 1.2 * pdl + 1.6 * pll;
        inputPU.text = pu.toStringAsFixed(2);
      }
    }
    _updateState();
  }

  // Update moment load combination
  void _updateMomentLoadCombination() {
    if (mLoadCombi) {
      double? mdl = double.tryParse(inputMDL.text);
      double? mll = double.tryParse(inputMLL.text);
      
      if (mdl != null && mll != null) {
        double mu = 1.2 * mdl + 1.6 * mll;
        inputMU.text = mu.toStringAsFixed(2);
      }
    }
    _updateState();
  }

  //Calculation Functions
  void addNumbers() {
    one = double.tryParse(inputNumberOne.text);
    two = double.tryParse(inputNumberTwo.text);
    three = double.tryParse(inputNumberThree.text);

    // Check if all numbers are entered
      if (one == null || two == null || three == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter all numbers before proceeding.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return; // Stop execution if any number is missing
      }

      // Check if an operation is selected
      if (selectedOperation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an operation before proceeding.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return; // Stop execution if no operation is selected
      }

    // Perform the calculation
    if (selectedOperation == 'Addition') {
      sum = one! + two! + three!;
    } else {
      sum = one! * two! * three!;
    }

    // Only show the result if all inputs are valid and an operation is selected
    setState(() {
      showResults = true;
    });
  }
 // addNumbers

//Operation Options
  String? selectedOperation;
  final List<String> operations = [
    'Addition',
    'Multiplication',
  ];


//Ibuild na
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
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ensures it takes only necessary height
                    // row managerrrr

                //Dito ko na ilagay mga widgets (imported from widget_rectmoment.dart)
                    children: [
                      RectMomentWidgets.soilProperties(
                        context: context,
                        soilProp: soilProp,
                        onSoilPropChanged: (value) {
                          setState(() {
                            soilProp = value;
                            _updateState();
                          });
                        },
                      ),
                      Visibility(
                        visible: soilProp,
                        child: RectMomentWidgets.soilPropertiesOn(
                          context: context,
                          inputSpecificGravity: inputSpecificGravity,
                          inputVoidRatio: inputVoidRatio,
                          inputWaterContent: inputWaterContent,
                        ),
                      ),
                      Visibility(
                        visible: !soilProp,
                        child: RectMomentWidgets.soilPropertiesOff(
                          context: context,
                          inputGammaDry: inputGammaDry,
                          inputGammaMoist: inputGammaMoist,
                          inputGammaSat: inputGammaSat,
                          isGammaDryEnabled: widget.state.isGammaDryEnabled,
                          isGammaMoistEnabled: widget.state.isGammaMoistEnabled,
                          isGammaSatEnabled: widget.state.isGammaSatEnabled,
                        ),
                      ),
                      RectMomentLoadWidgets.concentratedLoad(
                        context: context,
                        inputPU: inputPU,
                        pLoadCombi: pLoadCombi,
                        onPLoadCombiChanged: (value) {
                          setState(() {
                            pLoadCombi = value;
                            if (value) {
                              inputPU.clear();
                            }
                            _updateState();
                          });
                        },
                      ),
                      Visibility(
                        visible: pLoadCombi,
                        child: RectMomentLoadWidgets.ploadCombination(
                          context: context,
                          inputPDL: inputPDL,
                          inputPLL: inputPLL,
                        ),
                      ),
                      RectMomentLoadWidgets.momentLoad(
                        context: context,
                        inputMU: inputMU,
                        mLoadCombi: mLoadCombi,
                        onMLoadCombiChanged: (value) {
                          setState(() {
                            mLoadCombi = value;
                            if (value) {
                              inputMU.clear();
                            }
                            _updateState();
                          });
                        },
                      ),
                      Visibility(
                        visible: mLoadCombi,
                        child: RectMomentLoadWidgets.momentLoadCombination(
                          context: context,
                          inputMDL: inputMDL,
                          inputMLL: inputMLL,
                        ),
                      ),
                      RectMomentWidgets.row1(
                        context: context,
                        inputNumberOne: inputNumberOne,
                      ),
                      RectMomentWidgets.row2(
                        context: context,
                        inputNumberTwo: inputNumberTwo,
                      ),
                      RectMomentWidgets.row3(
                        context: context,
                        inputNumberThree: inputNumberThree,
                      ),

                      RectMomentWidgets.submitButton(
                        addNumbers: addNumbers,
                        updateShowResults: (value) {
                          setState(() {
                            showResults = value;
                          });
                        },
                      ),

                      // Result display
                      if (showResults)
                      Text(
                        '${selectedOperation == "Multiplication" ? "Product" : "Sum"} = $sum',
                        style: TextStyle(color: Colors.white),
                      ),
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

//Dispose para di pumuno memory
@override
void dispose() {
  // Clean up controllers
  inputNumberOne.dispose();
  inputNumberTwo.dispose();
  inputNumberThree.dispose();
  _scrollController.dispose();
  
  // Clean up soil properties controllers
  inputSpecificGravity.dispose();
  inputWaterContent.dispose();
  inputVoidRatio.dispose();
  inputGammaDry.dispose();
  inputGammaMoist.dispose();
  inputGammaSat.dispose();
  
  // Clean up concentrated load controllers
  inputPU.dispose();
  inputPDL.dispose();
  inputPLL.dispose();
  
  // Clean up moment controllers
  inputMU.dispose();
  inputMDL.dispose();
  inputMLL.dispose();
  
  // Always call super.dispose() last
    super.dispose();
  }

} // _AnalRectMomentPageState

