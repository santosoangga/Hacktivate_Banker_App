import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:h8_fli_geo_maps_starter/model/assignment.dart';
import 'package:h8_fli_geo_maps_starter/service/nfc_service.dart';
import 'package:meta/meta.dart';
import 'package:ndef/record.dart';

part 'nfc_event.dart';
part 'nfc_state.dart';

class NfcBloc extends Bloc<NfcEvent, NfcState> {
  // DONE: 1. Add NfcService as the dependency.
  final NfcService nfcService;

  NfcBloc(this.nfcService) : super(NfcState()) {
    // DONE: 2. Add the events implementation.
    on<ReadEvent>((event, emit) async {
      emit(state.copyWith(status: 'Reading NFC tag...'));
      await nfcService.pollTag();
      emit(state.copyWith(status: 'NFC tag read successfully.'));
    });

    on<UpdateDataEvent>((event, emit) {
      emit(state.copyWith(metadata: event.metadata, data: event.data));
      if (event.data != null) {
        final payload = event.data?.payload;
        if (payload != null) {
          final payloadString = utf8.decode(payload);

          final assignment = Assignment.fromJson(jsonDecode(payloadString));
          emit(state.copyWith(assignment: assignment));
        }
      }
    });

    // DONE: 3. Listen to NFCTag data stream, then update state.
    nfcService.nfcTagStream.listen((nfcTag) {
      add(UpdateDataEvent(metadata: nfcTag));
    });

    // DONE: 4. Listen to NDEFRecords data stream, then update state.
    nfcService.ndefRecordsStream.listen((ndefRecords) {
      add(UpdateDataEvent(data: ndefRecords.firstOrNull));
    });

    on<WriteEvent>((event, emit) async {
      emit(state.copyWith(status: 'Writing NFC tag...'));
      NDEFRecord ndefRecord = NDEFRecord(
        tnf: TypeNameFormat.nfcWellKnown,
        type: utf8.encode('UTF8'),
        id: utf8.encode(event.assignment.staffId),
        payload: utf8.encode(json.encode(event.assignment.toJson())),
      );
      await nfcService.writeTag(ndefRecord);
      emit(state.copyWith(status: 'NFC tag written successfully.'));
    });

    on<ClearEvent>((event, emit) async {
      emit(state.copyWith(status: 'Clearing NFC tag...'));
      NDEFRecord ndefRecord = NDEFRecord(
        tnf: TypeNameFormat.nfcWellKnown,
        type: utf8.encode('UTF8'),
        id: utf8.encode(''),
        payload: utf8.encode(''),
      );
      await nfcService.clearTag(ndefRecord);
      emit(state.copyWith(status: 'NFC tag cleared successfully.'));
      emit(state.copyWith(data: null, assignment: null));
    });
    on<UpdateNfcAvailabilityEvent>((event, emit) {
      emit(state.copyWith(nfcAvailability: event.nfcAvailability));
    });
  }
}
