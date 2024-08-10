import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/assets/images/index.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/datasource/services/location_service.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10)),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                    hintText: state.getWeather() != null
                        ? "The weather at ur location is ${state.getWeather()?.temperature}${state.getWeather()?.temperatureUnit}"
                        : "Search Products",
                    hintStyle:
                        const TextStyle(color: Colors.black38, fontSize: 15),
                    prefixIcon: const Icon(
                      CupertinoIcons.search,
                      color: Colors.black38,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12))),
              );
            },
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(CupertinoIcons.gift_fill),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SafeArea(
            child: Column(
          children: [
            _locationWidget(),
            Text(
              "Place code: ${LocationService.locationCodeCurrent}",
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w500, fontSize: 15),
            ),
            _foodRenderWider()
          ],
        )),
      ),
    );
  }

  Widget _foodRenderWider() {
    return BlocBuilder<FoodPersonalBloc, FoodPersonalState>(
        builder: (context, state) {
      if (state is FetchingFoodByLocationCodeState) {
        return const Center(
          child: CircularProgressIndicator(
            color: ColorConfig.primary,
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
                    .add(FetchFoodByLocationCodeEvent());
              },
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final food = list[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FoodCardHomePersonalWidget(
                      foodModel: food,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
      return Container();
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
