import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RectMomentWidgets {
  // Method returning submit button widget
  static Widget submitButton({
    required Function() addNumbers,
    required Function(bool) updateShowResults,
  }) {
    return ElevatedButton(
      onPressed: () {
        addNumbers();
        updateShowResults(true);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1F538D),
        foregroundColor: Colors.white,
      ),
      child: Text('Add numbers'),
    );
  }
  
  //Soil Properties
  static Widget soilProperties({
    required BuildContext context,
    required bool soilProp,
    required Function(bool) onSoilPropChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                width: 150,
                child: Text(
                  'Soil properties',
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
                    value: soilProp,
                    onChanged: onSoilPropChanged,
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
    );
  }

  // Soil Properties On Widgets
  static Widget soilPropertiesOn({
    required BuildContext context,
    required TextEditingController inputSpecificGravity,
    required TextEditingController inputVoidRatio,
    required TextEditingController inputWaterContent,
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
              // Specific Gravity
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'Specific gravity of soil solids, Gs:',
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
                            controller: inputSpecificGravity,
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
                                  inputSpecificGravity.clear();
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
              // Void Ratio
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'Void ratio, e:',
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
                            controller: inputVoidRatio,
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
                                  inputVoidRatio.clear();
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
              // Water Content
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'Water content, ω (%):',
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
                            controller: inputWaterContent,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                            ],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Optional",
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
                                  inputWaterContent.clear();
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

  // Soil Properties Off Widgets
  static Widget soilPropertiesOff({
    required BuildContext context,
    required TextEditingController inputGammaDry,
    required TextEditingController inputGammaMoist,
    required TextEditingController inputGammaSat,
    required bool isGammaDryEnabled,
    required bool isGammaMoistEnabled,
    required bool isGammaSatEnabled,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 201, 40, 29),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Input only two (2)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                // Gamma Dry
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 120,
                          child: Text(
                            'Dry/bulk unit weight, γdry (in kN/m³):',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
                              controller: inputGammaDry,
                              enabled: isGammaDryEnabled,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                              ],
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: isGammaDryEnabled ? "Input required" : "Input not required",
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
                                    inputGammaDry.clear();
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
                // Gamma Moist
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 120,
                          child: Text(
                            'Moist unit weight, γ (in kN/m³):',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
                              controller: inputGammaMoist,
                              enabled: isGammaMoistEnabled,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                              ],
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: isGammaMoistEnabled ? "Input required" : "Input not required",
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
                                    inputGammaMoist.clear();
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
                // Gamma Sat
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 120,
                          child: Text(
                            'Saturated unit weight, γsat (in kN/m³):',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
                              controller: inputGammaSat,
                              enabled: isGammaSatEnabled,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                              ],
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: isGammaSatEnabled ? "Input required" : "Input not required",
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
                                    inputGammaSat.clear();
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
      ),
    );
  }

  // Row 1 widget
  static Widget row1({
    required BuildContext context,
    required TextEditingController inputNumberOne,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                width: 150,
                child: Text(
                  '1st number to be added:',
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
                    controller: inputNumberOne,
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
                          inputNumberOne.clear();
                        },
                      ),
                    ),
                  )
                )
              ),
            ),
          ],
        ),
      ),        
    );
  }

  // Row 1 widget
  static Widget row2({
    required BuildContext context,
    required TextEditingController inputNumberTwo,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                width: 150,
                child: Text(
                  '1st number to be added:',
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
                    controller: inputNumberTwo,
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
                          inputNumberTwo.clear();
                        },
                      ),
                    ),
                  )
                )
              ),
            ),
          ],
        ),
      ),        
    );

}

// Row 1 widget
  static Widget row3({
    required BuildContext context,
    required TextEditingController inputNumberThree,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                width: 150,
                child: Text(
                  '1st number to be added:',
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
                    controller: inputNumberThree,
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
                          inputNumberThree.clear();
                        },
                      ),
                    ),
                  )
                )
              ),
            ),
          ],
        ),
      ),        
    );
}

// Row 1 widget
  static Widget row4({
    required BuildContext context,
    required TextEditingController inputNumberFour,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                width: 150,
                child: Text(
                  '1st number to be added:',
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
                    controller: inputNumberFour,
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
                          inputNumberFour.clear();
                        },
                      ),
                    ),
                  )
                )
              ),
            ),
          ],
        ),
      ),        
    );
}
}

