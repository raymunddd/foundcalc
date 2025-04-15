class AnalysisState {
//MGA DROPDOWN
  String? selectedShearFailure;
  String? selectedFootingType;

//NUMBER INPUTS
      String inputDepthFoundation = '';
      String inputDepthWater = '';
      String inputFootingBase = '';
      String inputCohesion = '';
      String inputFootingThickness = '';
      String inputFactorSafety = '';

    //Soil Properties
      String inputSpecificGravity = '';
      String inputWaterContent = '';
      String inputVoidRatio = '';
    //Unit Weights
      String inputGammaDry = '';
      String inputGammaMoist = '';
      String inputGammaSat = '';
      
    //Angle of Internal Friction
      String inputAngleFriction = '';
      String inputFactCohesion = '';
      String inputFactOverburden = '';
      String inputFactUnitWeight = '';

      String inputUnitWeightWater = '';
      String inputUnitWeightConcrete = '';


//TOGGLES
    bool soilProp = true;
    bool angleDet = true;
    bool waterDet = false;
    bool concreteDet = false;

    bool isGammaSatEnabled = true;
    bool isGammaDryEnabled = true;
    bool isGammaMoistEnabled = true;
    bool showResults = false;
    bool scrollToTop = false;
    bool solutionToggle = true;
    bool showSolution = false;
    bool isItStrip = true;

//Final answer, No erasures
    double? finalAnswerP;
    double? finalAnswerUdl;

// Tab name
  final String title;
  AnalysisState({required this.title});
}
