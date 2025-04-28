class DeepState {
  // scrollbar
  bool scrollToTop = false;
  // dropdowns

  String? xsection;
  String? compaction;
  
  // inputs
  String inputNq = '';
  String inputK = '';
  String inputFS = '';

  String inputPdim = '';
  String inputDf = '';
  String inputDw = '';

  String inputGs = '';
  String inputE = '';
  String inputW = '';

  String inputGammaDry = '';
  String inputGammaMoist = '';
  String inputGammaSat = '';

  String inputYw = '';

  String inputMu = '';
  String inputFrictionAngle = '';

  String inputNc = '';
  String inputAlpha1 = '';
  String inputAlpha2 = '';
  String inputC1 = '';
  String inputC2 = '';
  String inputQu1 = '';
  String inputQu2 = '';
  
  String inputLambda = '';

  String inputThetaR = '';
  String inputOCR1 = '';
  String inputOCR2 = '';

  String inputS = '';
  String inputNvert = '';
  String inputNhori = '';

  // final answer
  double? Qb;
  double? Qf;
  double? Qult;
  double? Qall;

  double? Eg;
  double? QallGroupAction;
  double? minS;
  /*
  // int
  int? solvedCalc;
  */

  // toggles
  bool soilProp = true;
  bool cohesion = true;
  bool waterDet = false;
  bool frictionDet = true;
  bool kDet = false;
  bool ncDet = false;
  bool normallyCons1 = false;
  bool normallyCons2 = false;

  bool isGammaDryEnabled = false;
  bool isGammaMoistEnabled = false;
  bool isGammaSatEnabled = false;

  bool showResults = false;
  bool showSolution = false;
  bool solutionToggle = true;

  final String title;
  DeepState({required this.title});
}