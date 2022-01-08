
//ghi các thông tin của student trong file students.json
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quan_ly_diem/model/sv.dart';
import 'package:quan_ly_diem/services/file_services.dart';

class SVServices extends FileServices {
  final String fileName = 'students.json';

  Future<List<Student>> getListStudent() async {
    try {
      String data = await readData(fileName);
      List jsonData = json.decode(data);
      return jsonData.map<Student>((e) => Student.fromJson(e)).toList();
    } catch (error) {
      String studentData =
          await rootBundle.loadString('assets/sv_data.json');
      await writeData(fileName, studentData);
      List jsonData = json.decode(studentData);
      return jsonData.map<Student>((e) => Student.fromJson(e)).toList();
    }
  }

  Future<bool> addStudent(Student student) async {
    List<Student> listUser = await getListStudent();
    int index = listUser
        .indexWhere((element) => element.studentCode == student.studentCode);
    if (index != -1) {
      throw Exception('Sinh viên đã tồn tại');
    }
    listUser.insert(0, student);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> deleteStudent(String studentCode) async {
    List<Student> listUser = await getListStudent();
    int index = listUser
        .indexWhere((element) => element.studentCode == studentCode);
    if (index == -1) {
      throw Exception('Sinh viên không tồn tại');
    }
    listUser.removeAt(index);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> editStudent(Student student) async {
    List<Student> listUser = await getListStudent();
    int index = listUser
        .indexWhere((element) => element.studentCode == student.studentCode);
    if (index == -1) {
      throw Exception('Sinh viên không tồn tại');
    }
    listUser[index] = student;
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }
}
