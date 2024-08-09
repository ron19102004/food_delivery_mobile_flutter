part of 'location_bloc.dart';

sealed class LocationEvent {}

class LoadLocationEvent extends LocationEvent {
  LocationModel locationModel;
  LoadLocationEvent({required this.locationModel});
}
