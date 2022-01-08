import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_diem/bloc/add_student_bloc.dart';
import 'package:quan_ly_diem/bloc/list_sv_bloc.dart';
import 'package:quan_ly_diem/util/textfeild_widget.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController _studentCodeController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _courseController = TextEditingController();
  TextEditingController _majorController = TextEditingController();
  TextEditingController _classNumberController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  FocusNode _studentCodeNode = FocusNode();
  FocusNode _courseNode = FocusNode();
  FocusNode _majorNode = FocusNode();
  FocusNode _classNumberNode = FocusNode();
  late AddStudentBloC _addStudentBloC;

  @override
  void initState() {
    _addStudentBloC = AddStudentBloC.getInstance();
    _addStudentBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _studentCodeController.dispose();
    _fullNameController.dispose();
    _courseController.dispose();
    _majorController.dispose();
    _classNumberController.dispose();
    _dobController.dispose();
    _studentCodeNode.dispose();
    _courseNode.dispose();
    _majorNode.dispose();
    _classNumberNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _appBar(context),
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
                      textField(
                        context,
                        controller: _fullNameController,
                        labelText: 'Họ và tên',
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 60,
                        onChanged: (value) => _addStudentBloC.fullName = value,
                        onSubmitted: (value) {
                          _studentCodeNode.requestFocus();
                        },
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _studentCodeController,
                        focusNode: _studentCodeNode,
                        labelText: 'Mã sinh viên',
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 15,
                        onChanged: (value) =>
                            _addStudentBloC.studentCode = value,
                        onSubmitted: (value) {
                          _courseNode.requestFocus();
                        },
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _courseController,
                        focusNode: _courseNode,
                        labelText: 'Khoá',
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 6,
                        onChanged: (value) => _addStudentBloC.course = value,
                        onSubmitted: (value) {
                          _majorNode.requestFocus();
                        },
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _majorController,
                        focusNode: _majorNode,
                        labelText: 'Chuyên ngành',
                        textCapitalization: TextCapitalization.words,
                        maxLength: 50,
                        onChanged: (value) => _addStudentBloC.major = value,
                        onSubmitted: (value) {
                          _classNumberNode.requestFocus();
                        },
                      ),
                      SizedBox(height: 18.0),
                      textField(
                        context,
                        controller: _classNumberController,
                        focusNode: _classNumberNode,
                        labelText: 'Nhóm lớp',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) =>
                            _addStudentBloC.classNumber = value,
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: BackButton(),
      title: Text(
        'Thêm sinh viên',
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: StreamBuilder<bool>(
          stream: _addStudentBloC.saveButtonState,
          builder: (_, snapshot) {
            bool isEnable = snapshot.data ?? false;
            return MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledColor: Colors.grey,
              minWidth: double.infinity,
              height: 54,
              color: Colors.blue,
              onPressed: isEnable ? addStudent : null,
              child: Text(
                'Thêm',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              padding: EdgeInsets.all(0),
            );
          }),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _addStudentBloC.loadingState,
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

  void addStudent() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _addStudentBloC.addStudent().then((sucess) {
      ListSVBloC.getInstance().getListStudent();
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Thêm sinh viên');
        },
      ).then((_) {
        Navigator.pop(context);
      });
    }).catchError((error) {
      _addStudentBloC.hideLoading();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi thêm")));
    });
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
