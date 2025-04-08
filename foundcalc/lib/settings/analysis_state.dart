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

//Final answer, No erasures
    double? finalAnswerP;
    double? finalAnswerUdl;

//syempre, yun tab name hahaaha
  final String title;
  AnalysisState({required this.title});
}

//Copy paste mo yan lahat then iadjust nalang kung magbabagong calc