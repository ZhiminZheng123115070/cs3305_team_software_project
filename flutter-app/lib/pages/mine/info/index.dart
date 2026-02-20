import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoIndex extends StatefulWidget {
  const InfoIndex({Key? key}) : super(key: key);

  @override
  State<InfoIndex> createState() => _InfoIndexState();
}

class _InfoIndexState extends State<InfoIndex> {
  @override
  Widget build(BuildContext context) {
    final details = Get.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent, // Set background color to transparent
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
              )),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Nickname"),
                trailing: Text(details["args"]["data"]["nickName"] ?? ""),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
              )),
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Phone Number"),
                trailing: Text(details["args"]["data"]["phonenumber"] ?? ""),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
              )),
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                trailing: Text(details["args"]["data"]["email"] ?? ""),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
              )),
              child: ListTile(
                leading: const Icon(Icons.tune),
                title: const Text("Department"),
                trailing:
                    Text(details["args"]["data"]["dept"]["deptName"] ?? ""),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
              )),
              child: ListTile(
                leading: const Icon(Icons.how_to_reg),
                title: const Text("Post"),
                trailing: Text(details["args"]["postGroup"] ?? ""),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
              )),
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Role"),
                trailing: Text(details["args"]["roleGroup"] ?? ""),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
                bottom: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Color.fromARGB(500, 241, 241, 251)),
              )),
              child: ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text("Create Date"),
                trailing: Text(details["args"]["data"]["createTime"] ?? ""),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
