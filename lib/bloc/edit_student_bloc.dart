
import 'package:quan_ly_diem/bloc/base_bloc.dart';
import 'package:quan_ly_diem/model/marks.dart';
import 'package:quan_ly_diem/model/sv.dart';
import 'package:quan_ly_diem/services/sv_services.dart';

class EditStudentBloC extends BaseBloC {
  static final EditStudentBloC _instance = EditStudentBloC._();
  EditStudentBloC._() {
    _studentServices = SVServices();
  }

  static EditStudentBloC getInstance() {
    return _instance;
  }

  late SVServices _studentServices;
  late Student _student;
  late Marks _marks;

  set student(Student value) {
    _student = value;
    _marks = _student.marks ?? Marks(0.0, 0.0, 0.0, 0.0);
  }

  set attendancePoints(double value) => _marks.attendancePoints = value;
  set testMarks1(double value) => _marks.testMarks1 = value;
  set testMarks2(double value) => _marks.testMarks2 = value;
  set finalExamMarks(double value) => _marks.finalExamMarks = value;

  Future<bool> updateStudent() async {
    if (!_marks.isValid()) {
      throw Exception('Điểm số sai định dạng.');
    }

    showLoading();
    _student.marks = _marks;
    bool result = await _studentServices.editStudent(_student);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
