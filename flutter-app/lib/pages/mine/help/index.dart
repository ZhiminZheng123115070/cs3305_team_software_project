import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruoyi_app/icon/ruoyi_icon.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FAQ",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent, // Set background color to transparent
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          ListTile(
            minLeadingWidth: -10,
            leading: Icon(
              RuoYiIcons.github,
              size: 25,
              color: Colors.black,
            ),
            title: const Text(
              "RuoYi Questions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: 230,
              margin: const EdgeInsets.only(right: 15, left: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(241, 241, 241, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(241, 241, 241, 1)))),
                    child: ListTile(
                      onTap: () {
                        var arg = {"title": "Is RuoYi open source?", "context": "Yes, it's open source"};
                        Get.toNamed("/home/help/helpDetails", arguments: arg);
                      },
                      title: const Text(
                        "Is RuoYi open source?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(241, 241, 241, 1)))),
                    child: ListTile(
                      onTap: () {
                        var arg = {"title": "Can RuoYi be used commercially?", "context": "Yes, it can be used commercially"};
                        Get.toNamed("/home/help/helpDetails", arguments: arg);
                      },
                      title: const Text(
                        "Can RuoYi be used commercially?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(241, 241, 241, 1)))),
                    child: ListTile(
                      onTap: () {
                        var arg = {
                          "title": "What is RuoYi's official website?",
                          "context": "http://ruoyi.vip"
                        };
                        Get.toNamed("/home/help/helpDetails", arguments: arg);
                      },
                      title: const Text(
                        "What is RuoYi's official website?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(241, 241, 241, 1)))),
                    child: ListTile(
                      onTap: () {
                        var arg = {
                          "title": "What is RuoYi's documentation address?",
                          "context": "http://doc.ruoyi.vip"
                        };
                        Get.toNamed("/home/help/helpDetails", arguments: arg);
                      },
                      title: const Text(
                        "What is RuoYi's documentation address?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ListTile(
            minLeadingWidth: -10,
            leading: Icon(
              Icons.contact_support,
              size: 30,
              color: Colors.black,
            ),
            title: Text(
              "Other Questions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: 173,
              margin: const EdgeInsets.only(right: 15, left: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(241, 241, 241, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(241, 241, 241, 1)))),
                    child: ListTile(
                      onTap: () {
                        var arg = {
                          "title": "How to log out?",
                          "context": "Please click [Mine] - [App Settings] - [Log Out] to log out"
                        };
                        Get.toNamed("/home/help/helpDetails", arguments: arg);
                      },
                      title: const Text(
                        "How to log out?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(241, 241, 241, 1)))),
                    child: ListTile(
                      onTap: () {
                        var arg = {
                          "title": "How to change user avatar?",
                          "context": "Please click [Mine] - [Select Avatar] - [Click Submit] to change user avatar"
                        };
                        Get.toNamed("/home/help/helpDetails", arguments: arg);
                      },
                      title: const Text(
                        "How to change user avatar?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(241, 241, 241, 1)))),
                    child: ListTile(
                      onTap: () {
                        var arg = {
                          "title": "How to change login password?",
                          "context": "Please click [Mine] - [App Settings] - [Change Password] to change login password"
                        };
                        Get.toNamed("/home/help/helpDetails", arguments: arg);
                      },
                      title: const Text(
                        "How to change login password?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
