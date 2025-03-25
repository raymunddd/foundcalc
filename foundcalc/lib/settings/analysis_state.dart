class AnalysisState {
//MGA DROPDOWN
  String? selectedShearFailure;
  String? selectedFootingType;

//NUMBER INPUTS
      String df = '';
      String dw = '';
      String fDim = '';
      String c = '';
      String t = '';
      String fs = '';

    //Soil Properties
      String gs = '';
      String w = '';
      String e = '';
      String s = '';
    //Unit Weights
      String yDry = '';
      String y = '';
      String ySat = '';
      
    //Angle of Internal Friction
      String theta = '';
      String nc = '';
      String nq = '';
      String ny = '';

      String yw = '';
      String yc = '';

//TOGGLES
    bool soilProp = true;
    bool angleDet = true;
    bool waterDet = false;
    bool concreteDet = false;

//syempre, yun tab name hahaaha
  final String title;
  AnalysisState({required this.title});
}

//Copy paste mo yan lahat then iadjust nalang kung magbabagong calc