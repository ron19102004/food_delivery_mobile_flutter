import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/models/food_model.dart';

class FoodCardHomePersonalWidget extends StatefulWidget {
  final FoodModel foodModel;

  const FoodCardHomePersonalWidget({super.key, required this.foodModel});

  @override
  State<FoodCardHomePersonalWidget> createState() =>
      _FoodCardHomePersonalWidgetState();
}

class _FoodCardHomePersonalWidgetState
    extends State<FoodCardHomePersonalWidget> {
  late FoodModel food;

  @override
  void initState() {
    super.initState();
    setState(() {
      food = widget.foodModel;
    });
  }

  void onTap() {
    context.goNamed(RoutePath.foodDetailsPersonScreen.name,
        pathParameters: {"foodId": food.id.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                children: [
                  Image.network(
                    food.poster,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                  food.saleOff > 0.0
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 1),
                              child: Text(
                                "Sale ${food.saleOff}%",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ))
                      : const SizedBox()
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Sold: ${food.sold}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Price: ${food.price}\$",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: food.saleOff > 0.0
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      food.saleOff > 0.0
                          ? Text(
                              "Sale price: ${food.salePrice}\$",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: ColorConfig.primary,
                                  fontWeight: FontWeight.w500),
                            )
                          : const SizedBox()
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
