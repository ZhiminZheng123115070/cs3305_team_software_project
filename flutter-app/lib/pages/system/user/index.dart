import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';

class UserIndex extends StatefulWidget {
  const UserIndex({Key? key}) : super(key: key);

  @override
  State<UserIndex> createState() => _UserIndexState();
}

class _UserIndexState extends State<UserIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User Management"),
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: 1,
              sortAscending: true,
              dataRowHeight: 30,
              horizontalMargin: 5,
              columnSpacing: 10,
              dividerThickness: 1.0,
              columns: const [
                DataColumn(label: Text('User ID')),
                DataColumn(
                  label: Text('Username'),
                ),
                DataColumn(label: Text('Nickname')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Create Time')),
                DataColumn(label: Text('Action')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('admin')),
                  DataCell(Text('RuoYi')),
                  DataCell(Text('R&D Department')),
                  DataCell(Text('13888888888')),
                  DataCell(Text('Normal')),
                  DataCell(Text('2022-08-02 15:39:45')),
                  DataCell(Text('---')),
                ]),
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('ry')),
                  DataCell(Text('RuoYi')),
                  DataCell(Text('Test')),
                  DataCell(Text('13888888888')),
                  DataCell(Text('Normal')),
                  DataCell(Text('2022-08-02 15:39:45')),
                  DataCell(Text('---')),
                ]),
              ],
            ),
          ),
        ),
        drawer: Container(
          color: Colors.white,
          width: 260,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: ClipOval(
                      child: Image.asset("static/images/profile.jpg"),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              TreeView(nodes: [
                TreeNode(
                  content: Text("RuoYi Technology"),
                  children: [
                    TreeNode(content: Text("Shenzhen Headquarters"), children: [
                      TreeNode(content: Text("R&D Department")),
                      TreeNode(content: Text("Marketing Department")),
                      TreeNode(content: Text("Testing Department")),
                      TreeNode(content: Text("Finance Department")),
                      TreeNode(content: Text("Operations Department")),
                    ]),
                    TreeNode(content: Text("Changsha Branch"), children: [
                      TreeNode(content: Text("Marketing Department")),
                      TreeNode(content: Text("Finance Department")),
                    ]),
                  ],
                ),
              ]),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Back"),
        ));
  }
}
