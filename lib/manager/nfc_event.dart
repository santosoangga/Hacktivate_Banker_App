part of 'nfc_bloc.dart';

@immutable
abstract class NfcEvent {}

// DONE: 1. Add the ReadEvent class.
class ReadEvent extends NfcEvent {}

// DONE: 2. Add the UpdateDataEvent class.
/// The class should have the following parameters as the inputs:
/// - NFCTag? metadata
/// - NDEFRecord? data
class UpdateDataEvent extends NfcEvent {
  UpdateDataEvent({this.metadata, this.data});

  final NFCTag? metadata;
  final NDEFRecord? data;
}

// DONE: 3. Add the WriteEvent class.
/// The class should have the following parameters as the inputs:
/// - Assignment assignment
class WriteEvent extends NfcEvent {
  WriteEvent({required this.assignment});

  final Assignment assignment;
}

class ClearEvent extends NfcEvent {}

class UpdateNfcAvailabilityEvent extends NfcEvent {
  final NFCAvailability nfcAvailability;
  UpdateNfcAvailabilityEvent(this.nfcAvailability);
}
