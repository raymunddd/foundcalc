import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/deep_state.dart';
import 'dart:math';

class DeepPage extends StatefulWidget {
  final String title;
  final DeepState state;
  final Function(DeepState) onStateChanged;

  DeepPage({
    required this.title,
    required this.state,
    required this.onStateChanged,
  });

  @override
  _DeepState createState() => _DeepState();
}

class _DeepState extends State<DeepPage> 
with AutomaticKeepAliveClientMixin<DeepPage>{

  // scrollbar
  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true; 
  int? singular;
  int? soil;
  int? method;

  String get displayTitle {
    if (widget.title.startsWith('Deep')) {
      int index = int.tryParse(widget.title.split(' ').last) ?? 0;
      return "Deep Foundation $index";
    }

    return widget.title; 
  }

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();

    // for input
    
    // inputCu = TextEditingController(text: widget.state.inputCu);

    // for dropdowns

    /*
    loadingCase = widget.state.loadingCase; (no default value)

    calculation = "Factor of safety"; // Set default value here
    widget.state.calculation = calculation;
    */

    // listeners

    // inputCu.addListener(_updateState);
    
  }
  void dispose() {
    _scrollController.dispose();

    // inputCu.dispose();

    super.dispose();
  }

  @override   
  Widget build(BuildContext context) {   
    super.build(context); // Call super.build   
    return Scaffold(
      backgroundColor: Color(0xFF363434),
      appBar: AppBar(
        title: Text(
          displayTitle,
          style: TextStyle(color: Colors.white),
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
                    children: [
                      radioSingle(),
                      if (singular == 1)
                        radioSoil(),
                      if (soil == 2)
                        radioMethod(),
                      /*
                      SizedBox(height: 10),
                      buttonSubmit(),

                      if (widget.state.showResults)
                        SizedBox(height: 10),
                      if (widget.state.showResults)
                        resultText(),

                      if (widget.state.showResults)
                        SizedBox(height: 10),
                      if (widget.state.showResults)
                        solutionButton(),

                      if (widget.state.showSolution)
                        SizedBox(height: 10),
                      if (widget.state.showSolution)
                        containerSolution(),
                      
                      SizedBox(height: 10),
                      clearButton(),
                      */        
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

  Widget radioSingle() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxWidth: 450),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            constraints: BoxConstraints(maxWidth: 225),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: singular,
                  onChanged: (val) {
                    setState(() {
                      singular = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Singular pile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            constraints: BoxConstraints(maxWidth: 225),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 2,
                  groupValue: singular,
                  onChanged: (val) {
                    setState(() {
                      singular = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Group of piles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );    
  }// for FAB to scroll to top
  Widget radioSoil() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxWidth: 450),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            constraints: BoxConstraints(maxWidth: 225),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: soil,
                  onChanged: (val) {
                    setState(() {
                      soil = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Piles on sand',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            constraints: BoxConstraints(maxWidth: 225),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 2,
                  groupValue: soil,
                  onChanged: (val) {
                    setState(() {
                      soil = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'Piles on clay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );    
  }
  Widget radioMethod() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(maxWidth: 450),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: method,
                  onChanged: (val) {
                    setState(() {
                      method = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'α method',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 2,
                  groupValue: method,
                  onChanged: (val) {
                    setState(() {
                      method = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'λ method',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<int>(
                  value: 3,
                  groupValue: method,
                  onChanged: (val) {
                    setState(() {
                      method = val!;
                    });
                  },
                  activeColor: Color(0xFF1F538D),
                ),
                const Flexible(
                  child: Text(
                    'β method',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ), 
        ],
      ),
    );    
  }
  
  // for FAB to scroll to top
  @override
  void didUpdateWidget(DeepPage oldWidget) {
    super.didUpdateWidget(oldWidget);

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

}