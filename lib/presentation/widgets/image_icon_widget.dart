import 'package:flutter/material.dart';

class ImageIconWidget extends StatelessWidget {
  Function()? onTap;
  String path;
  double? size;

  ImageIconWidget({super.key, this.onTap, required this.path, this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        path,
        width: size ?? 30,
        height: size ?? 30,
      ),
    );
  }
}
