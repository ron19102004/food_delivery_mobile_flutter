import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/configs/utils/time_format.dart';
import 'package:mobile/datasource/repositories/food_repository.dart';

import '../../../../configs/dependency_injection.dart';

class FoodDetailsPersonScreen extends StatefulWidget {
  final int foodId;

  const FoodDetailsPersonScreen({super.key, required this.foodId});

  @override
  State<FoodDetailsPersonScreen> createState() =>
      _FoodDetailsPersonScreenState();
}

class _FoodDetailsPersonScreenState extends State<FoodDetailsPersonScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: di<FoodRepository>().getFoodsById(widget.foodId),
        builder: (context, state) {
          if (!state.hasData) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Align(
                child: CircularProgressIndicator(
                  color: ColorConfig.primary,
                ),
              ),
            );
          }
          final food = state.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ColorConfig.primary,
              leading: IconButton(
                iconSize: 20,
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Colors.black87,
                ),
              ),
              title: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Open at ",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      timeFormat(food.sellerModel?.openAt),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Close at ", style: TextStyle(fontSize: 15)),
                    Text(
                      timeFormat(food.sellerModel?.closeAt),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                SizedBox(
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Image.network(
                        food.poster ?? "",
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      food.saleOff > 0.0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Material(
                                shadowColor: Colors.red,
                                elevation: 5,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10))),
                                  child: Text(
                                    "Sale off ${food.saleOff}%",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                ),
                SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 200,
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  food.name,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "Sold: ${food.sold} |",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Text(" Price: ",
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                      "\$${food.price}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          decoration: food.saleOff > 0.0
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    food.saleOff > 0.0
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 1),
                                            child: Text(
                                              " ${food.salePrice}\$",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConfig.primary),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade100,
                                height: 15,
                              ),
                              Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            "Description",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            food.description,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Text(
                                          "Order now",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  context.goNamed(
                                      RoutePath
                                          .foodsByCategoryIdPersonScreen.name,
                                      pathParameters: {
                                        "categoryId":
                                            food.categoryModel?.id.toString() ??
                                                "0",
                                        "categoryName":
                                            food.categoryModel?.name ??
                                                "Unknown"
                                      });
                                },
                                leading: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      food.categoryModel?.image ?? "",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          CupertinoIcons.archivebox,
                                          size: 50,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(
                                  food.categoryModel?.name ?? "Unknown",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade100,
                                height: 15,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Shop",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  context.goNamed(
                                      RoutePath
                                          .sellerDetailsAtPersonScreen.name,
                                      pathParameters: {
                                        "id": food.sellerModel?.id.toString() ??
                                            "0",
                                      });
                                },
                                leading: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      food.sellerModel?.avatar ?? "",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          CupertinoIcons.person,
                                          size: 50,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(
                                  food.sellerModel?.name ?? "Unknown",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Phone number: ${food.sellerModel?.phoneNumber}"),
                                    Text(
                                      "Address: ${food.sellerModel?.address}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                                trailing: const Icon(CupertinoIcons.forward),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
