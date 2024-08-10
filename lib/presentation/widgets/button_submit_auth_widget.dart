import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/configs/color_config.dart';

class ButtonSubmitAuthWidget extends StatelessWidget {
  Function() onTap;
  String title;
  bool enabled;
  ButtonSubmitAuthWidget({super.key, required this.onTap, required this.title,required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Material(
        borderRadius: BorderRadius.circular(50),
        elevation: 10,
        shadowColor: ColorConfig.primary,
        child: Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromRGBO(254, 197, 130, 1), ColorConfig.primary],
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                CupertinoIcons.arrow_right,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
