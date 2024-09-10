import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/assets/images/index.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:mobile/presentation/screens/auth/verify_otp_screen.dart';
import 'package:mobile/presentation/widgets/button_submit_auth_widget.dart';
import 'package:mobile/presentation/widgets/input_widget.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _enableButtonSubmit = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordTextController.dispose();
    _usernameTextController.dispose();
  }

  Future<void> _loginHandler() async {
    setState(() {
      _enableButtonSubmit = false;
    });
    String errMessage = "";
    if (_usernameTextController.text.length < 5) {
      errMessage += "Username must be the least 5 characters\n";
    }
    if (_passwordTextController.text.length < 8) {
      errMessage += "Password must be the least 8 characters";
    }
    if (errMessage.isNotEmpty) {
      _toastErr(errMessage);
      setState(() {
        _enableButtonSubmit = true;
      });
      return;
    }
    await AuthService.login(
        _usernameTextController.text, _passwordTextController.text, () {
      BottomBarState.indexPersonBottomBar = BottomBarIndex.home.idx;
      context.pushNamed(RoutePath.homePersonalScreen.name);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          "Verify Successfully!",
          style: TextStyle(color: Colors.white),
        )),
      );
    }, (token, email) {
      Navigator.push(context, CupertinoPageRoute(
        builder: (context) {
          return VerifyOtpScreen(token: token, email: email);
        },
      ));
    }, (err) {
      _toastErr(err);
    });
    setState(() {
      _enableButtonSubmit = true;
    });
  }

  void _toastErr(String err) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        err,
        style: const TextStyle(color: Colors.white),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
              top: 0,
              right: -100,
              child: Image.asset(
                ImagePath.blockLogin.path,
                width: 250,
              )),
          Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: IconButton(
                    onPressed: () {
                      BottomBarState.indexPersonBottomBar =
                          BottomBarIndex.home.idx;
                      context.goNamed(RoutePath.homePersonalScreen.name);
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black54,
                    )),
              )),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Please sign in to continue",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InputWidget(
                      prefixIcon: const Icon(CupertinoIcons.person),
                      controller: _usernameTextController,
                      label: "USERNAME",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputWidget(
                      obscureText: true,
                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
                      controller: _passwordTextController,
                      label: "PASSWORD",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonSubmitAuthWidget(
                            enabled: _enableButtonSubmit,
                            onTap: _loginHandler,
                            title: "LOGIN")
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  GestureDetector(
                      onTap: () {
                        context.pushNamed(RoutePath.registerScreen.name);
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            color: ColorConfig.primary,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ))
        ],
      )),
    );
  }
}
