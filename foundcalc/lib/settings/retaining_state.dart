class RetainingState {
  // scrollbar
  bool scrollToTop = false;
  // dropdowns

  // String? xsection;
  
  // inputs

  String inputIncline = '';
  String input_g = '';
  String input_yPassive = '';
  String inputBaseFriction = '';
  String inputPassiveSoilFrictionAngle = '';
  String inputPassiveEarthPressure = '';
  String inputPassiveCohesion = '';

    // final answer
    /*
    double? fs;
    double? qnetu;
    double? qneta;
    */

  /*
  // int
  int? solvedCalc;
  */

  // toggles

  bool resultantPa = false;
  bool slopedSoil = false;
  bool passiveSoil = false;

  // bool isGammaDryEnabled = false;
  // bool isGammaMoistEnabled = false;
  // bool isGammaSatEnabled = false;

  // bool showResults = false;
  // bool showSolution = false;
  // bool solutionToggle = true;

  final String title;
  RetainingState({required this.title});
}