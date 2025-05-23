part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

class HistoryInitEvent extends HistoryEvent {}

class HistoryStartRecordEvent extends HistoryEvent {}

class HistoryStopRecordEvent extends HistoryEvent {}

// New events for trip selection
class HistorySelectTripEvent extends HistoryEvent {
  final Trip trip;
  HistorySelectTripEvent(this.trip);
}

class HistoryCloseSelectedTripEvent extends HistoryEvent {}
