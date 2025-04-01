class ShearTerzaghi {
  // General shear failure table. ctto Terzaghi
  static final List<Map<String, dynamic>> generalShear = [
    {"theta": 0, "nc": 5.7, "nq": 1, "ny": 0},
    {"theta": 1, "nc": 6, "nq": 1.1, "ny": 0.01},
    {"theta": 2, "nc": 6.3, "nq": 1.22, "ny": 0.04},
    {"theta": 3, "nc": 6.62, "nq": 1.35, "ny": 0.06},
    {"theta": 4, "nc": 6.97, "nq": 1.49, "ny": 0.1},
    {"theta": 5, "nc": 7.34, "nq": 1.64, "ny": 0.14},
    {"theta": 6, "nc": 7.73, "nq": 1.81, "ny": 0.2},
    {"theta": 7, "nc": 8.15, "nq": 2, "ny": 0.27},
    {"theta": 8, "nc": 8.6, "nq": 2.21, "ny": 0.35},
    {"theta": 9, "nc": 9.09, "nq": 2.44, "ny": 0.44},
    {"theta": 10, "nc": 9.61, "nq": 2.69, "ny": 0.56},
    {"theta": 11, "nc": 10.16, "nq": 2.98, "ny": 0.69},
    {"theta": 12, "nc": 10.76, "nq": 3.29, "ny": 0.85},
    {"theta": 13, "nc": 11.41, "nq": 3.63, "ny": 1.04},
    {"theta": 14, "nc": 12.11, "nq": 4.02, "ny": 1.26},
    {"theta": 15, "nc": 12.86, "nq": 4.45, "ny": 1.52},
    {"theta": 16, "nc": 13.68, "nq": 4.92, "ny": 1.82},
    {"theta": 17, "nc": 14.6, "nq": 5.45, "ny": 2.18},
    {"theta": 18, "nc": 15.12, "nq": 6.04, "ny": 2.59},
    {"theta": 19, "nc": 16.56, "nq": 6.7, "ny": 3.07},
    {"theta": 20, "nc": 17.69, "nq": 7.44, "ny": 3.64},
    {"theta": 21, "nc": 18.92, "nq": 8.26, "ny": 4.31},
    {"theta": 22, "nc": 20.27, "nq": 9.19, "ny": 5.09},
    {"theta": 23, "nc": 21.75, "nq": 10.23, "ny": 6},
    {"theta": 24, "nc": 23.36, "nq": 11.4, "ny": 7.08},
    {"theta": 25, "nc": 25.13, "nq": 12.72, "ny": 8.34},
    {"theta": 26, "nc": 27.09, "nq": 14.21, "ny": 9.84},
    {"theta": 27, "nc": 29.24, "nq": 16.9, "ny": 11.6},
    {"theta": 28, "nc": 31.61, "nq": 17.81, "ny": 13.7},
    {"theta": 29, "nc": 34.24, "nq": 19.98, "ny": 16.18},
    {"theta": 30, "nc": 37.16, "nq": 22.46, "ny": 19.13},
    {"theta": 31, "nc": 40.41, "nq": 25.28, "ny": 22.65},
    {"theta": 32, "nc": 44.04, "nq": 28.52, "ny": 26.87},
    {"theta": 33, "nc": 48.09, "nq": 32.23, "ny": 31.94},
    {"theta": 34, "nc": 52.64, "nq": 36.5, "ny": 38.04},
    {"theta": 35, "nc": 57.75, "nq": 41.44, "ny": 45.41},
    {"theta": 36, "nc": 63.53, "nq": 47.16, "ny": 54.36},
    {"theta": 37, "nc": 70.01, "nq": 53.8, "ny": 65.27},
    {"theta": 38, "nc": 77.5, "nq": 61.55, "ny": 78.61},
    {"theta": 39, "nc": 85.97, "nq": 70.61, "ny": 95.03},
    {"theta": 40, "nc": 95.66, "nq": 81.27, "ny": 116.31},
    {"theta": 41, "nc": 106.81, "nq": 93.85, "ny": 140.51},
    {"theta": 42, "nc": 119.67, "nq": 108.75, "ny": 171.99},
    {"theta": 43, "nc": 134.58, "nq": 126.5, "ny": 211.56},
    {"theta": 44, "nc": 161.95, "nq": 147.74, "ny": 261.6},
    {"theta": 45, "nc": 172.28, "nq": 173.28, "ny": 325.34},
    {"theta": 46, "nc": 196.22, "nq": 204.19, "ny": 407.11},
    {"theta": 47, "nc": 224.55, "nq": 241.8, "ny": 512.84},
    {"theta": 48, "nc": 258.28, "nq": 287.85, "ny": 650.67},
    {"theta": 49, "nc": 298.71, "nq": 344.63, "ny": 831.99},
    {"theta": 50, "nc": 347.5, "nq": 416.14, "ny": 1072.8}
  ];

  // Local shear table
  static final List<Map<String, dynamic>> localShear = [
    {"theta": 0, "nc": 5.14, "nq": 1, "ny": 0},
    {"theta": 1, "nc": 5.38, "nq": 1.09, "ny": 0.07},
    {"theta": 2, "nc": 5.63, "nq": 1.2, "ny": 0.15},
    {"theta": 3, "nc": 5.9, "nq": 1.31, "ny": 0.24},
    {"theta": 4, "nc": 6.19, "nq": 1.43, "ny": 0.34},
    {"theta": 5, "nc": 6.49, "nq": 1.57, "ny": 0.45},
    {"theta": 6, "nc": 6.81, "nq": 1.72, "ny": 0.57},
    {"theta": 7, "nc": 7.16, "nq": 1.88, "ny": 0.71},
    {"theta": 8, "nc": 7.53, "nq": 2.06, "ny": 0.86},
    {"theta": 9, "nc": 7.92, "nq": 2.25, "ny": 1.03},
    {"theta": 10, "nc": 8.35, "nq": 2.47, "ny": 1.22},
    {"theta": 11, "nc": 8.8, "nq": 2.71, "ny": 1.44},
    {"theta": 12, "nc": 9.28, "nq": 2.97, "ny": 1.69},
    {"theta": 13, "nc": 9.81, "nq": 3.26, "ny": 1.97},
    {"theta": 14, "nc": 10.37, "nq": 3.59, "ny": 2.29},
    {"theta": 15, "nc": 10.98, "nq": 3.94, "ny": 2.65},
    {"theta": 16, "nc": 11.63, "nq": 4.34, "ny": 3.06},
    {"theta": 17, "nc": 12.34, "nq": 4.77, "ny": 3.53},
    {"theta": 18, "nc": 13.1, "nq": 5.26, "ny": 4.07},
    {"theta": 19, "nc": 13.93, "nq": 5.8, "ny": 4.68},
    {"theta": 20, "nc": 14.83, "nq": 6.4, "ny": 5.39},
    {"theta": 21, "nc": 15.82, "nq": 7.07, "ny": 6.2},
    {"theta": 22, "nc": 16.88, "nq": 7.82, "ny": 7.13},
    {"theta": 23, "nc": 18.05, "nq": 8.66, "ny": 8.2},
    {"theta": 24, "nc": 19.32, "nq": 9.6, "ny": 9.44},
    {"theta": 25, "nc": 20.72, "nq": 10.66, "ny": 10.88},
    {"theta": 26, "nc": 22.25, "nq": 11.85, "ny": 12.54},
    {"theta": 27, "nc": 23.94, "nq": 13.2, "ny": 14.47},
    {"theta": 28, "nc": 25.8, "nq": 14.72, "ny": 16.72},
    {"theta": 29, "nc": 27.86, "nq": 16.44, "ny": 19.34},
    {"theta": 30, "nc": 30.14, "nq": 18.4, "ny": 22.4},
    {"theta": 31, "nc": 32.67, "nq": 20.63, "ny": 25.99},
    {"theta": 32, "nc": 35.49, "nq": 23.18, "ny": 30.22},
    {"theta": 33, "nc": 38.64, "nq": 26.09, "ny": 35.19},
    {"theta": 34, "nc": 42.16, "nq": 29.44, "ny": 41.06},
    {"theta": 35, "nc": 46.12, "nq": 33.3, "ny": 48.03},
    {"theta": 36, "nc": 50.59, "nq": 37.75, "ny": 56.31},
    {"theta": 37, "nc": 55.63, "nq": 42.92, "ny": 66.19},
    {"theta": 38, "nc": 61.35, "nq": 48.93, "ny": 78.03},
    {"theta": 39, "nc": 67.87, "nq": 55.96, "ny": 92.25},
    {"theta": 40, "nc": 75.31, "nq": 64.2, "ny": 109.41},
    {"theta": 41, "nc": 83.86, "nq": 73.9, "ny": 130.22},
    {"theta": 42, "nc": 93.71, "nq": 85.38, "ny": 155.55},
    {"theta": 43, "nc": 105.11, "nq": 99.02, "ny": 186.54},
    {"theta": 44, "nc": 118.37, "nq": 115.31, "ny": 224.64},
    {"theta": 45, "nc": 133.88, "nq": 134.88, "ny": 271.76},
    {"theta": 46, "nc": 152.1, "nq": 158.51, "ny": 330.35},
    {"theta": 47, "nc": 173.64, "nq": 187.21, "ny": 403.67},
    {"theta": 48, "nc": 199.26, "nq": 222.31, "ny": 496.01},
    {"theta": 49, "nc": 229.93, "nq": 265.51, "ny": 613.16},
    {"theta": 50, "nc": 266.89, "nq": 319.07, "ny": 762.89},
  ];

  /*Function to get shear values based on theta and shear type
  Returns a map with nc, nq, and ny values
  If no values are found, returns null*/

  static Map<String, dynamic>? getShearValues(double theta, String shearType) {
    List<Map<String, dynamic>> shearList =
        shearType == 'General' ? generalShear : localShear;

    for (var entry in shearList) {
      if (entry['theta'] == theta) {
        return entry;
      }
    }
    return null;
  }
}
