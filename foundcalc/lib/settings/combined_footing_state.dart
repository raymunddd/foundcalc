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
  bool steelToggle = false;

  bool showResultsPunchWide = false;
  bool solutionTogglePunchWide = true;
  bool showSolutionPunchWide = false;

  bool showResultsSteel = false;
  bool solutionToggleSteel = true;
  bool showSolutionSteel = false;

  // Final answer, No erasures
    double? VPA;
    double? VPB;
    double? Vp;
    double? VWA;
    double? VWB;
    double? Vw;
    double? n;
    double? roundedn;

  CombinedFootingState({required this.title});
}