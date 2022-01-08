import 'package:flutter/material.dart';
import 'package:quan_ly_diem/ui/list_sv.dart';

class ClassGroup extends StatelessWidget {
  const ClassGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Nhóm học phần"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (_, index) {
            index = index + 1;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ListSV(
                      index: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: index % 2 != 0 ? Colors.blue[100] : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text("Nhóm $index"),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
