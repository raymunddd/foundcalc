class AnalRectMomentState {
  // dropdowns
  String? modFactor;
  
  // inputs
  String inputDcc = '';
  String inputB = '';
  String inputL = '';
  String inputT = '';
  String inputDf = '';
  String inputDw = '';

  String inputPDL = '';
  String inputPLL = '';
  String inputPUlt = '';

  String inputMDL = '';
  String inputMLL = '';
  String inputMUlt = '';

  String inputGs = '';
  String inputE = '';
  String inputW = '';

  String inputGammaDry = '';
  String inputGammaMoist = '';
  String inputGammaSat = '';

  String inputYc = '';  
  String inputYw = '';

  String inputBc = '';
  String inputLc = '';
  String inputFc = '';

  String inputTop = '';
  String inputBot = '';
  String inputCc = '';

  // title
  final String title;

  // toggles
  bool toggleP = false;
  bool toggleM = false;
  bool soilProp = true;

  bool topToggle = false;
  bool botToggle = false;
  bool concreteCover = false;

  bool concreteDet = false;
  bool waterDet = false;

  bool design = false;

  bool isGammaSatEnabled = true;
  bool isGammaDryEnabled = true;
  bool isGammaMoistEnabled = true;

  bool scrollToTop = false;

  AnalRectMomentState({required this.title});
}