import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:quan_ly_diem/model/subject.dart';
import 'package:quan_ly_diem/ui/class_group.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text("Danh sách lớp học phần"),
    );
  }

  Widget _body() {
    return Container(
      child: ListView.builder(
        itemCount: dataSubject.length,
        itemBuilder: (_, index) {
          var i = index + 1;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ClassGroup(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Container(
                       decoration: BoxDecoration(
                      // color: i % 2 != 0 ? Colors.grey[200] : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(i.toString(), style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Lớp học phần: ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: "${dataSubject[index].name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ],
                            ),
                          ),
                          Text("Số TC: ${dataSubject[index].soTC}"),
                          Text("Mã học phần: ${dataSubject[index].code}"),
                          Text("Ngày bắt đầu: ${dataSubject[index].timeStart}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
