import 'package:flutter/material.dart';
import 'pages/analysis_page.dart'; // Import AnalysisPage
import 'pages/design_page.dart';   // Import DesignPage
import 'pages/about_page.dart';    // Import AboutPage
import 'settings/analysis_state.dart'; // Import AnalysisState

class TabbedHomePage extends StatefulWidget {
  @override
  _TabbedHomePageState createState() => _TabbedHomePageState();
}

class _TabbedHomePageState extends State<TabbedHomePage>
    with TickerProviderStateMixin { // For TabController

  late TabController _tabController;
  List<String> _tabs = ['Home']; // Initial tabs - Removed Analysis 1 and Design 1 from here
  int _tabCounter = 1; // Start counter at 1 (Home is already tab 0)
  List<String> analysisItems = []; // Initialize empty
  List<String> designItems = [];   // Initialize empty
  Map<String, AnalysisState> analysisStates = {};


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  void _addAnalysisItem() {
    setState(() {
      int nextNumber = _getNextNumber(analysisItems, "Analysis");
    String newItem = 'Analysis $nextNumber';
    analysisItems.add(newItem);
    analysisStates[newItem] = AnalysisState(title: newItem); // Create state

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _addDesignItem() {
    setState(() {
      int nextNumber = _getNextNumber(designItems, "Design");
      String newItem = 'Design $nextNumber';
      designItems.add(newItem);
      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }


  int _getNextNumber(List<String> items, String type) {
    if (items.isEmpty) return 1;

    List<int> existingNumbers = items.map((item) {
      return int.tryParse(item.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }).toList();

    int maxNumber = existingNumbers.isEmpty ? 0 : existingNumbers.reduce((a, b) => a > b ? a : b);
    return maxNumber + 1;
  }


  void _removeAnalysisItem(int index) {
    setState(() {
      String removedTab = analysisItems.removeAt(index-1); //index -1 because home is index 0

      int tabIndexToRemove = _tabs.indexOf(removedTab);
      if (tabIndexToRemove != -1) {
        _tabs.removeAt(tabIndexToRemove);
      }


      _tabController = TabController(length: _tabs.length, vsync: this);
      // Prevent exception by going to the last tab if removing current
      if (_tabController.index >= _tabs.length && _tabs.length > 0) {
        _tabController.animateTo(_tabs.length - 1);
      }
    });
  }

  void _removeDesignItem(int index) {
    setState(() {
      String removedTab = designItems.removeAt(index-1); //index -1 because home is index 0
      int tabIndexToRemove = _tabs.indexOf(removedTab);
      if (tabIndexToRemove != -1) {
        _tabs.removeAt(tabIndexToRemove);
      }
      _tabController = TabController(length: _tabs.length, vsync: this);
      // Prevent exception by going to the last tab if removing current
      if (_tabController.index >= _tabs.length && _tabs.length > 0) {
        _tabController.animateTo(_tabs.length - 1);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foundation Calculator Tabs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Allow scrolling for many tabs
          tabs: _tabs.map((title) => Tab(text: title)).toList(),
        ),
        ),
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
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
                      onPressed: () => _removeAnalysisItem(i+1), //+1 because home is index 0
                    ),
                    onTap: () {
                      _tabController.animateTo(i+1); //+1 because home is index 0
                      Navigator.of(context).pop(); // Close the drawer
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
                      onPressed: () => _removeDesignItem(i+1), //+1 because home is index 0
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + i + 1); //+1 because home is index 0
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
              ],
              ListTile(
                tileColor: Color(0xFF414141),
                title: Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
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
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 45),
                  Text(
                    "What would you like to calculate?",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
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
          // Analysis and Design pages will be added dynamically
          // No need to put placeholder AnalysisPage() and DesignPage() here.
          // They will be added in the TabBarView based on _tabs list
          //AnalysisPage(title: 'Analysis 1'), // Removed placeholder
          //DesignPage(title: 'Design 1'),   // Removed placeholder
...analysisItems.map((title) => AnalysisPage(
      title: title,
      state: analysisStates[title]!, // Pass the state
      onStateChanged: (newState) {
        analysisStates[title] = newState;
      },
    )).toList(),
          ...designItems.map((title) => DesignPage(title: title)).toList(),
        ],
      ),
    );
  }
}