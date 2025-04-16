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
  bool isGammaSatEnabled = true;
  bool isGammaDryEnabled = true;
  bool isGammaMoistEnabled = true;

  AnalRectMomentState({
    required this.title,
    this.inputNumberOne = '',
    this.inputNumberTwo = '',
    this.inputNumberThree = '',
    this.soilProp = false,
  });
}