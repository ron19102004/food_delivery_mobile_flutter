import 'dart:math';

import 'package:animated_pin_input_text_field/animated_pin_input_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:toastification/toastification.dart';

import '../../../configs/navigation_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String token;
  final String email;

  const VerifyOtpScreen({super.key, required this.token, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        surfaceTintColor: Colors.grey.shade100,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(CupertinoIcons.back)),
        backgroundColor: Colors.grey.shade50,
        shadowColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Verify OTP",
          style: TextStyle(
              fontSize: 20,
              color: Colors.red.shade600,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Enter the code sent to the email",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.email,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PinInputTextField(
              pinLength: 6,
              onChanged: (pin) async {
                if (pin.length == 6) {
                 await AuthService.verifyOTP(widget.token, pin, () {
                    BottomBarState.indexPersonBottomBar =
                        BottomBarIndex.home.idx;
                    context.pushNamed(RoutePath.homePersonalScreen.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                        "Verify Successfully!",
                        style: TextStyle(color: Colors.white),
                      )),
                    );
                  }, (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                        err,
                        style: const TextStyle(color: Colors.white),
                      )),
                    );
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
