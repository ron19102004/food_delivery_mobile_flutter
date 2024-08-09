import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/datasource/models/location_model.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LoadLocationEvent>((event, emit) {
      emit(LocationSuccess(locationModel: event.locationModel));
    });
  }
}
