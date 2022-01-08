
import 'package:quan_ly_diem/model/marks.dart';

class Student {
  String? studentCode;
  String? fullName;
  String? course;
  String? major;
  String? classNumber;
  Marks? marks;

  Student(
      {this.studentCode,
      this.fullName,
      this.course,
      this.major,
      this.classNumber,
      this.marks});

  Student.fromJson(Map<String, dynamic> json) {
    studentCode = json['studentCode'];
    fullName = json['fullName'];
    course = json['course'];
    major = json['major'];
    classNumber = json['classNumber'];
    if (json["marks"] != null) {
      marks = Marks.fromJson(json["marks"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentCode'] = this.studentCode;
    data['fullName'] = this.fullName;
    data['course'] = this.course;
    data['major'] = this.major;
    data['classNumber'] = this.classNumber;
    if (this.marks != null) {
      data["marks"] = this.marks!.toJson();
    }
    return data;
  }

  bool isFullInformation() {
    if (studentCode == null ||
        fullName == null ||
        course == null ||
        major == null ||
        classNumber == null) {
      return false;
    }
    return studentCode!.isNotEmpty &&
        fullName!.isNotEmpty &&
        course!.isNotEmpty &&
        major!.isNotEmpty &&
        classNumber!.isNotEmpty;
  }
}
