import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../datasource/services/location_service.dart';
import '../widgets/map_widget.dart';
import 'auth/verify_otp_screen.dart';

class BuildWidget extends StatefulWidget {
  const BuildWidget({super.key});

  @override
  State<BuildWidget> createState() => _BuildWidgetState();
}

class _BuildWidgetState extends State<BuildWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return VerifyOtpScreen(token: 'fgdgfg',email: "dung@gmail.com",);
  }
}
