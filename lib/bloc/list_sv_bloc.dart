import 'dart:async';

import 'package:quan_ly_diem/bloc/base_bloc.dart';
import 'package:quan_ly_diem/model/sv.dart';
import 'package:quan_ly_diem/services/sv_services.dart';

class ListSVBloC extends BaseBloC {
  static final ListSVBloC _instance = ListSVBloC._();
  ListSVBloC._() {
    _svServices = SVServices();
  }

  static ListSVBloC getInstance() {
    return _instance;
  }

  late SVServices _svServices;

  StreamController<List<Student>> _listStudentsController =
      StreamController<List<Student>>.broadcast();

  Stream<List<Student>> get listStudentStream => _listStudentsController.stream;

  Future<List<Student>> getListStudent() async {
    List<Student> list = await _svServices.getListStudent();
    _listStudentsController.sink.add(list);
    return list;
  }

  Future<bool> deleteStudent(String studentCode) async {
    bool deleteSuccess = await _svServices.deleteStudent(studentCode);
    await getListStudent();
    return deleteSuccess;
  }
 @override
  void clearData() {}

  @override
  void dispose() {
    super.dispose();

    _listStudentsController.close();
  }
 
 
}
