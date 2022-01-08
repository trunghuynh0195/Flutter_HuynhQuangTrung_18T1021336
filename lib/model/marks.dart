class Marks {
  double? attendancePoints;
  double? testMarks1;
  double? testMarks2;
  double? finalExamMarks;

  Marks(this.attendancePoints, this.testMarks1, this.testMarks2,
      this.finalExamMarks);

  Marks.fromJson(Map<String, dynamic> json) {
    attendancePoints = json['attendancePoints'] != null
        ? json['attendancePoints'].toDouble()
        : 0.0;
    testMarks1 =
        json['testMarks1'] != null ? json['testMarks1'].toDouble() : 0.0;
    testMarks2 =
        json['testMarks2'] != null ? json['testMarks2'].toDouble() : 0.0;
    finalExamMarks = json['finalExamMarks'] != null
        ? json['finalExamMarks'].toDouble()
        : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendancePoints'] = this.attendancePoints;
    data['testMarks1'] = this.testMarks1;
    data['testMarks2'] = this.testMarks2;
    data['finalExamMarks'] = this.finalExamMarks;
    return data;
  }

  bool isValid() {
    return (attendancePoints! <= 10) &&
        (attendancePoints! >= 0) &&
        (testMarks1! <= 10) &&
        (testMarks1! >= 0) &&
        (testMarks2! <= 10) &&
        (testMarks2! >= 0) &&
        (finalExamMarks! <= 10) &&
        (finalExamMarks! >= 0);
  }

  double getGPA() {
    return (attendancePoints! * 0.1) +
        (testMarks1! * 0.15) +
        (testMarks2! * 0.15) +
        (finalExamMarks! * 0.6);
  }
}
