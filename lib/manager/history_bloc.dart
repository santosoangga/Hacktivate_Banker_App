import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:h8_fli_geo_maps_starter/model/geo.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:h8_fli_geo_maps_starter/service/geo_service.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GeoService geoService;
  StreamSubscription<Geo>? _subscription;
  final List<Geo> _currentRecording = [];
  History _history = History(trips: []);
  static const _minPointsForValidTrip = 2;

  HistoryBloc({required this.geoService}) : super(HistoryInitial()) {
    on<HistoryInitEvent>((_,__) {});
    on<HistoryStartRecordEvent>(_onStartRecord);
    on<HistoryStopRecordEvent>(_onStopRecord);
    on<HistorySelectTripEvent>(_onSelectTrip);
    on<HistoryCloseSelectedTripEvent>(_onCloseSelectedTrip);
  }

  void _onStartRecord(
    HistoryStartRecordEvent event,
    Emitter<HistoryState> emit,
  ) {
    _currentRecording.clear();
    emit(HistoryStartRecording());
    _subscription?.cancel();

    _subscription = geoService.getLocationStream().listen((geo) {
      // Add point if it's sufficiently different from the last one
      if (_shouldAddPoint(geo)) {
        _currentRecording.add(geo);
      }
    });
  }

  // Helper to determine if point should be added to reduce redundant data
  bool _shouldAddPoint(Geo geo) {
    if (_currentRecording.isEmpty) return true;

    final lastPoint = _currentRecording.last;
    const minDelta = 0.00001; // Minimum change to record a new point

    return (lastPoint.latitude - geo.latitude).abs() > minDelta ||
        (lastPoint.longitude - geo.longitude).abs() > minDelta;
  }

  void _onStopRecord(HistoryStopRecordEvent event, Emitter<HistoryState> emit) {
    _subscription?.cancel();
    _subscription = null;

    // Only save if we have enough points to make a meaningful trip
    if (_currentRecording.length >= _minPointsForValidTrip) {
      final newTrip = Trip(
        date: DateTime.now(),
        points: List.from(_currentRecording),
      );

      _history = History(trips: [..._history.trips, newTrip]);
      emit(HistoryStopRecording(recordedPoints: List.from(_currentRecording)));
    } else {
      emit(HistoryInitial());
    }

    _currentRecording.clear();
  }

  void _onSelectTrip(HistorySelectTripEvent event, Emitter<HistoryState> emit) {
    emit(HistoryTripSelected(event.trip));
  }

  void _onCloseSelectedTrip(
    HistoryCloseSelectedTripEvent event,
    Emitter<HistoryState> emit,
  ) {
    emit(HistoryInitial());
  }

  History get history => _history;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
