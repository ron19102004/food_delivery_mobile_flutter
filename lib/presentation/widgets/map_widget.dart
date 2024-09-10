import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/configs/color_config.dart';

class MapOrderWidget extends StatelessWidget {
  LatLng initialCenter;
  LatLng latLngUser;
  LatLng latLngShop;
  LatLng? latLngDeliver;

  MapOrderWidget(
      {super.key,
      required this.initialCenter,
      required this.latLngUser,
      required this.latLngShop,
      this.latLngDeliver});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          maxNativeZoom:
              19, // Scale tiles when the server doesn't support higher zoom levels
          // And many more recommended properties!
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: latLngUser,
              height: 80,
              child: Column(
                children: [
                  Text(
                    "User",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade500),
                  ),
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.red.shade500,
                  )
                ],
              ),
            ),
            Marker(
              point: latLngShop,
              height: 80,
              child: Column(
                children: [
                  Text(
                    "Shop",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade500),
                  ),
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.blue.shade500,
                  )
                ],
              ),
            ),
          ],
        ),
        latLngDeliver != null
            ? MarkerLayer(markers: [
                Marker(
                  point: latLngDeliver!,
                  height: 80,
                  child: Column(
                    children: [
                      Text(
                        "Deliver",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade500),
                      ),
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.blue.shade500,
                      )
                    ],
                  ),
                ),
              ])
            : const SizedBox(),
        PolylineLayer(
          polylines: [
            Polyline(
                points: [latLngUser, latLngShop, latLngShop],
                // Nối giữa 2 điểm
                strokeWidth: 4.0,
                // Độ dày của đường
                color: ColorConfig.primary,
                // Màu của đường
                gradientColors: [Colors.green, ColorConfig.primary]),
          ],
        ),
      ],
    );
  }
}
