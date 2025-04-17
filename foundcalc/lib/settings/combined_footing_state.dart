class CombinedFootingState {

  // Dropdowns
  String? barDia;
  String? side;

  // TextFields
  String inputLength_a = '';
  String inputLength_b = '';
  String inputLength_c = '';
  String inputLength_e = '';
  String inputLength_H = '';

  String inputDepth = '';

  String inputShear_f = '';
  String inputShear_g = '';
  String inputShear_h = '';
  String inputShear_i = '';

  String inputFactorShear = '';
  String inputFactorMoment = '';

  String inputOtherDia = '';

  String inputDf = '';
  String inputDw = '';
  String inputGammaDry = '';
  String inputGammaMoist = '';

  final String title;

  bool scrollToTop = false;

  bool qToggle = true;
  bool pToggle = true;
  bool topToggle = false;
  bool botToggle = false;
  bool soilProp = true;
  bool weightPressures = false;
  bool ccToggle = false;
  bool concreteToggle = false;
  bool waterToggle = false;
  bool concreteDet = false;
  bool waterDet = false;
  bool otherMat = false;
  bool concreteCover = false;

  bool isGammaSatEnabled = true;
  bool isGammaDryEnabled = true;
  bool isGammaMoistEnabled = true;

  bool showResults = false;
  bool solutionToggle = true;
  bool showSolution = false;

  // Final answer, No erasures
    double? finalAnswerB;
    double? finalAnswerT;
    double? finalAnswerD;
    double? finalAnswerVuows;
    double? finalAnswerVucows;
    double? finalAnswerVutws;
    double? finalAnswerVuctws;

  CombinedFootingState({required this.title});
}