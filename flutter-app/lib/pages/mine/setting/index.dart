import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruoyi_app/api/login.dart';
import 'package:ruoyi_app/icon/ruoyi_icon.dart';
import 'package:ruoyi_app/utils/sputils.dart';

import '../../login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "App Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent, // Set background color to transparent
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              height: 210,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Color.fromRGBO(241, 241, 241, 0.8)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.toNamed("/home/settings/pwdIndex");
                    },
                    leading: Icon(RuoYiIcons.password),
                    title: Text("Change Password"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Get.snackbar("Already the latest version!", "");
                    },
                    leading: Icon(RuoYiIcons.refresh),
                    title: Text("Check for Updates"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Get.snackbar("Cache cleared successfully", "");
                      var token = GetStorage().read("token");
                      GetStorage().erase();
                      GetStorage().write("token", token);
                      SPUtil().clean();
                      SPUtil().setString("token", token);
                    },
                    leading: Icon(RuoYiIcons.clean),
                    title: Text("Clear Cache"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            Container(
                height: 45,
                margin: EdgeInsets.only(left: 15, right: 15, top: 45),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5.0))))),
                  onPressed: () {
                    Get.defaultDialog(
                        title: "System Prompt",
                        middleText: "Are you sure you want to log out?",
                        textCancel: "Cancel",
                        textConfirm: "Confirm",
                        onConfirm: () async {
                          try {
                            await logout();
                          } catch (_) {}
                          SPUtil().clean();
                          GetStorage().erase();
                          Get.offAll(() => const MyHome());
                        });
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
