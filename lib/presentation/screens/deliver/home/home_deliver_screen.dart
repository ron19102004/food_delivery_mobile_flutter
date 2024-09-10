import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/repositories/order_repository.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../configs/color_config.dart';
import '../../../../configs/dependency_injection.dart';
import '../../../../datasource/services/location_service.dart';
import '../../../widgets/map_widget.dart';

class HomeDeliverScreen extends StatefulWidget {
  const HomeDeliverScreen({super.key});

  @override
  State<HomeDeliverScreen> createState() => _HomeDeliverScreenState();
}

class _HomeDeliverScreenState extends State<HomeDeliverScreen> {


  late LatLng initialCenter;

  @override
  void initState() {
    super.initState();
    initialCenter = LatLng(LocationService.locationCurrent.latitude,
        LocationService.locationCurrent.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        surfaceTintColor: Colors.grey.shade50,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(CupertinoIcons.back)),
        centerTitle: true,
        title: Text("Delivery System",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red.shade500)),
      ),
      body: Column(
        children: [Expanded(child: _orders())],
      ),
    );
  }

  Widget _orders() {
    return FutureBuilder(
        future: di<OrderRepository>().getAllOrderForDeliver(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorConfig.primary,
              ),
            );
          }
          final list = snapshot.data!;
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                if(item.deliver!=null && item.deliver?.id != AuthService.userCurrent?.id){
                  return const SizedBox();
                }
                return Column(
                  children: [
                    ListTile(
                      trailing: item.deliver==null? IconButton(onPressed: () async{
                          final res = await di<OrderRepository>().updateDeliver(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                  res.message,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          );
                      }, icon: const Icon(Icons.motorcycle_outlined)):null,
                      tileColor: item.deliver == null ? ( index % 2 == 0
                          ? Colors.grey.shade200
                          : Colors.orange.shade200) : Colors.red.shade200,
                      title: Text("Product:${item.food.name}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total price: \$${item.total}"),
                          Text("Shop name: ${item.seller.name}"),
                          Text("Receiver name: ${item.user?.firstName}${item.user?.lastName}"),
                          Text("Deliver name: ${item.deliver?.name}"),
                        ],
                      ),
                      leading: IconButton(onPressed: () {
                        showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(
                                    "Map",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade500),
                                  ),
                                  centerTitle: true,
                                  backgroundColor: Colors.grey.shade50,
                                  leading: IconButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      icon: const Icon(CupertinoIcons.back)),
                                ),
                                body: MapOrderWidget(
                                  initialCenter: initialCenter,
                                  latLngUser: LatLng(item.latitudeReceive, item.longitudeReceive),
                                  latLngShop:  LatLng(item.latitudeSend, item.longitudeSend),
                                  latLngDeliver: initialCenter,
                                ),
                              );
                            });
                      }, icon: const Icon(CupertinoIcons.map)),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              });
        });
  }
}
