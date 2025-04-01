import 'analysis_shear.dart';
import 'analysis_results.dart';
import 'dart:math';

class CalculationService {
  double roundToFourDecimalPlaces(double value) {
    return (value * 10000).round() / 10000;
  }
  
  void getShearValues(double theta, String shearType, 
      {required Function(double?, double?, double?) onValuesFound}) {
    Map<String, dynamic>? values = ShearTerzaghi.getShearValues(theta, shearType);
    if (values != null) {
      onValuesFound(
        values['nc'].toDouble(), 
        values['nq'].toDouble(), 
        values['ny'].toDouble()
      );
    } else {
      onValuesFound(null, null, null);
    }
  }


  Future<AnalysisResult> calculateP({
    required String? selectedShearFailure,
    required String? selectedFootingType,
    required double? df,
    required double? dw,
    required double? c,
    required double? fDim,
    required double? t,
    required double? fs,
    // Soil properties
    required double? gs,
    required double? e,
    required double? w,
    required double? yDry,
    required double? y,
    required double? ySat,
    // Angle factors
    required double? theta,
    required double? nc,
    required double? nq,
    required double? ny,
    // Water and concrete
    required double? yw,
    required double? yc,
    // State toggles
    required bool soilProp,
    required bool angleDet,
  }) async {
    // Declare calculation variables
    double? yFinal;
    double? yPrime;
    double? hw;
    double? uD;
    double? dfPlusB;
    double? q;
    double? qUlt;
    double? qAll;
    double? qNetAll;
    double? qNet;
    double? af;
    double? a;
    double? b;
    double? pf;
    double? ps;
    double? p;
    double? udl;
    int? sol;
    double? calculatedNc;
    double? calculatedNq;
    double? calculatedNy;

    // Complete calculation logic
    if (soilProp == true) { //if soilProp is on
      if (dw != null) {
        hw = df! - dw!;
        uD = hw! * yw!;
        if (dw! >= df!) {
          if (gs != null && e!= null && w != null) {
            y = (gs!*yw!*(1+(0.01*w!)))/(1+e!); // final y = y
            yDry = null;
            ySat = null;
            yFinal = y;
          } else if (gs != null && e != null) {
            yFinal = (gs!*yw!)/(1+e!);
            yDry = yFinal;
          } else {
            yFinal = null;
          }
        } else { // Dw < Df
          if (gs != null && e!= null && w != null) {
            ySat = (gs!*yw!*(1+(0.01*w!)))/(1+e!);
            yFinal = ySat;
          } else if (e != null && w != null) { // e, w
            yFinal = ySat;
          } else { 
            yFinal = null;
          }
        }
      } else { // no Dw
        if (gs != null && e!= null && w != null) {
          yFinal = (gs!*yw!*(1+(0.01*w!)))/(1+e!); // final y = y
        } else if (gs != null && e != null) {
          yFinal = (gs!*yw!)/(1+e!);
        } else {
          yFinal = null;
        }
      }
    } else { // if soilProp is off
      if (dw != null) {
        hw = df! - dw!;
        uD = hw!*yw!;
        if (dw! != 0) {
          if (dw! >= df!) {
            if (yDry != null) {
              yFinal = yDry;
            } else if (y != null) {
              yFinal = y;
            } else {
              yFinal = null;
            }
          } else { // Dw < Df
            if (ySat != null) {
              yFinal = ySat;
            } else {
              yFinal = null;
            }
          }
        } else { // Dw == 0
          if (ySat != null) {
            yFinal = ySat!;
          } else if (yDry != null) {
            yFinal = yDry;
          } else if (y != null) {
            yFinal = y;
          } else {
            yFinal = null;
          }
        }
      } else { // Dw is null
        if (yDry != null && y != null) {
          yFinal = null;
        } else if (yDry != null) {
          yFinal = yDry!;
        } else if (y != null) {
          yFinal = y!;
        } else {
          yFinal = null;
        }
      }
    }

    dfPlusB = df! + fDim!;

    if (yFinal != null && yw != null && df != null && fDim != null) {
      if (dw != null) { // Dw is given
        if (dw! <= df!) { // Case 1 for y' and q
          yPrime = yFinal! - yw!;
          q = yFinal!*df! + yPrime!*hw!;
        } else if (dw! >= dfPlusB!) { // Case 3 for y' and q
          yPrime = yFinal!;
          q = yFinal!*df!;
        } else { // Case 2 for y' and q
          yPrime = yFinal! - yw!*(1 - ((dw! - df!)/fDim!));
          q = yFinal!*df!; 
        }
      } else { // no Dw
        yPrime = yFinal!;
        q = yFinal!*df!;
      }         
    } else {
      yPrime = null;
      q = null;
    }

    // Process bearing capacity factors
    if (angleDet == true) {
      if (theta != null) {
        if (theta! >= 0 && theta! <= 50) {
          Map<String, dynamic>? values = ShearTerzaghi.getShearValues(theta!, selectedShearFailure ?? 'General');
          if (values != null) {
            calculatedNc = values['nc'].toDouble();
            calculatedNq = values['nq'].toDouble();
            calculatedNy = values['ny'].toDouble();
            
            if (selectedShearFailure == 'General') {
              if (q != null && yPrime != null && c != null) {
                qUlt = c!*calculatedNc! + q!*calculatedNq! + 0.5*yPrime!*fDim!*calculatedNy!;
              } else {
                qUlt = null;
              }
            } else { // local shear
              if (q != null && yPrime != null && c != null) {
                qUlt = (2/3)*c!*calculatedNc! + q!*calculatedNq! + 0.5*yPrime!*fDim!*calculatedNy!;
              } else {
                qUlt = null;
              }
            }
          } else {
            qUlt = null;
          }
        } else {
          qUlt = null;
        }
      } else { // no theta
        qUlt = null;
      }
    } else { // Nc, Nq, Ny are given (angleDet = false)
      if (nc != null && nq != null && ny != null) {
        calculatedNc = nc;
        calculatedNq = nq;
        calculatedNy = ny;
        
        if (selectedShearFailure == 'General') {
          if (q != null && yPrime != null && c != null) {
            qUlt = c!*nc! + q!*nq! + 0.5*yPrime!*fDim!*ny!;
          } else {
            qUlt = null;
          }
        } else { // local shear
          if (q != null && yPrime != null && c != null) {
            qUlt = (2/3)*c!*nc! + q!*nq! + 0.5*yPrime!*fDim!*ny!;
          } else {
            qUlt = null;
          }
        }
      } else { // no Nc, Nq and Ny
        qUlt = null;
      }
    }

    // Calculate area factor based on footing type
    if (selectedFootingType == 'Square') {
      af = fDim!*fDim!;
    } else if (selectedFootingType == 'Circular') {
      af = 0.25*pi*fDim!*fDim!;
    } else { // Strip or continuous
      af = null; // No area for strip footing
    }

    if (qUlt != null && q != null) {
      qAll = qUlt!/fs!;
      qNetAll = (qUlt! - q!)/fs!;
      qNet = qNetAll!*fs!;
    }

    if (q != null && qAll != null) {
      if (t != null && hw != null) {
        a = df! - hw!;
        b = df! - t! - a!;
        if (af != null) { // square/circular
          sol = 1; // with t, square/circular
          pf = yc!*af!*t!;
          
          if (b! >= 0) {
            if (y != null && yDry == null) {
              ps = y!*af!*b!;
            } else { // if no y and there's yDry
              ps = yDry!*af!*b!;
            }
          } else {
            ps = 0;
          }
          
          p = (af!*(qAll!+yw!*hw!)) - pf! - ps!;              
          p = roundToFourDecimalPlaces(p!);
          udl = 0;
        } else { // strip
          sol = 2; // with t, strip
          pf = yc!*fDim!*t!;
          
          if (b! >= 0) {
            if (y != null && yDry == null) {
              ps = y!*fDim!*b!;
            } else { // if no y and there's yDry
              ps = yDry!*fDim!*b!;
            }
          } else {
            ps = 0;
          }
          
          p = 0;
          udl = (fDim!*(qAll!+yw!*hw!)) - pf! - ps!;
          udl = roundToFourDecimalPlaces(udl!);
        }
      } else { // if no t
        if (af != null) { // square/circular
          sol = 3; // no t, square/circular
          p = qAll!*af!;
          p = roundToFourDecimalPlaces(p!);
          udl = 0;
        } else { // strip
          sol = 4; // no t, strip
          p = 0;
          udl = qAll!*fDim!;
          udl = roundToFourDecimalPlaces(udl!);
        }
      }
    }

    // Return the result object
    return AnalysisResult(
      yFinal: yFinal,
      yPrime: yPrime,
      q: q,
      qUlt: qUlt,
      qAll: qAll,
      qNetAll: qNetAll,
      p: p,
      udl: udl,
      nc: calculatedNc ?? nc,
      nq: calculatedNq ?? nq,
      ny: calculatedNy ?? ny,
      af: af,
      pf: pf,
      ps: ps,
      uD: uD,
      solutionType: sol?.toInt(),
    );
  }
}