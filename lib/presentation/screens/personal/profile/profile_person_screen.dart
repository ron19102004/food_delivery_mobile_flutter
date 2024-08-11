import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/services/auth_service.dart';

class ProfilePersonScreen extends StatefulWidget {
  const ProfilePersonScreen({super.key});

  @override
  State<ProfilePersonScreen> createState() => _ProfilePersonScreenState();
}

class _ProfilePersonScreenState extends State<ProfilePersonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: _userTileWidget(),
        toolbarHeight: 140,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () async {
              await AuthService.logout(() {
                BottomBarState.indexPersonBottomBar = 0;
                context.goNamed(RoutePath.homePersonalScreen.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                    'Logged out!',
                    style: TextStyle(color: Colors.white),
                  )),
                );
              });
            },
            leading: const Text(
              "Logout",
              style: TextStyle(fontSize: 15),
            ),
            trailing: Icon(CupertinoIcons.arrow_right_square_fill),
          )
        ],
      ),
    );
  }

  Widget _userTileWidget() {
    final userCurrent = AuthService.userCurrent;
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Image.network(
            userCurrent?.avatar ?? "",
            width: 100,
            height: 100,
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userCurrent?.firstName} ${userCurrent?.lastName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: ColorConfig.primary),
                  ),
                  Text(
                    "@${userCurrent?.username}",
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
