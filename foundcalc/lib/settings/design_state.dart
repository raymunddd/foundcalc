class DesignState {

  // Dropdowns
  String? colClass;
  String? material;
  String? modFactor;

  // TextFields
  String inputQAll = '';
  String inputQUlt = '';
  String inputFS = '';
  String inputfcPrime = '';
  String inputDf = '';
  String inputDw = '';
  String inputPDL = '';
  String inputPLL = '';
  String inputTop = '';
  String inputBot = '';
  String inputGs = '';
  String inputE = '';
  String inputW = '';
  String inputGammaDry = '';
  String inputGammaMoist = '';
  String inputGammaSat = '';
  String inputFloorLoading = '';
  String inputFloorThickness = '';
  String inputFootingThickness = '';
  String inputYw = '';
  String inputYc = '';
  String inputOtherUnitWeight = '';
  String inputColBase = '';
  String inputCc = '';
  final String title;

  bool scrollToTop = false;

  bool qToggle = true;
  bool pToggle = true;
  bool topToggle = false;
  bool botToggle = false;
  bool soilProp = true;
  bool weightPressures = false;
  bool concreteDet = false;
  bool waterDet = false;
  bool otherMat = false;
  bool concreteCover = false;

  bool isGammaSatEnabled = true;
  bool isGammaDryEnabled = true;
  bool isGammaMoistEnabled = true;

  bool showResultsOWSFirst = false;
  bool showResultsTWSFirst = false;

  // Final answer, No erasures
    double? finalAnswerB;
    double? finalAnswerT;
    double? finalAnswerD;
    double? finalAnswerVuows;
    double? finalAnswerVucows;
    double? finalAnswerVutws;
    double? finalAnswerVuctws;

  DesignState({required this.title});
}