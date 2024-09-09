import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/configs/utils/time_format.dart';
import 'package:mobile/datasource/models/food_model.dart';

import '../../datasource/services/location_service.dart';
import '../widgets/map_widget.dart';

class BuildWidget extends StatefulWidget {
  const BuildWidget({super.key});

  @override
  State<BuildWidget> createState() => _BuildWidgetState();
}

class _BuildWidgetState extends State<BuildWidget> {
  late LatLng initialCenter;
  @override
  void initState() {
    super.initState();
    initialCenter = LatLng(LocationService.locationCurrent.latitude, LocationService.locationCurrent.longitude);
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
