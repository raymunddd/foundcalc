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

  String inputFc = '';
  String inputFy = '';

  final String title;

  bool scrollToTop = false;
 
  bool factorShearToggle = false;
  bool factorMomentToggle = false;

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