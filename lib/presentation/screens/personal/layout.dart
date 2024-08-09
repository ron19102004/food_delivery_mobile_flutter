import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/configs/color_config.dart';

class PersonalLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const PersonalLayout({super.key, required this.navigationShell});

  @override
  State<PersonalLayout> createState() => _PersonalLayoutState();
}

class _PersonalLayoutState extends State<PersonalLayout> {
  int _indexCurrent = 0;
  final List<TabItem> items = const [
    TabItem(
      icon: CupertinoIcons.house,
      title: 'Home',
    ),
    TabItem(
      icon: CupertinoIcons.gift,
      title: 'Vouchers',
    ),
    TabItem(
      icon: CupertinoIcons.person,
      title: 'Me',
    ),
  ];

  void _goToRoute(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomBarFloating(
        items: items,
        backgroundColor: Colors.white,
        color: Colors.black38,
        colorSelected: ColorConfig.primary,
        indexSelected: _indexCurrent,
        onTap: (int index) => setState(() {
          _indexCurrent = index;
          _goToRoute(index);
        }),
      ),
    );
  }
}
