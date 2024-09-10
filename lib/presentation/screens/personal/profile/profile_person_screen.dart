import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/models/user_model.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:mobile/presentation/screens/deliver/home/home_deliver_screen.dart';
import 'package:mobile/presentation/widgets/update_lat_lon_map_seller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../datasource/services/location_service.dart';

class ProfilePersonScreen extends StatefulWidget {
  const ProfilePersonScreen({super.key});

  @override
  State<ProfilePersonScreen> createState() => _ProfilePersonScreenState();
}

class _ProfilePersonScreenState extends State<ProfilePersonScreen> {
  bool isTFA = false;
  late LatLng initialCenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isTFA = AuthService.userCurrent!.enabledTwoFactorAuth;
    initialCenter = LatLng(LocationService.locationCurrent.latitude,
        LocationService.locationCurrent.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: _userTileWidget(),
        toolbarHeight: 140,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: Colors.grey.shade100,
            leading: const Text(
              "Two Factor Auth",
              style: TextStyle(fontSize: 15),
            ),
            trailing: Switch(
                activeColor: ColorConfig.primary,
                inactiveTrackColor: Colors.grey.shade100,
                value: isTFA,
                onChanged: (value) async {
                  final res = await AuthService.changeTFA();
                  if (res.status) {
                    setState(() {
                      isTFA = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                        "Change two factor authentication successfully!",
                        style: TextStyle(color: Colors.white),
                      )),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                        "Error when change two factor authentication!",
                        style: TextStyle(color: Colors.white),
                      )),
                    );
                  }
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          _sellerTileWidgets(),
          _userTileWidgets(),
          _deliverTileWidgets(),
          ListTile(
            tileColor: Colors.grey.shade100,
            onTap: () async {
              await AuthService.logout(() {
                BottomBarState.indexPersonBottomBar = BottomBarIndex.home.idx;
                context.goNamed(RoutePath.homePersonalScreen.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                    'Logged out!',
                    style: TextStyle(color: Colors.white),
                  )),
                );
              });
            },
            leading: const Text(
              "Logout",
              style: TextStyle(fontSize: 15),
            ),
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.arrow_right_square_fill)),
          ),
        ],
      ),
    );
  }

  Widget _sellerTileWidgets() {
    if (AuthService.isRole(UserRole.seller)) {
      return Column(
        children: [
          ListTile(
            tileColor: Colors.grey.shade100,
            leading: const Text(
              "Update location",
              style: TextStyle(fontSize: 15),
            ),
            trailing: IconButton(
                onPressed: () {
                  showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text(
                              "Change location",
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
                          body: UpdateLatLonMapSeller(
                            initialCenter: initialCenter,
                          ),
                        );
                      });
                },
                icon: const Icon(CupertinoIcons.arrow_2_circlepath_circle)),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _userTileWidgets() {
    if (AuthService.isRole(UserRole.user)) {
      return Column(
        children: [
          ListTile(
            tileColor: Colors.grey.shade100,
            onTap: () {
              context.goNamed(RoutePath.myOrderPersonScreen.name);
            },
            leading: const Text(
              "My Orders",
              style: TextStyle(fontSize: 15),
            ),
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.shopping_cart)),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _deliverTileWidgets() {
    if (AuthService.isRole(UserRole.deliver)) {
      return Column(
        children: [
          ListTile(
            tileColor: Colors.grey.shade100,
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HomeDeliverScreen(),
                  ));
            },
            leading: const Text(
              "Delivery System",
              style: TextStyle(fontSize: 15),
            ),
            trailing:
                IconButton(onPressed: () {}, icon: Icon(Icons.delivery_dining)),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _userTileWidget() {
    final userCurrent = AuthService.userCurrent;
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Image.network(
            userCurrent?.avatar ?? "",
            width: 100,
            height: 100,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 100,
              height: 100,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: const Center(child: Icon(CupertinoIcons.person)),
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userCurrent?.firstName} ${userCurrent?.lastName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: ColorConfig.primary),
                  ),
                  Text(
                    "@${userCurrent?.username}",
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
