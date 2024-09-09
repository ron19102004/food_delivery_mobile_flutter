import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/presentation/blocs/food/category/food_by_category_bloc.dart';
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
  int _pageCurrent = 0;

  @override
  void initState() {
    super.initState();
    context.read<FoodByCategoryBloc>().add(
        FetchFoodByLocationCodeAndCategoryIdEvent(
            pageNumber: 0, categoryId: widget.categoryId));
  }

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
      body: BlocBuilder<FoodByCategoryBloc, FoodByCategoryState>(
        builder: (context, state) {
          if (state is FetchSuccessByCategoryAndLocationCodeState) {
            final list = state.foodsByLocationCodeAndCategory;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FoodByCategoryBloc>().add(
                    FetchFoodByLocationCodeAndCategoryIdEvent(
                        pageNumber: 0, categoryId: widget.categoryId));
              },
              child: Container(
                color: Colors.grey.shade100,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: list.length + 1,
                  itemBuilder: (context, index) {
                    if (list.isEmpty && _pageCurrent > 0){
                      return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: GestureDetector(
                            onTap: () async {
                              context.read<FoodByCategoryBloc>().add(
                                  FetchFoodByLocationCodeAndCategoryIdEvent(
                                      pageNumber: _pageCurrent - 1, categoryId: widget.categoryId));
                              setState(() {
                                _pageCurrent -= 1;
                              });
                            },
                            child: const Center(
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 12),
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
                              context.read<FoodByCategoryBloc>().add(
                                  FetchFoodByLocationCodeAndCategoryIdEvent(
                                      pageNumber: _pageCurrent + 1, categoryId: widget.categoryId));
                              setState(() {
                                _pageCurrent += 1;
                              });
                            },
                            child: const Center(
                                child: Text(
                              "More",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            )),
                          ));
                    }
                    final food = list[index];
                    return FoodCardHomePersonalWidget(
                      imageSize: 120,
                      foodModel: food,
                    );
                  },
                ),
              ),
            );
          }
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: ColorConfig.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
