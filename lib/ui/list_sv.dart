import 'package:flutter/material.dart';
import 'package:quan_ly_diem/bloc/list_sv_bloc.dart';
import 'package:quan_ly_diem/model/list_model.dart';
import 'package:quan_ly_diem/model/sv.dart';
import 'package:quan_ly_diem/ui/add_student.dart';
import 'package:quan_ly_diem/ui/edit_student.dart';

class ListSV extends StatefulWidget {
  final int index;
  const ListSV({Key? key, required this.index}) : super(key: key);

  @override
  State<ListSV> createState() => _ListSVState();
}

class _ListSVState extends State<ListSV> {
  ListSVBloC _ListSVBloC = ListSVBloC.getInstance();
  late ListModel<Student> _list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 7),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddStudent(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ))),
        ],
        title: Text("Danh sách nhóm ${widget.index}"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return FutureBuilder<List<Student>>(
        future: _ListSVBloC.getListStudent(),
        builder: (context, snapshot) {
          return StreamBuilder<List<Student>>(
              stream: _ListSVBloC.listStudentStream,
              initialData: snapshot.data,
              builder: (context, snap) {
                var listStream = snap.data;
                return snap.hasData
                    ? ListView.builder(
                        itemCount: listStream!.length,
                        itemBuilder: (_, index) {
                          var studentEdit = snap.data!.elementAt(index);
                          var i = index + 1;
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '''$i. ${listStream[index].fullName}''',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mã sinh viên: ${listStream[index].studentCode}',
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "Khoá: ${listStream[index].course} - ${listStream[index].major}",
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "Điểm chuyên cần: ${listStream[index].marks?.attendancePoints ?? 0.0}",
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "Kiểm tra 1:  ${listStream[index].marks?.testMarks1 ?? 0.0}",
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "Kiểm tra 2:  ${listStream[index].marks?.testMarks2 ?? 0.0}",
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              'Thi học kỳ: ${listStream[index].marks?.finalExamMarks ?? 0.0}',
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              'Điểm trung bình: ${listStream[index].marks != null ? listStream[index].marks!.getGPA().toStringAsFixed(2) : 0.0}',
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                    color: Colors.blue,
                                                    shape: BoxShape.circle),
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.push<void>(
                                                      context,
                                                      MaterialPageRoute<void>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            EditStudent(
                                                          student: studentEdit,
                                                          index: index,
                                                          listStudent:
                                                              listStream,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 22,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle),
                                                child: IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return _showDialog(
                                                            context,
                                                            index,
                                                            listStream);
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 22,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              });
        });
  }

  Widget _showDialog(
      BuildContext context, int index, List<Student> listStream) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Bạn muốn xóa sinh viên này?"),
      actions: [
        TextButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            ListSVBloC.getInstance()
                .deleteStudent(listStream[index].studentCode.toString())
                .catchError((error) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Lỗi xóa")));
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
