 /*
  String? selectedShearFailure;
  String? selectedFootingType;

  String depthOfFoundation = '';
  String waterTableDistance = '';
  String baseOfFoundation = '';
  */
  
class AnalysisState {
  final double df;
  final double dw;
  final double fDim;
  final double c;
  final double t;
  final double fs;
  final double nc;
  final double nq;
  final double ny;
  final double yw;
  final double yc;
  
  final double? gs;
  final double? w;
  final double? e;
  final double? s;
  final double? yDry;
  final double? y;
  final double? ySat;
  final double? theta;

  final String title;

  // Constructor
  AnalysisState({
    this.df = 0.0,
    this.dw = 0.0,
    this.fDim = 0.0,
    this.c = 0.0,
    this.t = 0.0,
    this.fs = 0.0,
    this.nc = 0.0,
    this.nq = 0.0,
    this.ny = 0.0,
    this.yw = 0.0,
    this.yc = 0.0,
    this.gs,
    this.w,
    this.e,
    this.s,
    this.yDry,
    this.y,
    this.ySat,
    this.theta,
    required this.title,
  });

  // CopyWith method for updating fields
  AnalysisState copyWith({
    double? df,
    double? dw,
    double? fDim,
    double? c,
    double? t,
    double? fs,
    double? nc,
    double? nq,
    double? ny,
    double? yw,
    double? yc,
    double? gs,
    double? w,
    double? e,
    double? s,
    double? yDry,
    double? y,
    double? ySat,
    double? theta,
    String? title,
  }) {
    return AnalysisState(
      df: df ?? this.df,
      dw: dw ?? this.dw,
      fDim: fDim ?? this.fDim,
      c: c ?? this.c,
      t: t ?? this.t,
      fs: fs ?? this.fs,
      nc: nc ?? this.nc,
      nq: nq ?? this.nq,
      ny: ny ?? this.ny,
      yw: yw ?? this.yw,
      yc: yc ?? this.yc,
      gs: gs ?? this.gs,
      w: w ?? this.w,
      e: e ?? this.e,
      s: s ?? this.s,
      yDry: yDry ?? this.yDry,
      y: y ?? this.y,
      ySat: ySat ?? this.ySat,
      theta: theta ?? this.theta,
      title: title ?? this.title,
    );
  }

  // Convert string input to double safely
  static double _parseDouble(String? value) {
    return double.tryParse(value ?? "") ?? 0.0;
  }
}

//Copy paste mo yan lahat then iadjust nalang kung magbabagong calc