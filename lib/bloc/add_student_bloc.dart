import 'dart:async';

import 'package:quan_ly_diem/bloc/base_bloc.dart';
import 'package:quan_ly_diem/model/sv.dart';
import 'package:quan_ly_diem/services/sv_services.dart';


class AddStudentBloC extends BaseBloC {
  static final AddStudentBloC _instance = AddStudentBloC._();
  AddStudentBloC._() {
    _svServices = SVServices();
  }

  static AddStudentBloC getInstance() {
    return _instance;
  }

  late SVServices _svServices;
  late Student _student;

  StreamController<bool> _saveButtonController =
      StreamController<bool>.broadcast();

  Stream<bool> get saveButtonState => _saveButtonController.stream;

  set studentCode(String value) {
    _student.studentCode = value.trim();
    _saveButtonController.sink.add(_student.isFullInformation());
  }

  set fullName(String value) {
    _student.fullName = value.trim();
    _saveButtonController.sink.add(_student.isFullInformation());
  }


  set course(String value) {
    _student.course = value.trim();
    _saveButtonController.sink.add(_student.isFullInformation());
  }

  set major(String value) {
    _student.major = value.trim();
    _saveButtonController.sink.add(_student.isFullInformation());
  }

  set classNumber(String value) {
    _student.classNumber = value.trim();
    _saveButtonController.sink.add(_student.isFullInformation());
  }

  Future<bool> addStudent() async {
    showLoading();
    bool result = await _svServices.addStudent(_student);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
    _saveButtonController.sink.add(false);
    _student = Student();
  }

  @override
  void dispose() {
    _saveButtonController.close();
    super.dispose();
  }
}
