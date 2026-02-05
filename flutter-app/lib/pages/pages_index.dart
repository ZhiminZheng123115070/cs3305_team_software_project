import 'package:flutter/material.dart';

import 'cart/index.dart';
import 'home/index.dart';
import 'mine/index.dart';

/// Bottom dock: Home, Cart, Mine (fixed first-level menus).
class PageIndex extends StatefulWidget {
  const PageIndex({Key? key}) : super(key: key);

  @override
  State<PageIndex> createState() => _PageIndexState();
}

class _PageIndexState extends State<PageIndex> {
  int _index_current = 0;

  final List _pageList = [
    const HomeIndex(),
    const CartIndex(),
    const MineIndex(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_index_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index_current,
        onTap: (int index) {
          setState(() {
            _index_current = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Mine"),
        ],
      ),
    );
  }
}
