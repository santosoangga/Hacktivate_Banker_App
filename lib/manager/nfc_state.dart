part of 'nfc_bloc.dart';

// DONE: 1. Complete the state class implementation.
/// The class should have the following parameters as the states:
/// - NFCTag? metadata
/// - NDEFRecord? data
/// - Assignment? assignment
/// - String? status
@immutable
class NfcState {
  final NFCTag? metadata;
  final NDEFRecord? data;
  final Assignment? assignment;
  final String? status;
  final NFCAvailability? nfcAvailability;

  const NfcState({this.metadata, this.data, this.assignment, this.status, this.nfcAvailability});

  NfcState copyWith({
    NFCTag? metadata,
    NDEFRecord? data,
    Assignment? assignment,
    String? status,
    NFCAvailability? nfcAvailability,
  }) {
    return NfcState(
      metadata: metadata ?? this.metadata,
      data: data ?? this.data,
      assignment: assignment ?? this.assignment,
      status: status ?? this.status,
      nfcAvailability: nfcAvailability ?? this.nfcAvailability,
    );
  }
}
