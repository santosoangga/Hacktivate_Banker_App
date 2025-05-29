import 'dart:async';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart';

class NfcService {
  // DONE: 1. Create stream to provide NFCTag data.
  final _nfcTagController = StreamController<NFCTag>.broadcast();
  Stream<NFCTag> get nfcTagStream => _nfcTagController.stream;

  // DONE: 2. Create stream to provide NDEFRecords data.
  final _ndefRecordsController = StreamController<List<NDEFRecord>>.broadcast();
  Stream<List<NDEFRecord>> get ndefRecordsStream =>
      _ndefRecordsController.stream;

  /// [pollTag] is mainly used for ready the NFC tag.
  Future<void> pollTag() async {
    // DONE: 3. Complete the pollTag() implementation.
    try {
      final tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 10),
      );
      if (tag.ndefAvailable == true) {
        final ndefRecords = await FlutterNfcKit.readNDEFRecords();
        _ndefRecordsController.add(ndefRecords);
      }

      _nfcTagController.add(tag);
    } catch (e) {
      _nfcTagController.addError(e);
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  /// [writeTag] is mainly used for write data to the NFC tag.
  Future<void> writeTag(NDEFRecord data) async {
    // DONE: 4. Complete the writeTag() implementation.
    try {
      final tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 10),
      );
      if (tag.ndefAvailable == true) {
        await FlutterNfcKit.writeNDEFRecords([data]);
      }
    } catch (e) {
      _ndefRecordsController.addError(e);
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  /// [clearTag] is mainly used for write data to the NFC tag.
  Future<void> clearTag(NDEFRecord data) async {
    // DONE: 4. Complete the writeTag() implementation.
    try {
      final tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 10),
      );
      if (tag.ndefAvailable == true) {
        await FlutterNfcKit.writeNDEFRecords([data]);
      }
    } catch (e) {
      _ndefRecordsController.addError(e);
    } finally {
      await FlutterNfcKit.finish();
    }
  }
}
