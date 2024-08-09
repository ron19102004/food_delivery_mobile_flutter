import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/assets/animations/index.dart';
import 'package:mobile/configs/dependency_injection.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/services/location_service.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/presentation/blocs/location/location_bloc.dart';
import 'package:mobile/presentation/blocs/weather/weather_bloc.dart';

Future<void> main() async {
  await initializeDI();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainWidget());
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late final LocationService _locationService;

  @override
  void initState() {
    super.initState();
    setState(() {
      _locationService = di();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _locationService.getLocation(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final location = snapshot.requireData;
          return MultiBlocProvider(
              providers: [
                BlocProvider<WeatherBloc>(
                    create: (_) => WeatherBloc()
                      ..add(WeatherFetchEvent(
                          lat: location.latitude ?? "",
                          lon: location.longitude ?? ""))),
                BlocProvider<LocationBloc>(
                  create: (_) => LocationBloc()
                    ..add(LoadLocationEvent(locationModel: location)),
                )
              ],
              child: MaterialApp.router(
                routerConfig: router,
                debugShowCheckedModeBanner: false,
              ));
        }
        return _loadingWidget();
      },
    );
  }

  Widget _loadingWidget() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Align(
              alignment: AlignmentDirectional(0, -0.5),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Finding your location...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Align(
              child: SizedBox(
                height: 300,
                child: Lottie.asset(AnimationPath.location.path),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
