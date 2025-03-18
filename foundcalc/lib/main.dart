import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white), // Set drawer icon color to white
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> analysisItems = [];
  List<String> designItems = [];

  /// Get the next number based on the max existing number in the list
  int _getNextNumber(List<String> items, String type) {
    if (items.isEmpty) return 1;

    List<int> existingNumbers = items.map((item) {
      return int.tryParse(item.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }).toList();

    int maxNumber = existingNumbers.isEmpty ? 0 : existingNumbers.reduce((a, b) => a > b ? a : b);
    return maxNumber + 1;
  }

  void _addAnalysisItem() {
    setState(() {
      int nextNumber = _getNextNumber(analysisItems, "Analysis");
      String newItem = 'Analysis $nextNumber';
      analysisItems.add(newItem);

      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisPage(title: newItem),
          ),
        );
      });
    });
  }

  void _addDesignItem() {
    setState(() {
      int nextNumber = _getNextNumber(designItems, "Design");
      String newItem = 'Design $nextNumber';
      designItems.add(newItem);

      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DesignPage(title: newItem),
          ),
        );
      });
    });
  }

  void _removeAnalysisItem(int index) {
    setState(() {
      analysisItems.removeAt(index);
    });
  }

  void _removeDesignItem(int index) {
    setState(() {
      designItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      appBar: AppBar(
        title: Text("Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      endDrawer: Drawer(
        child: Container(
          color: Color(0xFF414141), // Set background color behind ListTiles
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF212121)), // Header color
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              if (analysisItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Analysis Tabs',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < analysisItems.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      analysisItems[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removeAnalysisItem(i),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalysisPage(title: analysisItems[i]),
                        ),
                      );
                    },
                  ),
              ],
              if (designItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Design Tabs',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < designItems.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      designItems[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removeDesignItem(i),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DesignPage(title: designItems[i]),
                        ),
                      );
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Block B’s Footing Calculator!",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // Add this line to make the text bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 45), // Adds spacing between the texts
              Text(
                "What would you like to calculate?",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Space before the buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1F538D),
                  foregroundColor: Colors.white,
                ),
                onPressed: _addAnalysisItem,
                child: Text("Analysis"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1F538D),
                  foregroundColor: Colors.white,
                ),
                onPressed: _addDesignItem,
                child: Text("Design"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class DesignPage extends StatefulWidget {
  final String title;

  DesignPage({required this.title});

  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  // You can add state variables and methods here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'Details for ${widget.title}',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}