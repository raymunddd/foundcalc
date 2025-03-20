import 'package:flutter/material.dart';

class AnalysisPage extends StatefulWidget {
  final String title;

  AnalysisPage({required this.title});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  // Controllers for the input fields
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _input3Controller = TextEditingController();

  // Dropdown value and options
  String? _selectedSoilType; // Holds the selected value from the dropdown
  final List<String> _soilTypes = [
    'General shear failure',
    'Local shear failure',
  ]; // Options for the dropdown

  // Second dropdown value and options
  String? _selectedAnotherDropdown; // Holds the selected value from the second dropdown
  final List<String> _anotherDropdownOptions = [
    'Strip or continuous',
    'Square',
    'Circular',
  ]; // Options for the second dropdown

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _input1Controller.dispose();
    _input2Controller.dispose();
    _input3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the form row
            _buildFormRow(),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                String input1 = _input1Controller.text;
                String input2 = _input2Controller.text;
                String input3 = _input3Controller.text;
                String soilType = _selectedSoilType ?? 'Not selected';

                // You can process the inputs here
                print('Input 1: $input1');
                print('Input 2: $input2');
                print('Input 3: $input3');
                print('Soil Type: $soilType');
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
    );
  }

  Widget _buildFormRow() {
    return Column(
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
            SizedBox(width: 10), // Add spacing between label and dropdown
            Container(
              width: 179, // Set the width of the dropdown box
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                isExpanded: true, // Ensure the dropdown expands to fill the container
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
                underline: SizedBox(), // Remove the default underline
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSoilType = newValue;
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
        SizedBox(height: 10), // Spacing between rows

        // Row 2: Type of footing
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Type of footing',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(width: 10), // Add spacing between label and dropdown
            Container(
              width: 179, // Set the width of the dropdown box
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                isExpanded: true, // Ensure the dropdown expands to fill the container
                value: _selectedAnotherDropdown, // Add a new state variable for this dropdown
                hint: Text(
                  'Select option',
                  style: TextStyle(color: Colors.white),
                ),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: SizedBox(), // Remove the default underline
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAnotherDropdown = newValue;
                  });
                },
                items: _anotherDropdownOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 10), // Spacing between rows

         // Row 3: Depth of foundation, Df (in m)
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Depth of foundation, Df (in m):',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(width: 10), // Add spacing between label and input box
            Container(
              width: 179, // Set the width of the input box
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.white, // Change cursor color
                  selectionColor: Colors.blue, // Change selection highlight color
                  selectionHandleColor: Colors.blue, // Change selection handle color
                ),
                child: TextField(
                  controller: _input1Controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Field required",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
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
        SizedBox(height: 10), // Spacing between rows

        // Row 4: Distance of the water table from ground level, Dw (in m)
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Distance of the water table from ground level, Dw (in m):',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(width: 10), // Add spacing between label and input box
            Container(
              width: 179, // Set the width of the input box
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.white, // Change cursor color
                  selectionColor: Colors.blue, // Change selection highlight color
                  selectionHandleColor: Colors.blue, // Change selection handle color
                ),
                child: TextField(
                  controller: _input2Controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Field required",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
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
        SizedBox(height: 10), // Spacing between rows

        // Row 5: Base of the foundation, B (in m)
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Base of the foundation, B (in m):',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(width: 10), // Add spacing between label and input box
            Container(
              width: 179, // Set the width of the input box
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.white, // Change cursor color
                  selectionColor: Colors.blue, // Change selection highlight color
                  selectionHandleColor: Colors.blue, // Change selection handle color
                ),
                child: TextField(
                  controller: _input3Controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Field required",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
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
    );
  }
}