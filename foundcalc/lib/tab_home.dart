import 'package:flutter/material.dart';
import 'pages/analysis_page.dart'; // Import AnalysisPage
import 'pages/design_page.dart';   // Import DesignPage
import 'pages/anal_rectmoment.dart'; // Import AnalRectMomentPage
import 'pages/about_page.dart';    // Import AboutPage
import 'settings/analysis_state.dart'; // Import AnalysisState
import 'settings/design_state.dart';   // Import DesignState
import 'settings/anal_rectmoment_state.dart'; // Import AnalRectMomentState

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
  List<String> analRectMomentItems = []; // Initialize empty for RectMoment
  Map<String, AnalysisState> analysisStates = {};
  Map<String, AnalRectMomentState> analRectMomentStates = {}; // Initialize empty
  Map<String, DesignState> designStates = {};

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

//ANALYSIS
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

  void _removeAnalysisItem(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int analysisIndex = analysisItems.indexOf(tabToRemove);
      
      if (analysisIndex != -1) {
        // Remove from analysisItems and states
        String removedTab = analysisItems.removeAt(analysisIndex);
        analysisStates.remove(removedTab);

        // Remove from tabs
        _tabs.removeAt(index);
        
        // UPDATE (Wag kalimutan)
        _tabController = TabController(length: _tabs.length, vsync: this);
        if (_tabController.index >= _tabs.length && _tabs.isNotEmpty) {
          _tabController.animateTo(_tabs.length - 1);
        }
      }
    });
  }

//DESIGN
  void _addDesignItem() {
    setState(() {
      int nextNumber = _getNextNumber(designItems, "Design");
      String newItem = 'Design $nextNumber';
      designItems.add(newItem);
      designStates[newItem] = DesignState(title: newItem); // Create state

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _removeDesignItem(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int designIndex = designItems.indexOf(tabToRemove);
      
      if (designIndex != -1) {
        // Remove from analysisItems and states
        String removedTab = designItems.removeAt(designIndex);
        designStates.remove(removedTab);

        // Remove from tabs
        _tabs.removeAt(index);
        
        // UPDATE (Wag kalimutan)
        _tabController = TabController(length: _tabs.length, vsync: this);
        if (_tabController.index >= _tabs.length && _tabs.isNotEmpty) {
          _tabController.animateTo(_tabs.length - 1);
        }
      }
    });
  }

//ANAL RECT MOMENT
  void _addAnalRectMomentItem() {
    setState(() {
      int nextNumber = _getNextNumber(analRectMomentItems, "RectMoment");
      String newItem = 'RectMoment $nextNumber';
      analRectMomentItems.add(newItem);
      analRectMomentStates[newItem] = AnalRectMomentState(title: newItem); // Create state

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _removeAnalRectMomentItem(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int rectMomentIndex = analRectMomentItems.indexOf(tabToRemove);
      
      if (rectMomentIndex != -1) {
        // Remove from analRectMomentItems and states
        String removedTab = analRectMomentItems.removeAt(rectMomentIndex);
        analRectMomentStates.remove(removedTab);

        // Remove from tabs
        _tabs.removeAt(index);
        
        // UPDATE
        _tabController = TabController(length: _tabs.length, vsync: this);
        if (_tabController.index >= _tabs.length && _tabs.isNotEmpty) {
          _tabController.animateTo(_tabs.length - 1);
        }
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bg color of scaffold    
      backgroundColor: Color(0xFF363434),
      appBar: AppBar(
        title: Text('Foundation Calculator Tabs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF292828),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF1F538D),
          labelColor: Color(0xFF1F538D),
          isScrollable: true, // Allow scrolling for many tabs
          //CLOSE TABS
          tabs: _tabs.map((title) {
            // Walang X sa Home tab
            if (title == 'Home') {
              return Tab(text: title);
            }
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      // EKIS ang di hometab
                      setState(() {
                        int index = _tabs.indexOf(title);
                        if (title.startsWith('Analysis')) {
                          _removeAnalysisItem(index);
                        } else if (title.startsWith('Design')) {
                          _removeDesignItem(index);
                        } else if (title.startsWith('RectMoment')) {
                          _removeAnalRectMomentItem(index);
                        }
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
  //DRAWER
      endDrawer: Drawer(
        child: Container(
          color: Color(0xFF424140), // Set background color behind ListTiles
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF363434)), // Header color
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              if (analysisItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF424140),
                  title: Text(
                    'Analysis of Footings',
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
              if (analRectMomentItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Analysis of Rectangular Footing with Moment',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < analRectMomentItems.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      analRectMomentItems[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removeAnalRectMomentItem(analysisItems.length + designItems.length + i + 1),
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + designItems.length + i + 1);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
              ],
              if (designItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Design of Footings',
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

//BODY
      body: TabBarView(
        controller: _tabController,
        children: [
        //Home Tab
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Block B's Footing Calculator!",
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
                      child: Text("Analysis of Footings"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1F538D),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _addDesignItem,
                      child: Text("Design of Footings"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1F538D),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _addAnalRectMomentItem,
                      child: Text("Analysis of Rectangular Footings with Moment"),
                    ),
                  ],
                ),
              ),
            ),
            // Analysis and Design pages will be added dynamically
            // They will be added in the TabBarView based on _tabs list

  //View Tabs
          ..._tabs.where((title) => title != 'Home').map((title) {
            if (title.startsWith('Analysis')) {
              return Stack(
                children: [
                  AnalysisPage( 
                    title: title,
                    state: analysisStates[title]!,
                    onStateChanged: (newState) {
                      analysisStates[title] = newState;
                    },
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFF1F538D),
                      mini: true,
                      child: Icon(Icons.arrow_upward, color: Colors.white),
                      onPressed: () {
                        if (title.startsWith('Analysis')) {
                          analysisStates[title]!.scrollToTop = true;
                          setState(() {}); // Trigger rebuild to pass the message
                        }
                      },
                    ),
                  ),
                ],
              );
            } 
            else if (title.startsWith('RectMoment')) {
              return Stack(
                children: [
                  AnalRectMomentPage(
                    title: title,
                    state: analRectMomentStates[title]!,
                    onStateChanged: (newState) {
                      analRectMomentStates[title] = newState;
                    },
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFF1F538D),
                      mini: true,
                      child: Icon(Icons.arrow_upward, color: Colors.white),
                      onPressed: () {
                        if (title.startsWith('RectMoment')) {
                          analRectMomentStates[title]!.scrollToTop = true;
                          setState(() {}); // Trigger rebuild to pass the message
                        }
                      },
                    ),
                  ),
                ],
              );
            } 
            else {
              return Stack(
                children: [
                  DesignPage(
                    title: title,
                    state: designStates[title]!,
                    onStateChanged: (newState) {
                      designStates[title] = newState;
                    },
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFF1F538D),
                      mini: true,
                      child: Icon(Icons.arrow_upward, color: Colors.white),
                      onPressed: () {
                        if (title.startsWith('Design')) {
                          designStates[title]!.scrollToTop = true;
                          setState(() {}); // Trigger rebuild to pass the message
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          }).toList(),
        ],
      ),
    );
  }
}