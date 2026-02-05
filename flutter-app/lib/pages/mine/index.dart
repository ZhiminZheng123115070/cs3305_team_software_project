import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

import '../../api/system/user.dart';

class MineIndex extends StatefulWidget {
  const MineIndex({Key? key}) : super(key: key);

  @override
  State<MineIndex> createState() => _MineIndexState();
}

class _MineIndexState extends State<MineIndex> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Mine",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent, // Set background color to transparent
            shadowColor: Colors.transparent,
          ),
          body: Container(
            child: ListView(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: const FractionalOffset(0.5, 0),
                      child: Container(
                        margin: EdgeInsets.only(),
                        height: 150,
                        color: Theme.of(context).colorScheme.secondary,
                        padding: EdgeInsets.only(top: 40),
                        child: ListTile(
                          onTap: () async {
                            ///TODO Navigate to profile details page
                            var data = await getUserProfile().then((value) {
                              if (value.data["code"] == 200) {
                                Get.toNamed("/home/info",
                                    arguments: {"args": value.data});
                              }
                            }, onError: (e) {
                              print(e);
                            });
                          },
                          leading: ClipOval(
                            child: Image.asset(
                              "static/images/profile.jpg",
                              width: 58,
                              height: 58,
                            ),
                          ),
                          title: Text(
                            //${SPUtil().get("name")}
                            "Username: ${GetStorage().read("userName") ?? ""}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          subtitle: Text(
                            // SPUtil().get("name"),
                            GetStorage().read("roleGroup") ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const FractionalOffset(0.78, 0.29),
                      child: Container(
                        height: 280,
                        margin: const EdgeInsets.fromLTRB(15, 160, 15, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  ///TODO Navigate to edit profile page
                                  getProfile().then((value) => Get.toNamed(
                                      "/home/userEdit",
                                      arguments: {"arg": value.data}));
                                },
                                leading: Icon(
                                  Icons.perm_identity,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "Edit Profile",
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              ListTile(
                                onTap: () async {
                                  ///TODO Navigate to about us page
                                  await Get.toNamed("/home/about");
                                },
                                leading: Icon(
                                  Icons.favorite_border,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "About Us",
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              ListTile(
                                onTap: () async {
                                  ///TODO Navigate to app settings page
                                  await Get.toNamed("/home/settings");
                                },
                                leading: Icon(
                                  Icons.settings,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "App Settings",
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
