import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RectMomentLoadWidgets {
  // Concentrated Load Input
  static Widget concentratedLoad({
    required BuildContext context,
    required TextEditingController inputPU,
    required bool pLoadCombi,
    required Function(bool) onPLoadCombiChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            // P input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 150,
                    child: Text(
                      'Value of Concentrated load, P (in kN):',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ),
                SizedBox(
                  width: 179,
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Colors.white,
                    ),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: inputPU,
                        enabled: !pLoadCombi,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: pLoadCombi ? "Input DL & LL" : "Input required",
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear, 
                              color: Colors.white54,
                            ),
                            iconSize: 17,
                            onPressed: () {
                              inputPU.clear();
                            },
                          ),
                        ),
                      )
                    )
                  )
                ),
              ],
            ),
            // Load Combination Toggle
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        'Load Combination',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ),
                  SizedBox(
                    width: 179,
                    child: TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: Colors.white,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Switch(
                          value: pLoadCombi,
                          onChanged: onPLoadCombiChanged,
                          activeTrackColor: const Color.fromARGB(255, 10, 131, 14),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color.fromARGB(255, 201, 40, 29),
                        )
                      )
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Load Combination Container
  static Widget ploadCombination({
    required BuildContext context,
    required TextEditingController inputPDL,
    required TextEditingController inputPLL,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 10, 131, 14),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PDL Input
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'PDL (in kN):',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ),
                    SizedBox(
                      width: 179,
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: Colors.white,
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: inputPDL,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                            ],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Input required",
                              hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear, 
                                  color: Colors.white54,
                                ),
                                iconSize: 17,
                                onPressed: () {
                                  inputPDL.clear();
                                },
                              ),
                            ),
                          )
                        )
                      )
                    ),
                  ],
                ),
              ),
              // PLL Input
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'PLL (in kN):',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ),
                    SizedBox(
                      width: 179,
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: Colors.white,
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: inputPLL,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                            ],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Input required",
                              hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear, 
                                  color: Colors.white54,
                                ),
                                iconSize: 17,
                                onPressed: () {
                                  inputPLL.clear();
                                },
                              ),
                            ),
                          )
                        )
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Moment Input
  static Widget momentLoad({
    required BuildContext context,
    required TextEditingController inputMU,
    required bool mLoadCombi,
    required Function(bool) onMLoadCombiChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            // M input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 150,
                    child: Text(
                      'Value of Moment, M (in kN-m):',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ),
                SizedBox(
                  width: 179,
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Colors.white,
                    ),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: inputMU,
                        enabled: !mLoadCombi,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: mLoadCombi ? "Input DL & LL" : "Input required",
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear, 
                              color: Colors.white54,
                            ),
                            iconSize: 17,
                            onPressed: () {
                              inputMU.clear();
                            },
                          ),
                        ),
                      )
                    )
                  )
                ),
              ],
            ),
            // Moment Load Combination Toggle
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        'Moment Load Combination',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ),
                  SizedBox(
                    width: 179,
                    child: TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: Colors.white,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Switch(
                          value: mLoadCombi,
                          onChanged: onMLoadCombiChanged,
                          activeTrackColor: const Color.fromARGB(255, 10, 131, 14),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color.fromARGB(255, 201, 40, 29),
                        )
                      )
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Moment Load Combination Container
  static Widget momentLoadCombination({
    required BuildContext context,
    required TextEditingController inputMDL,
    required TextEditingController inputMLL,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 10, 131, 14),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // MDL Input
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'MDL (in kN-m):',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ),
                    SizedBox(
                      width: 179,
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: Colors.white,
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: inputMDL,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                            ],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Input required",
                              hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear, 
                                  color: Colors.white54,
                                ),
                                iconSize: 17,
                                onPressed: () {
                                  inputMDL.clear();
                                },
                              ),
                            ),
                          )
                        )
                      )
                    ),
                  ],
                ),
              ),
              // MLL Input
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'MLL (in kN-m):',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ),
                    SizedBox(
                      width: 179,
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: Colors.white,
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: inputMLL,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                            ],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Input required",
                              hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear, 
                                  color: Colors.white54,
                                ),
                                iconSize: 17,
                                onPressed: () {
                                  inputMLL.clear();
                                },
                              ),
                            ),
                          )
                        )
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 