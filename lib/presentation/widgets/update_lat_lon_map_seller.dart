import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/datasource/services/auth_service.dart';

class UpdateLatLonMapSeller extends StatefulWidget {
  LatLng initialCenter;

  UpdateLatLonMapSeller({super.key, required this.initialCenter});

  @override
  State<UpdateLatLonMapSeller> createState() => _UpdateLatLonMapSellerState();
}

class _UpdateLatLonMapSellerState extends State<UpdateLatLonMapSeller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () async {
            final res = await AuthService.updateLatLonForSeller(
                widget.initialCenter.latitude, widget.initialCenter.longitude);
            if(res.status){
              context.pop();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                res.message,
                style: const TextStyle(color: Colors.white),
              )),
            );
          },
          icon: const Icon(Icons.save_as)),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: widget.initialCenter,
          initialZoom: 14,
          onTap: (tapPosition, point) {
            setState(() {
              widget.initialCenter = point;
            });
          },
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
                point: widget.initialCenter,
                height: 80,
                child: Column(
                  children: [
                    Text(
                      "Here",
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
            ],
          ),
        ],
      ),
    );
  }
}
