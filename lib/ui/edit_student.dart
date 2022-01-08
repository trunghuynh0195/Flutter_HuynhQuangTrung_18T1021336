import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_diem/bloc/edit_student_bloc.dart';
import 'package:quan_ly_diem/bloc/list_sv_bloc.dart';
import 'package:quan_ly_diem/model/sv.dart';
import 'package:quan_ly_diem/util/textfeild_widget.dart';

class EditStudent extends StatefulWidget {
  final Student student;
  final List<Student> listStudent;
  final int index;

  const EditStudent({
    Key? key,
    required this.listStudent,
    required this.index,
    required this.student,
  }) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  TextEditingController _attendancePointsController = TextEditingController();
  TextEditingController _testMarks1Controller = TextEditingController();
  TextEditingController _testMarks2Controller = TextEditingController();
  TextEditingController _finalExamMarksController = TextEditingController();
  FocusNode _testMarks1Node = FocusNode();
  FocusNode _testMarks2Node = FocusNode();
  FocusNode _finalExamMarksNode = FocusNode();
  EditStudentBloC _editBloC = EditStudentBloC.getInstance();
  late Student student;

  @override
  void initState() {
    _editBloC.clearData();
    _editBloC.student = widget.student;
    student = widget.student;
    _attendancePointsController.text =
        '${student.marks?.attendancePoints ?? 0}';
    _testMarks1Controller.text = '${student.marks?.testMarks1 ?? 0}';
    _testMarks2Controller.text = '${student.marks?.testMarks2 ?? 0}';
    _finalExamMarksController.text = '${student.marks?.finalExamMarks ?? 0}';

    super.initState();
  }

  @override
  void dispose() {
    _attendancePointsController.dispose();
    _testMarks1Controller.dispose();
    _testMarks2Controller.dispose();
    _finalExamMarksController.dispose();
    _testMarks1Node.dispose();
    _testMarks2Node.dispose();
    _finalExamMarksNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: appBar(context),
          backgroundColor: Colors.grey[200],
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '''${widget.listStudent[widget.index].fullName}''',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Mã sinh viên: ${widget.listStudent[widget.index].studentCode}',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        "Khoá: ${widget.listStudent[widget.index].course} - ${widget.listStudent[widget.index].major}",
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _attendancePointsController,
                        labelText: 'Điểm chuyên cần',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) => _editBloC.attendancePoints =
                            doubleFromString(value),
                        onSubmitted: (value) {
                          _testMarks1Node.requestFocus();
                        },
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _testMarks1Controller,
                        focusNode: _testMarks1Node,
                        labelText: 'Kiểm tra 1',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) =>
                            _editBloC.testMarks1 = doubleFromString(value),
                        onSubmitted: (value) {
                          _testMarks2Node.requestFocus();
                        },
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _testMarks2Controller,
                        focusNode: _testMarks2Node,
                        labelText: 'Kiểm tra 2',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) =>
                            _editBloC.testMarks2 = doubleFromString(value),
                        onSubmitted: (value) {
                          _finalExamMarksNode.requestFocus();
                        },
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _finalExamMarksController,
                        focusNode: _finalExamMarksNode,
                        labelText: 'Thi học kỳ',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) =>
                            _editBloC.finalExamMarks = doubleFromString(value),
                        onSubmitted: (value) {},
                      ),
                      SizedBox(height: 18.0),
                    ],
                  ),
                ),
              ),
              _saveButton(context),
            ],
          ),
        ),
        _loadingState(context),
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: BackButton(),
      title: Text(
        'Cập nhật điểm sinh viên',
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledColor: Colors.grey,
        minWidth: double.infinity,
        height: 54,
        color: Colors.blue,
        onPressed: updateStudent,
        child: Text(
          'Cập nhật',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _editBloC.loadingState,
        builder: (_, snapshot) {
          bool isLoading = snapshot.data ?? false;
          if (isLoading) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox.shrink();
        });
  }

  void updateStudent() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _editBloC.updateStudent().then((success) {
      ListSVBloC.getInstance().getListStudent();
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Cập nhật');
        },
      ).then((value) => Navigator.pop(context));
    }).catchError((error) {
      _editBloC.hideLoading();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi cập nhật")));
    });
  }

  static doubleFromString(String value) {
    if (value.trim().isEmpty) {
      return 0.0;
    }
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  Widget succesfulMessageDialog(BuildContext context, {String content = ''}) {
    return CupertinoAlertDialog(
      title: Text('Thành công'),
      content: Text('$content thành công'),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Chấp nhận"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
