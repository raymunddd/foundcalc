class AnalysisResult {
  final double? yFinal;
  final double? yPrime;
  final double? q;
  final double? qUlt;
  final double? qAll;
  final double? qNetAll;
  final double? p;
  final double? udl;
  final double? nc;
  final double? nq;
  final double? ny;
  final double? af;
  final double? pf;
  final double? ps;
  final double? uD;
  final int? solutionType;

  AnalysisResult({
    this.yFinal,
    this.yPrime,
    this.q,
    this.qUlt,
    this.qAll,
    this.qNetAll,
    this.p,
    this.udl,
    this.nc,
    this.nq,
    this.ny,
    this.af,
    this.pf,
    this.ps,
    this.uD,
    this.solutionType,
  });

  /* Helper method for convenient creation from a map
  factory AnalysisResult.fromMap(Map<String, dynamic> map) {
    return AnalysisResult(
      yFinal: map['yFinal'],
      yPrime: map['yPrime'],
      q: map['q'],
      qUlt: map['qUlt'],
      qAll: map['qAll'],
      qNetAll: map['qNetAll'],
      p: map['p'],
      udl: map['udl'],
      nc: map['nc'],
      nq: map['nq'],
      ny: map['ny'],
      af: map['af'],
      pf: map['pf'],
      ps: map['ps'],
      uD: map['uD'],
      solutionType: map['sol']?.toInt(),
    );
  }*/
}