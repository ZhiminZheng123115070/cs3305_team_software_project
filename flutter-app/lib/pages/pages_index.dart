import 'package:flutter/material.dart';

import 'cart/index.dart';
import 'home/index.dart';
import 'mine/index.dart';
import 'scan/scan_index.dart'; // ✅ add this import (make sure file path matches)

/// Bottom dock: Home, Cart, Scan, Mine (fixed first-level menus).
class PageIndex extends StatefulWidget {
  const PageIndex({Key? key}) : super(key: key);

  @override
  State<PageIndex> createState() => _PageIndexState();
}

class _PageIndexState extends State<PageIndex> {
  int _indexCurrent = 0;

  final List<Widget> _pageList = const [
    HomeIndex(),
    CartIndex(),
    ScanIndex(), // ✅ new tab
    MineIndex(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ preserves state when switching tabs
      body: IndexedStack(
        index: _indexCurrent,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexCurrent,
        onTap: (int index) {
          setState(() {
            _indexCurrent = index;
          });
        },
        type: BottomNavigationBarType.fixed, // ✅ needed for 4 items
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Mine"),
        ],
      ),
    );
  }
}

