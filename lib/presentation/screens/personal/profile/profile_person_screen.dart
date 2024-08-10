import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: SafeArea(
          child: Column(
        children: [
          TextButton(
              onPressed: () {
                AuthService.logout(
                  () {
                    BottomBarState.indexPersonBottomBar = 0;
                    context.go(RoutePath.homePersonalScreen.path);
                  },
                );
              },
              child: Text("logout"))
        ],
      )),
    );
  }
}
