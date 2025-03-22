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
  String? get _selectedSoilType => widget.state.selectedSoilType;
  final List<String> _soilTypes = [
    'General shear failure',
    'Local shear failure',
  ];

  String? get _selectedFootingType => widget.state.selectedFootingType;
  final List<String> _footingTypes = [
    'Strip or continuous',
    'Square',
    'Circular',
  ];

  // Getter for dropdown value (ensures non-null default)

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF363434),
    appBar: AppBar(
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xFF363434),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures it takes only necessary height
          children: [
            _buildFormRow(),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Container(
                      width: 175.0,
                      child: Text(
                        'Soil properties',
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Switch(
                      value: true, // Ensure _model.switchValue is defined
                      onChanged: (newValue) {
                      },
                      activeColor: Color(0xFF1F538D),
                      inactiveThumbColor: Color(0x80FF5963),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                print('Depth of Foundation: ${widget.state.depthOfFoundation}');
                print('Water Table Distance: ${widget.state.waterTableDistance}');
                print('Base of Footing: ${widget.state.baseOfFoundation}');
                print('Soil Type: ${widget.state.selectedSoilType ?? 'Not selected'}');
                print('Footing Type: ${widget.state.selectedFootingType ?? 'Not selected'}');
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1F538D),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildFormRow() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Row 1: Dropdown for Soil Type
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Type of shear failure:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[800],
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedSoilType,
                  hint: Text(
                    'Select option',
                    style: TextStyle(color: Colors.white),
                  ),
                  dropdownColor: Colors.grey[800],
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.white),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.state.selectedSoilType = newValue;
                      widget.onStateChanged(widget.state);
                    });
                  },
                  items: _soilTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Row 2: Type of footing
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Type of footing:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[800],
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedFootingType,
                  hint: Text(
                    'Select option',
                    style: TextStyle(color: Colors.white),
                  ),
                  dropdownColor: Colors.grey[800],
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.white),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.state.selectedFootingType = newValue;
                      widget.onStateChanged(widget.state);
                    });
                  },
                  items: _footingTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Row 3: Depth of foundation
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Depth of foundation, Df (in m):',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.blue,
                    selectionHandleColor: Colors.blue,
                  ),
                  child: TextField(
                    controller: _input1Controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Field required",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Row 4: Water table distance
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Distance of water table, Dw (in m):',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.blue,
                    selectionHandleColor: Colors.blue,
                  ),
                  child: TextField(
                    controller: _input2Controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Field required",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Row 5: Base of footing
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  _footingLabel,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.blue,
                    selectionHandleColor: Colors.blue,
                  ),
                  child: TextField(
                    controller: _input3Controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Field required",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Row 6: Cohesion
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Cohesion, c",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.blue,
                    selectionHandleColor: Colors.blue,
                  ),
                  child: TextField(
                    controller: _input3Controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Field required",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Row 7: Footing thickness
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Footing thickness, t",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.blue,
                    selectionHandleColor: Colors.blue,
                  ),
                  child: TextField(
                    controller: _input3Controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Optional",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Row 8: Factor of safety
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Factor of safety",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 179,
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.blue,
                    selectionHandleColor: Colors.blue,
                  ),
                  child: TextField(
                    controller: _input3Controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Optional",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}