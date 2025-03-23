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

import 'package:flutter/material.dart';
import '../settings/analysis_state.dart';

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
  /*
  late TextEditingController _input1Controller;
  late TextEditingController _input2Controller;
  late TextEditingController _input3Controller;

  @override
  void initState() {
    super.initState();

    // Set default footing type if not already selected
    widget.state.selectedFootingType ??= 'Square';

    // Initialize controllers with saved state
    _input1Controller = TextEditingController(text: widget.state.depthOfFoundation);
    _input2Controller = TextEditingController(text: widget.state.waterTableDistance);
    _input3Controller = TextEditingController(text: widget.state.baseOfFoundation);
    
    // Add listeners to update state when text changes
    _input1Controller.addListener(_updateState);
    _input2Controller.addListener(_updateState);
    _input3Controller.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      widget.state.depthOfFoundation = _input1Controller.text;
      widget.state.waterTableDistance = _input2Controller.text;
      widget.state.baseOfFoundation = _input3Controller.text;
      widget.onStateChanged(widget.state);
    });
  }

  @override
  void dispose() {
    _input1Controller.dispose();
    _input2Controller.dispose();
    _input3Controller.dispose();
    super.dispose();
  }

  String get _footingLabel {
    switch (widget.state.selectedFootingType) {
      case 'Strip or continuous':
        return 'Width of footing, W (in m):';
      case 'Circular':
        return 'Diameter of footing, D (in m):';
      default:
        return 'Base of footing, B (in m):';
    }
  }
  

  // Dropdown value and options
  String? get _selectedFootingType => widget.state.selectedFootingType;
  final List<String> _footingTypes = [
    'Strip or continuous',
    'Square',
    'Circular',
  ];
*/
String? selectedShearFailure;
  final List<String> shearFailureValues = [
    'General',
    'Local',
  ];

String? selectedFootingType;
  final List<String> footingTypes = [
    'Strip or continuous',
    'Square',
    'Circular',
  ];

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
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures it takes only necessary height
          // form rows
          children: [
            row1ShearFailure(),
            row2FootingType(),
            SizedBox(height: 10),
            submitButton(),
          ],
        ),
      ),
    ),
  );
}

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle form submission
        print('Depth of Foundation: ${widget.state.depthOfFoundation}');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Submit'),
    );
  }

  Widget row1ShearFailure() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
              width: 179,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedShearFailure,
                hint: Text('Select option', style: TextStyle(color: Colors.white)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
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
    );
  }
  Widget row2FootingType() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
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
              width: 179,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedFootingType,
                hint: Text('Select option', style: TextStyle(color: Colors.white)),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
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
    );
  }
}