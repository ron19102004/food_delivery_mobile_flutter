part of 'location_bloc.dart';

sealed class LocationState {
  LocationModel? getLocation() => null;
}

final class LocationInitial extends LocationState {}

class LocationSuccess extends LocationState {
  LocationModel locationModel;

  LocationSuccess({required this.locationModel});

  @override
  LocationModel? getLocation() {
    return locationModel;
  }
}