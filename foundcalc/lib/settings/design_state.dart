class DesignState {

  // Dropdowns
  String? colClass;
  String? material;

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
  //String? selectedFootingType;
  //String depthOfFoundation = '';
  //String waterTableDistance = '';
  //String baseOfFoundation = '';
  final String title;

  bool qToggle = true;
  bool pToggle = true;
  bool topToggle = false;
  bool botToggle = false;
  bool soilProp = true;
  bool weightPressures = false;
  bool concreteDet = false;
  bool otherMat = false;

  bool isGammaSatEnabled = true;
  bool isGammaDryEnabled = true;
  bool isGammaMoistEnabled = true;

  DesignState({required this.title});
}