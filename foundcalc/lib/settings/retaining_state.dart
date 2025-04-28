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
  String inputk1 = '';
  String inputk2 = '';
  String inputActiveGamma = '';
  String inputActiveSoilFrictionAngle = '';
  String inputActiveEarthPressure = '';
  String inputActiveCohesion = '';
  String input_D = '';
  String input_H = '';
  String input_a = '';
  String input_b = '';
  String input_c = '';
  String input_d = '';
  String input_e = '';
  String input_f = '';
  String inputYc = '';
  String inputStripLength = '';

    // final answer
    
    double? FSs;
    double? FSo;
    double? eccentricity;
    double? Bover6;
    double? qmin;
    double? qmax;
    

  /*
  // int
  int? solvedCalc;
  */

  // toggles

  bool resultantPa = false;
  bool slopedSoil = false;
  bool passiveSoil = false;

  bool concreteDet = false;
  bool stripDet = false;

  // bool isGammaDryEnabled = false;
  // bool isGammaMoistEnabled = false;
  // bool isGammaSatEnabled = false;

  bool showResults = false;
  bool showSolution = false;
  bool solutionToggle = true;

  final String title;
  RetainingState({required this.title});
}