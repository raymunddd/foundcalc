import 'package:flutter/material.dart';
import '../settings/design_state.dart';

class DesignPage extends StatefulWidget {
  final String title;
  final DesignState state;
  final Function(DesignState) onStateChanged;

  DesignPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> 
with AutomaticKeepAliveClientMixin<DesignPage> {
  // You can add state variables and methods here

@override
  bool get wantKeepAlive => true; // 2. Override wantKeepAlive and return true

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build
    return Scaffold(
      backgroundColor: Color(0xFF363434),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Color(0xFF363434),
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

