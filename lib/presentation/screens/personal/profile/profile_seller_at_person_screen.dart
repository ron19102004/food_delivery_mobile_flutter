import 'dart:ui';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/assets/images/index.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/configs/utils/time_format.dart';
import 'package:mobile/datasource/repositories/voucher_repository.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:mobile/presentation/blocs/food/seller/food_by_seller_bloc.dart';
import 'package:mobile/presentation/widgets/food_card_home_personal_widget.dart';

import '../../../../configs/dependency_injection.dart';

class ProfileSellerAtPersonScreen extends StatefulWidget {
  final int id;

  const ProfileSellerAtPersonScreen({super.key, required this.id});

  @override
  State<ProfileSellerAtPersonScreen> createState() =>
      _ProfileSellerAtPersonScreenState();
}

class _ProfileSellerAtPersonScreenState
    extends State<ProfileSellerAtPersonScreen> {
  int _pageNumber = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<FoodBySellerBloc>()
        .add(FetchFoodBySellerIdEvent(page: 0, sellerId: widget.id));
  }

  void _clipBoard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
        'Code copied to clipboard!',
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Seller",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(CupertinoIcons.back)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ContainedTabBarView(
          tabBarProperties: const TabBarProperties(
            labelColor: ColorConfig.primary,
            indicatorColor: ColorConfig.primary,
            labelPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          tabs: const [
            Text('Information'),
            Text('Products'),
            Text('Vouchers'),
          ],
          views: [_infoSeller(), _foodsSeller(), _voucher()],
          onChange: (index) {},
          initialIndex: 0,
        ),
      ),
    );
  }

  Widget _infoSeller() {
    return FutureBuilder(
      future: AuthService.getSellerById(widget.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorConfig.primary,
              ),
            ),
          );
        }
        final seller = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Opacity(
                  opacity: 0.7,
                  child: Image.network(
                    seller.backgroundImage,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        seller.avatar ?? "",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            ImagePath.logo.path,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seller.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Open at: ${timeFormat(seller.openAt)} | Close at: ${timeFormat(seller.closeAt)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ))
                    ],
                  ),
                  ListTile(
                    leading: const Text(
                      "Email",
                      style: TextStyle(fontSize: 15),
                    ),
                    title: Text(seller.email),
                    trailing: IconButton(
                        onPressed: () {
                          _clipBoard(seller.email);
                        },
                        icon: const Icon(Icons.copy)),
                  ),
                  ListTile(
                    leading: const Text(
                      "Phone number",
                      style: TextStyle(fontSize: 15),
                    ),
                    title: Text(seller.phoneNumber),
                    trailing: IconButton(
                        onPressed: () {
                          _clipBoard(seller.phoneNumber);
                        },
                        icon: const Icon(Icons.copy)),
                  ),
                  ListTile(
                    leading: const Text(
                      "Address",
                      style: TextStyle(fontSize: 15),
                    ),
                    title: Text(seller.address),
                    trailing: IconButton(
                        onPressed: () {
                          _clipBoard(seller.address);
                        },
                        icon: const Icon(Icons.copy)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _foodsSeller() {
    return BlocBuilder<FoodBySellerBloc, FoodBySellerState>(
        builder: (context, state) {
      if (state is FetchingBySellerIdState) {
        return const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: CircularProgressIndicator(
              color: ColorConfig.primary,
            ),
          ),
        );
      }
      if (state is FetchSuccessBySellerIdState) {
        final list = state.list;
        return Container(
          color: Colors.grey.shade100,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
            color: ColorConfig.primary,
            backgroundColor: Colors.white,
            onRefresh: () async {
              context
                  .read<FoodBySellerBloc>()
                  .add(FetchFoodBySellerIdEvent(page: 0, sellerId: widget.id));
            },
            child: ListView.builder(
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                if (list.isEmpty && _pageNumber > 0) {
                  return Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: GestureDetector(
                        onTap: () async {
                          context.read<FoodBySellerBloc>().add(
                              FetchFoodBySellerIdEvent(
                                  page: _pageNumber - 1, sellerId: widget.id));
                          setState(() {
                            _pageNumber -= 1;
                          });
                        },
                        child: const Center(
                            child: Text(
                          "Back",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        )),
                      ));
                }
                if (index == list.length) {
                  return Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: GestureDetector(
                        onTap: () async {
                          context.read<FoodBySellerBloc>().add(
                              FetchFoodBySellerIdEvent(
                                  page: _pageNumber + 1, sellerId: widget.id));
                          setState(() {
                            _pageNumber += 1;
                          });
                        },
                        child: const Center(
                            child: Text(
                          "More",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        )),
                      ));
                }
                final food = list[index];
                return FoodCardHomePersonalWidget(
                  foodModel: food,
                );
              },
            ),
          ),
        );
      }
      return const Center(
        child: Text("Empty"),
      );
    });
  }

  Widget _voucher() {
    return SafeArea(
        child: FutureBuilder(
      future: di<VoucherRepository>().getVoucher(widget.id, false),
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
            final voucher = list[index];
            return ListTile(
              minLeadingWidth: 100,
              tileColor: index % 2 == 0 ? Colors.orange.shade50 : Colors.white,
              title: Text(voucher.name),
              trailing: IconButton(
                  onPressed: () {
                    // Copy the text to the clipboard
                    Clipboard.setData(ClipboardData(text: voucher.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                        'Code copied to clipboard!',
                        style: TextStyle(color: Colors.white),
                      )),
                    );
                  },
                  icon: const Icon(Icons.copy)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Sold: ${voucher.quantity - voucher.quantityCurrent}/${voucher.quantity}"),
                  Text("Code: ${voucher.code}"),
                ],
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      voucher.categoryModel.image ?? "",
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        ImagePath.logo.path,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5))),
                          child: Text(
                            "${voucher.percent}%",
                            style: const TextStyle(color: Colors.white),
                          )))
                ]),
              ),
            );
          },
        );
      },
    ));
  }
}
