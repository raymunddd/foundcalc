import 'package:flutter/material.dart';
import 'pages/about_page.dart';    // Import AboutPage
// pages
import 'pages/analysis_page.dart'; // Import AnalysisPage
import 'pages/design_page.dart' as design;   // Import DesignPage with alias
import 'pages/anal_rectmoment.dart'; // Import AnalRectMomentPage
import 'pages/combined_footing.dart'; // Import combined footing with alias
import 'pages/mat_foundation.dart'; // Import MatFoundationPage
import 'pages/deep.dart'; // Import DeepPage

import 'pages/retaining.dart'; // Import RetainingPage
// settings
import 'settings/analysis_state.dart'; // Import AnalysisState
import 'settings/design_state.dart';   // Import DesignState
import 'settings/combined_footing_state.dart'; // Import CombinedFootingState
import 'settings/anal_rectmoment_state.dart'; // Import AnalRectMomentState
import 'settings/mat_foundation_state.dart'; // Import MatFoundationState
import 'settings/deep_state.dart'; // Import DeepState

import 'settings/retaining_state.dart'; // Import RetainingState
class TabbedHomePage extends StatefulWidget {
  @override
  _TabbedHomePageState createState() => _TabbedHomePageState();
}

class _TabbedHomePageState extends State<TabbedHomePage>
    with TickerProviderStateMixin { // For TabController

  late TabController _tabController;
  late ScrollController _scrollController;

  List<String> _tabs = ['Home']; // Initial tabs - Removed Analysis 1 and Design 1 from here
  int _tabCounter = 1; // Start counter at 1 (Home is already tab 0)

  List<String> analysisItems = []; // Initialize empty
  List<String> designItems = [];   // Initialize empty
  List<String> analRectMomentItems = []; // Initialize empty for RectMoment
  List<String> combinedFootingItems = []; // Initialize empty for Combined Footing
  List<String> matFoundationItems = []; // Initialize empty for Mat Foundation
  List<String> deepItems = []; // Initialize empty for Deep Foundation

  List<String> retainingItems = []; // Initialize empty for Retaining Wall

  Map<String, AnalysisState> analysisStates = {};
  Map<String, AnalRectMomentState> analRectMomentStates = {}; // Initialize empty
  Map<String, DesignState> designStates = {};
  Map<String, CombinedFootingState> combinedFootingStates = {};
  Map<String, MatFoundationState> matFoundationStates = {};
  Map<String, DeepState> deepStates = {};

  Map<String, RetainingState> retainingStates = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this); // Initialize TabController
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    _scrollController = ScrollController();
    super.dispose();
  }

  int _getNextNumber(List<String> items, String type) {
    if (items.isEmpty) return 1;

    List<int> existingNumbers = items.map((item) {
      return int.tryParse(item.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }).toList();

    int maxNumber = existingNumbers.isEmpty ? 0 : existingNumbers.reduce((a, b) => a > b ? a : b);
    return maxNumber + 1;
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

//COMBINED FOOTING
  void _addCombinedFootingItem() {
    setState(() {
      int nextNumber = _getNextNumber(combinedFootingItems, "Combined");
      String newItem = 'Combined $nextNumber';
      combinedFootingItems.add(newItem);
      combinedFootingStates[newItem] = CombinedFootingState(title: newItem); // Create state using CombinedFootingState

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _removeCombinedFootingItem(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int combinedIndex = combinedFootingItems.indexOf(tabToRemove);
      
      if (combinedIndex != -1) {
        // Remove from combinedFootingItems and states
        String removedTab = combinedFootingItems.removeAt(combinedIndex);
        combinedFootingStates.remove(removedTab);

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

  // Mat Foundation     
  void _addMatFoundationItem() {
    setState(() {
      int nextNumber = _getNextNumber(matFoundationItems, "Mat");
      String newItem = 'Mat $nextNumber';
      matFoundationItems.add(newItem);
      matFoundationStates[newItem] = MatFoundationState(title: newItem); // Create state

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _removeMatFoundationItem(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int matFoundationIndex = matFoundationItems.indexOf(tabToRemove);
            
      if (matFoundationIndex != -1) {
        String removedTab = matFoundationItems.removeAt(matFoundationIndex);
        matFoundationStates.remove(removedTab);

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

  // Deep Foundation     
  void _addDeepItem() {
    setState(() {
      int nextNumber = _getNextNumber(deepItems, "Deep");
      String newItem = 'Deep $nextNumber';
      deepItems.add(newItem);
      deepStates[newItem] = DeepState(title: newItem); // Create state

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _removeDeepItem(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int deepIndex = deepItems.indexOf(tabToRemove);
            
      if (deepIndex != -1) {
        String removedTab = deepItems.removeAt(deepIndex);
        deepStates.remove(removedTab);

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

  // Retaining Wall     
  void _addRetainingItem() {
    setState(() {
      int nextNumber = _getNextNumber(retainingItems, "RetWall");
      String newItem = 'RetWall $nextNumber';
      retainingItems.add(newItem);
      retainingStates[newItem] = RetainingState(title: newItem); // Create state

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _removeRetainingItem(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int retainingIndex = retainingItems.indexOf(tabToRemove);
            
      if (retainingIndex != -1) {
        String removedTab = retainingItems.removeAt(retainingIndex);
        retainingStates.remove(removedTab);

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

  /*TEMPLATE KUNG LALAGAY NG IBA PANG CALC
        
  void _add<[NameNgCalc]>Item() {
    setState(() {
      int nextNumber = _getNextNumber(<[NameNgCalc]>Items, "Analysis");
      String newItem = 'Name $nextNumber';
      <[NameNgCalc]>Items.add(newItem);
      <[NameNgCalc]>States[newItem] = <[NameNgCalc]>State(title: newItem); // Create state

      _tabs.add(newItem); // Add to tabs list for display
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1); // Switch to the new tab
      _tabCounter++;
    });
  }

  void _remove<[NameNgCalc]>Item(int index) {
    setState(() {
      String tabToRemove = _tabs[index];
      int <[NameNgCalc]>Index = <[NameNgCalc]>Items.indexOf(tabToRemove);
            
      if (<[NameNgCalc]>Index != -1) {
        // Remove from analysisItems and states
        String removedTab = <[NameNgCalc]>Items.removeAt(<[NameNgCalc]>Index);
        <[NameNgCalc]>States.remove(removedTab);

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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bg color of scaffold    
      backgroundColor: Color(0xFF363434),
      appBar: AppBar(
        title: Text('FoundCalc',
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
                            } else if (title.startsWith('Combined')) {
                              _removeCombinedFootingItem(index);
                            } else if (title.startsWith('Mat')) {
                              _removeMatFoundationItem(index);
                            } else if (title.startsWith('Deep')) {
                              _removeDeepItem(index);
                            } else if (title.startsWith('RetWall')) {
                              _removeRetainingItem(index);
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
                      onPressed: () => _removeDesignItem(analysisItems.length + i + 1), //+1 because home is index 0
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + i + 1); //+1 because home is index 0
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
              if (combinedFootingItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Combined Footing',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < combinedFootingItems.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      combinedFootingItems[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removeCombinedFootingItem(analysisItems.length + designItems.length + analRectMomentItems.length + i + 1),
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + designItems.length + analRectMomentItems.length + i + 1);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ],
                if (matFoundationItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Mat Foundation',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < matFoundationItems.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      matFoundationItems[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removeMatFoundationItem(analysisItems.length + designItems.length + analRectMomentItems.length + combinedFootingItems.length + i + 1),
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + designItems.length + analRectMomentItems.length + combinedFootingItems.length + i + 1);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
              ],
              if (deepItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Deep Foundation',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < deepItems.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      deepItems[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removeDeepItem(analysisItems.length + designItems.length + analRectMomentItems.length + combinedFootingItems.length + matFoundationItems.length + i + 1),
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + designItems.length + analRectMomentItems.length + combinedFootingItems.length + matFoundationItems.length + i + 1);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
              ],
              if (retainingItems.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Retaining Wall',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < retainingItems.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      retainingItems[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _removeRetainingItem(analysisItems.length + designItems.length + analRectMomentItems.length + combinedFootingItems.length + matFoundationItems.length + retainingItems.length + i + 1),
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + designItems.length + analRectMomentItems.length + combinedFootingItems.length + matFoundationItems.length + retainingItems.length + i + 1);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
              ],
              
              /*
              if (<[NameNgCalc]>Items.isNotEmpty) ...[
                ListTile(
                  tileColor: Color(0xFF414141),
                  title: Text(
                    'Design Tabs',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                for (int i = 0; i < <[NameNgCalc]>Items.length; i++)
                  ListTile(
                    tileColor: Color(0xFF414141),
                    title: Text(
                      <[NameNgCalc]>Items[i],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _remove<[NameNgCalc]>Item(i+1), //+1 because home is index 0
                    ),
                    onTap: () {
                      _tabController.animateTo(analysisItems.length + i + 1); //+1 because home is index 0
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
              ],*/
              /*
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
              */
            ],
          ),
        ),
      ),

//BODY
      body: TabBarView(
        controller: _tabController,
        children: [
        // Home Tab
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(Colors.grey[800]), // Set the thumb color to white
                  trackColor: WidgetStateProperty.all(Colors.grey[800]), // Optional: Set the track color
                ),
                child: Scrollbar(
                  controller: _scrollController, // Link the ScrollController
                  thickness: 4,
                  radius: Radius.circular(10),
                  thumbVisibility: true, // Always show the scrollbar
                  child: SingleChildScrollView(
                    controller: _scrollController, // Link the ScrollController
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Welcome to FoundCalc, Block B’s Footing Calculator!",
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
                                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                              ),
                              onPressed: _addAnalRectMomentItem,
                              child: SizedBox(
                                width: 250,
                                child: Text(
                                  "Analysis and Design of Rectangular Footings with Moment",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1F538D),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _addCombinedFootingItem,
                              child: Text("Combined Footing"),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1F538D),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _addMatFoundationItem,
                              child: Text("Mat Foundation"),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1F538D),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _addDeepItem,
                              child: Text("Deep Foundation"),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1F538D),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _addRetainingItem,
                              child: Text("Retaining Wall"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Analysis and Design pages will be added dynamically
            // They will be added in the TabBarView based on _tabs list



  //View Tabs
          ..._tabs.where((title) => title != 'Home').map((title) {
            //Copy paste nalang natin to if need gumawa bagong calc
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
            else if (title.startsWith('Combined')) {
              return Stack(
                children: [
                  CombinedPage(
                    title: title,
                    state: combinedFootingStates[title]!,
                    onStateChanged: (newState) {
                      combinedFootingStates[title] = newState;
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
                        if (title.startsWith('Combined')) {
                          combinedFootingStates[title]!.scrollToTop = true;
                          setState(() {}); // Trigger rebuild to pass the message
                        }
                      },
                    ),
                  ),
                ],
              );
            }
            else if (title.startsWith('Mat')) {
              return Stack(
                children: [
                  MatFoundationPage(
                    title: title,
                    state: matFoundationStates[title]!,
                    onStateChanged: (newState) {
                      matFoundationStates[title] = newState;
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
                        if (title.startsWith('Mat')) {
                          matFoundationStates[title]!.scrollToTop = true;
                          setState(() {}); // Trigger rebuild to pass the message
                        }
                      },
                    ),
                  ),
                ],
              );
            }
            else if (title.startsWith('Deep')) {
              return Stack(
                children: [
                  DeepPage(
                    title: title,
                    state: deepStates[title]!,
                    onStateChanged: (newState) {
                      deepStates[title] = newState;
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
                        if (title.startsWith('Deep')) {
                          deepStates[title]!.scrollToTop = true;
                          setState(() {}); // Trigger rebuild to pass the message
                        }
                      },
                    ),
                  ),
                ],
              );
            }
            else if (title.startsWith('RetWall')) {
              return Stack(
                children: [
                  RetainingPage(
                    title: title,
                    state: retainingStates[title]!,
                    onStateChanged: (newState) {
                      retainingStates[title] = newState;
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
                        if (title.startsWith('RetWall')) {
                          retainingStates[title]!.scrollToTop = true;
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
                  design.DesignPage(
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