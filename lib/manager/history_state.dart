part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class HistoryStartRecording extends HistoryState {}

final class HistoryStopRecording extends HistoryState {
  final List<Geo> recordedPoints;
  
  HistoryStopRecording({required this.recordedPoints});
}

final class HistoryTripSelected extends HistoryState {
  final Trip selectedTrip;
  
  HistoryTripSelected(this.selectedTrip);
}
