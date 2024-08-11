import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/dependency_injection.dart';
import 'package:mobile/datasource/repositories/food_repository.dart';
import 'package:mobile/datasource/services/location_service.dart';
import 'package:mobile/presentation/widgets/food_card_home_personal_widget.dart';

class FoodsByCategoryIdScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const FoodsByCategoryIdScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<FoodsByCategoryIdScreen> createState() =>
      _FoodsByCategoryIdScreenState();
}

class _FoodsByCategoryIdScreenState extends State<FoodsByCategoryIdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.categoryName,
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            iconSize: 20,
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black87,
            ),
          )),
      body: FutureBuilder(
          future: di<FoodRepository>().getFoodsByCategoryIdAndLocationCode(
              widget.categoryId, LocationService.locationCodeCurrent),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ColorConfig.primary,
                  ),
                ),
              );
            }
            final list = snapshot.data!;
            return Expanded(
              child: Container(
                color: Colors.grey.shade100,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final food = list[index];
                    return FoodCardHomePersonalWidget(
                      imageSize: 120,
                      foodModel: food,
                    );
                  },
                ),
              ),
            );
            ;
          }),
    );
  }
}
