import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/system/user.dart';

class PWDIndex extends StatefulWidget {
  const PWDIndex({Key? key}) : super(key: key);

  @override
  State<PWDIndex> createState() => _PWDIndexState();
}

class _PWDIndexState extends State<PWDIndex> {
  var oldPassword = "";
  var newPassword = "";
  var rawPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent, // Set background color to transparent
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 25,
          ),
          Container(
            height: 40,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Old Password",
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Container(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              oldPassword = value;
                            });
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Please enter old password",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 40,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "New Password",
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Container(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              newPassword = value;
                            });
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Please enter new password",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 40,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "New Password",
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Container(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              rawPassword = value;
                            });
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Please enter new password",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Container(
              height: 45,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))))),
                onPressed: () async {
                  if (oldPassword == "") {
                    Get.snackbar("System Prompt", "Old password cannot be empty");
                  }
                  print(rawPassword);
                  print(newPassword);
                  if (rawPassword == "" || rawPassword != newPassword) {
                    Get.snackbar("System Prompt", "The two passwords do not match");
                    return;
                  }

                  var respData = await updateUserPwd({
                    "oldPassword": oldPassword,
                    "newPassword": newPassword,
                    "rawPassword": rawPassword
                  });
                  if (respData.data["code"] == 200) {
                    Get.back();
                    Get.snackbar("System Prompt", respData.data["msg"]);
                  } else {
                    Get.snackbar("System Prompt", respData.data["msg"]);
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
