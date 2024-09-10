import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/assets/images/index.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/configs/regex_config.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:mobile/presentation/widgets/button_submit_auth_widget.dart';
import 'package:mobile/presentation/widgets/input_widget.dart';
import 'package:toastification/toastification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _fistNameTextController = TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  bool _enableButtonSubmit = true;

  @override
  void dispose() {
    super.dispose();
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    _fistNameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();
    _phoneTextController.dispose();
    _confirmPasswordTextController.dispose();
  }

  String _errMessageValidate() {
    String errMessage = "";
    if (_fistNameTextController.text.isEmpty) {
      errMessage += "First name is require\n";
    }
    if (_lastNameTextController.text.isEmpty) {
      errMessage += "Last name is require\n";
    }
    if (_usernameTextController.text.length < 5) {
      errMessage += "Username must be the least 5 characters\n";
    }
    if (_emailTextController.text.isEmpty) {
      errMessage += "Email is require\n";
    } else if (RegexConfig.isEmail(_emailTextController.text) == false) {
      errMessage += "Email is invalid\n";
    }
    if (_phoneTextController.text.isEmpty) {
      errMessage += "Phone number is require\n";
    } else if (RegexConfig.isPhone(_phoneTextController.text) == false) {
      errMessage += "Phone number is invalid\n";
    }
    if (_passwordTextController.text.length < 8) {
      errMessage += "Password must be the least 8 characters\n";
    }
    if (_passwordTextController.text != _confirmPasswordTextController.text) {
      errMessage += "Confirm password is invalid\n";
    }
    return errMessage;
  }

  Future<void> _registerHandler() async {
    setState(() {
      _enableButtonSubmit = false;
    });
    String errMessage = _errMessageValidate();
    if (errMessage.isNotEmpty) {
      _toastErr(errMessage);
      setState(() {
        _enableButtonSubmit = true;
      });
      return;
    }
    await AuthService.register(
      _fistNameTextController.text,
      _lastNameTextController.text,
      _usernameTextController.text,
      _emailTextController.text,
      _phoneTextController.text,
      _passwordTextController.text,
      () {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "Register successfully!",
            style: TextStyle(color: Colors.white),
          )),
        );
      },
      (err) {
        _toastErr(err);
      },
    );
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
                      context.pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black54,
                    )),
              )),
          _registerForm()
        ],
      )),
    );
  }

  Widget _registerForm() {
    return Align(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                elevationShadow: 2,
                prefixIcon: const Icon(CupertinoIcons.textformat),
                controller: _fistNameTextController,
                label: "FIRSTNAME",
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                elevationShadow: 2,
                prefixIcon: const Icon(CupertinoIcons.textformat),
                controller: _lastNameTextController,
                label: "LASTNAME",
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                elevationShadow: 2,
                prefixIcon: const Icon(CupertinoIcons.textformat_abc),
                controller: _usernameTextController,
                label: "USERNAME",
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                keyboardType: TextInputType.emailAddress,
                elevationShadow: 2,
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                controller: _emailTextController,
                label: "EMAIL",
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                keyboardType: TextInputType.phone,
                elevationShadow: 2,
                prefixIcon: const Icon(CupertinoIcons.phone),
                controller: _phoneTextController,
                label: "PHONE NUMBER",
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                elevationShadow: 2,
                obscureText: true,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                controller: _passwordTextController,
                label: "PASSWORD",
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                elevationShadow: 2,
                obscureText: true,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                controller: _confirmPasswordTextController,
                label: "CONFIRM PASSWORD",
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonSubmitAuthWidget(
                      enabled: _enableButtonSubmit,
                      onTap: _registerHandler,
                      title: "SIGN UP")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                            color: ColorConfig.primary,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
