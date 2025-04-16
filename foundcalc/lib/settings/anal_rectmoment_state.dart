class AnalRectMomentState {
  String title;
  String inputNumberOne;
  String inputNumberTwo;
  String inputNumberThree;
  bool scrollToTop = false;
  bool soilProp = false;

  // Soil Properties
  String inputSpecificGravity = '';
  String inputWaterContent = '';
  String inputVoidRatio = '';
  // Unit Weights
  String inputGammaDry = '';
  String inputGammaMoist = '';
  String inputGammaSat = '';

  // Toggles for unit weights
  bool isGammaSatEnabled = false;
  bool isGammaDryEnabled = true;
  bool isGammaMoistEnabled = true;

  // Concentrated Load
  String inputPU = '';
  String inputPDL = '';
  String inputPLL = '';
  bool pLoadCombi = false;

  // Moment
  String inputMU = '';
  String inputMDL = '';
  String inputMLL = '';
  bool mLoadCombi = false;

  AnalRectMomentState({
    required this.title,
    this.inputNumberOne = '',
    this.inputNumberTwo = '',
    this.inputNumberThree = '',
    this.soilProp = false,
  });
}