import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/assets/images/index.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/models/user_model.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:mobile/datasource/services/location_service.dart';
import 'package:mobile/presentation/blocs/category/category_bloc.dart';
import 'package:mobile/presentation/blocs/food/personal/food_personal_bloc.dart';
import 'package:mobile/presentation/blocs/location/location_bloc.dart';
import 'package:mobile/presentation/blocs/weather/weather_bloc.dart';
import 'package:mobile/presentation/widgets/food_card_home_personal_widget.dart';
import 'package:mobile/presentation/widgets/image_icon_widget.dart';

class HomePersonScreen extends StatefulWidget {
  const HomePersonScreen({super.key});

  @override
  State<HomePersonScreen> createState() => _HomePersonScreenState();
}

class _HomePersonScreenState extends State<HomePersonScreen> {
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10)),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.goNamed(RoutePath.searchProductPersonScreen.name);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12, width: 0.8),
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: Colors.black12,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        state.getWeather() != null
                            ? "${state.getWeather()?.temperature}${state.getWeather()?.temperatureUnit} now"
                            : "Search Products",
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if(AuthService.isAuthenticated && AuthService.isRole(UserRole.user)){
                BottomBarState.indexPersonBottomBar = BottomBarIndex.me.idx;
                context.goNamed(RoutePath.myOrderPersonScreen.name);
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(CupertinoIcons.app_badge_fill),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SafeArea(
            child: Column(
          children: [
            _locationWidget(),
            _categoriesRenderWidget(),
            Text(
              "Place code: ${LocationService.locationCodeCurrent}",
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w500, fontSize: 15),
            ),
            _foodRenderWidget()
          ],
        )),
      ),
    );
  }

  Widget _categoriesRenderWidget() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is FetchSuccessCategoryState) {
          final list = state.list;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 78,
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final category = list[index];
                    return GestureDetector(
                      onTap: () {
                        context.goNamed(
                            RoutePath.foodsByCategoryIdPersonScreen.name,
                            pathParameters: {
                              "categoryId": category.id.toString(),
                              "categoryName": category.name
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              category.image ?? "",
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          );
        }
        return const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: CircularProgressIndicator(color: ColorConfig.primary)),
        );
      },
    );
  }

  Widget _foodRenderWidget() {
    return BlocBuilder<FoodPersonalBloc, FoodPersonalState>(
        builder: (context, state) {
      if (state is FetchingFoodByLocationCodeState) {
        return const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: CircularProgressIndicator(
              color: ColorConfig.primary,
            ),
          ),
        );
      }
      if (state is FetchSuccessFoodByLocationCodeState) {
        final list = state.foodsByLocationCode;
        return Expanded(
          child: Container(
            color: Colors.grey.shade100,
            width: MediaQuery.of(context).size.width,
            child: RefreshIndicator(
              color: ColorConfig.primary,
              backgroundColor: Colors.white,
              onRefresh: () async {
                context
                    .read<FoodPersonalBloc>()
                    .add(FetchFoodByLocationCodeEvent(pageNumber: 0));
              },
              child: ListView.builder(
                itemCount: list.length + 1,
                itemBuilder: (context, index) {
                  if (list.isEmpty && pageNumber > 0) {
                    return Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: GestureDetector(
                          onTap: () async {
                            context.read<FoodPersonalBloc>().add(
                                FetchFoodByLocationCodeEvent(
                                    pageNumber: pageNumber - 1));
                            setState(() {
                              pageNumber -= 1;
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
                            context.read<FoodPersonalBloc>().add(
                                FetchFoodByLocationCodeEvent(
                                    pageNumber: pageNumber + 1));
                            setState(() {
                              pageNumber += 1;
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
                    foodModel: food,
                  );
                },
              ),
            ),
          ),
        );
      }
      return const Center(
        child: Text("Empty"),
      );
    });
  }

  Widget _locationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          ImageIconWidget(path: ImagePath.location.path),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state.getLocation() == null) {
                return const Text("Location loading...");
              }
              return Text(
                state.getLocation()?.displayName ?? "Unknown",
                style: const TextStyle(fontStyle: FontStyle.italic),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              );
            },
          ))
        ],
      ),
    );
  }
}
