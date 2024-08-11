import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';

class PersonalLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const PersonalLayout({super.key, required this.navigationShell});

  @override
  State<PersonalLayout> createState() => _PersonalLayoutState();
}

class _PersonalLayoutState extends State<PersonalLayout> {
  final List<TabItem> items = const [
    TabItem(
      icon: CupertinoIcons.house_alt_fill,
      title: 'Home',
    ),
    TabItem(
      icon: CupertinoIcons.gift_fill,
      title: 'Vouchers',
    ),
    TabItem(
      icon: CupertinoIcons.person_alt,
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
        indexSelected: BottomBarState.indexPersonBottomBar,
        onTap: (int index) => setState(() {
          BottomBarState.indexPersonBottomBar = index;
          _goToRoute(index);
        }),
      ),
    );
  }
}
