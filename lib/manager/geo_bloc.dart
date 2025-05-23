import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:h8_fli_geo_maps_starter/model/geo.dart';
import 'package:h8_fli_geo_maps_starter/service/geo_service.dart';

import 'package:meta/meta.dart';

part 'geo_event.dart';
part 'geo_state.dart';

class GeoBloc extends Bloc<GeoEvent, GeoState> {
  final GeoService service;
  StreamSubscription<Geo>? _subscription;

  final List<Geo> _recordingPoints = [];

  GeoBloc({required this.service}) : super(GeoInitial()) {
    on<GeoInitEvent>((event, emit) async {
      try {
        emit(GeoLoading());
        final isGranted = await service.handlePermission();
        if (isGranted) {
          add(GeoGetLocationEvent());
        }
      } catch (e) {
        emit(GeoError(message: e.toString()));
      }
    });

    on<GeoGetLocationEvent>((event, emit) async {
      try {
        emit(GeoLoading());
        final geo = await service.getLocation();
        emit(GeoLoaded(geo: geo));
      } catch (e) {
        emit(GeoError(message: e.toString()));
      }
    });

    on<GeoStartRealtimeEvent>((event, emit) {
      _recordingPoints.clear();
      _subscription = service.getLocationStream().listen((geo) {
        add(GeoUpdateLocationEvent(geo));
      });
    });

    on<GeoStopRealtimeEvent>((event, emit) {
      _subscription?.cancel();
      _subscription = null;
    });

    on<GeoUpdateLocationEvent>((event, emit) {
      if (state is GeoLoaded) {
        final currentState = state as GeoLoaded;
        _recordingPoints.add(event.geo);
        emit(currentState.copyWith(
          geo: event.geo,
          points: List<Geo>.from(_recordingPoints),
        ));
      } else {
        _recordingPoints.add(event.geo);
        emit(GeoLoaded(geo: event.geo, points: List<Geo>.from(_recordingPoints)));
      }
    });

    on<GeoClearPointsEvent>((event, emit) {
      _recordingPoints.clear();
      if (state is GeoLoaded) {
        final currentState = state as GeoLoaded;
        emit(currentState.copyWith(points: []));
      }
    });

    add(GeoInitEvent());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
