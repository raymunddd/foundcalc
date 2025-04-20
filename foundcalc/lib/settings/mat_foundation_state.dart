class MatFoundationState {
  // scrollbar
  bool scrollToTop = false;
  // dropdowns

  // String? calculation;
  
  // inputs
  String inputCu = '';
  String inputB = '';
  String inputL = '';
  String inputDf = '';
  String inputTheta = '';
  
  String inputQ = '';
  String inputGamma = '';
    // final answer
    double? qnetu;
    double? fs;

  // toggles
  bool toggleCalc = false;
  bool isItFs = false;
  bool showResults = false;
  bool showSolution = false;
  bool solutionToggle = true;

  final String title;
  MatFoundationState({required this.title});
}