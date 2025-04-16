import 'package:flutter/material.dart';
import '../settings/design_state.dart';

class DesignPage extends StatefulWidget {
  final String title;
  final DesignState state;
  final Function(DesignState) onStateChanged;

  const DesignPage({super.key, 
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> 
with AutomaticKeepAliveClientMixin<DesignPage> {
  // Add ScrollController
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(DesignPage oldWidget) {
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; // Override wantKeepAlive and return true
  
  String get displayTitle {
    if (widget.title.startsWith('Design')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Design of Footings $index"; // Shorter for tab
    }
    return widget.title;
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
      // Use SingleChildScrollView with the _scrollController
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Text(
            'Coming soon!',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}