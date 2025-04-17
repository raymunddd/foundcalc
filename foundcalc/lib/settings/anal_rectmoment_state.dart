class AnalRectMomentState {
  // dropdowns
  String? modFactor;
  String? loadingCase;
  String? material;
  String? mDirection;
  String? hDirection;
  
  // inputs
  String inputEte = '';
  String inputB = '';
  String inputL = '';
  String inputC1 = '';
  String inputC2 = '';
  String inputT = '';
  String inputDf = '';
  String inputHf = '';
  String inputDw = '';

  String inputPDL = '';
  String inputPLL = '';
  String inputPUlt = '';

  String inputMDL = '';
  String inputMLL = '';
  String inputMUlt = '';

  String inputHDL = '';
  String inputHLL = '';
  String inputHUlt = '';

  String inputGs = '';
  String inputE = '';
  String inputW = '';

  String inputGammaDry = '';
  String inputGammaMoist = '';
  String inputGammaSat = '';

  String inputFloorLoading = '';
  String inputFloorThickness = '';
  String inputOtherUnitWeight = '';

  String inputYc = '';  
  String inputYw = '';
  String inputFc = '';

  String inputTop = '';
  String inputBot = '';
  String inputCc = '';


  // title
  final String title;

  // toggles
  bool toggleP = false;
  bool toggleM = false;
  bool toggleH = false;
  bool soilProp = true;

  bool weightPressures = false;
  bool otherMat = false;

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

  bool showResultsAnalysis = false;
  bool solutionToggleAnalysis = true;
  bool showSolutionAnalysis = false;
  
  bool showResultsDesign = false;
  bool solutionToggleDesign = true;
  bool showSolutionDesign = false;

  // final answer
  double? finalQgmin;
  double? finalQgmax;

  AnalRectMomentState({required this.title});
}