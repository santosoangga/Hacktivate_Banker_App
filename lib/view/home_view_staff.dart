import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'dart:async';
import 'package:h8_fli_geo_maps_starter/manager/nfc_bloc.dart';
import 'package:h8_fli_geo_maps_starter/manager/auth_bloc.dart';
import 'package:h8_fli_geo_maps_starter/model/assignment.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeViewStaff extends StatefulWidget {
  const HomeViewStaff({super.key});

  @override
  State<HomeViewStaff> createState() => _HomeViewStaffState();
}

class _HomeViewStaffState extends State<HomeViewStaff> {
  bool _scanning = false;
  bool? _nfcValid;
  Assignment? _lastAssignment;
  NFCAvailability? _nfcAvailability;
  Timer? _nfcTimer;

  @override
  void initState() {
    super.initState();
    _checkNFCAvailability();
    _nfcTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkNFCAvailability();
    });
  }

  @override
  void dispose() {
    _nfcTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkNFCAvailability() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    if (mounted) {
      setState(() {
        _nfcAvailability = availability;
      });
    }
  }

  void _startScan() {
    setState(() {
      _scanning = true;
      _nfcValid = null;
      _lastAssignment = null;
    });
    context.read<NfcBloc>().add(ReadEvent());
  }

  void _checkAssignment(BuildContext context, Assignment assignment, String? staffId) {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final start = _parseTime(today, assignment.taskStartTime);
    final end = _parseTime(today, assignment.taskEndTime);
    final isToday = assignment.taskDate == today;
    final nfcStaffId = assignment.staffId;
    final currentStaffId = staffId ?? ''; // fallback for demo
    final valid = isToday && now.isAfter(start) && now.isBefore(end) && nfcStaffId == currentStaffId;
    setState(() {
      _nfcValid = valid;
      _lastAssignment = assignment;
      _scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final staffId = context.select<AuthBloc, String?>((bloc) {
      final state = bloc.state;
      return state is AuthSuccess ? state.userId : null;
    });
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<NfcBloc, NfcState>(
            listenWhen: (prev, curr) => prev.assignment != curr.assignment,
            listener: (context, state) {
              final assignment = state.assignment;
              if (assignment != null) {
                _checkAssignment(context, assignment, staffId);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (staffId != null) ...[
                    Text('Logged in as: $staffId', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                  ],
                  Icon(Icons.nfc, size: 64, color: Colors.blueAccent),
                  const SizedBox(height: 16),
                  if (_nfcAvailability != null && _nfcAvailability != NFCAvailability.available)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.block, color: Colors.red, size: 28),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _nfcAvailability == NFCAvailability.not_supported
                                  ? 'NFC not supported on this device.'
                                  : 'NFC is disabled. Please enable NFC in settings.',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    'Tap your NFC tag to scan and check in.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ShadButton.outline(
                    leading: Icon(Icons.nfc),
                    onPressed: _scanning || _nfcAvailability != NFCAvailability.available ? null : _startScan,
                    child: Text(_scanning ? 'Scanning...' : 'Scan NFC'),
                  ),

                  const SizedBox(height: 24),
                  if (state.status != null)
                    Text(
                      state.status!,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  if (_lastAssignment != null) ...[
                    const SizedBox(height: 24),
                    ShadCard(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Scanned NFC Content:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Staff ID: ${_lastAssignment!.staffId}'),
                            Text('Date: ${_lastAssignment!.taskDate}'),
                            Text('Start Time: ${_lastAssignment!.taskStartTime}'),
                            Text('End Time: ${_lastAssignment!.taskEndTime}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _nfcValid == true ? Icons.check_circle : Icons.error,
                          color: _nfcValid == true ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _nfcValid == true ? 'NFC is valid' : 'NFC is not valid',
                          style: TextStyle(
                            color: _nfcValid == true ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (_nfcValid == true) ...[
                      const SizedBox(height: 16),
                      ShadButton.secondary(
                        leading: Icon(Icons.check_circle),
                        child: Text('Continue to Maps'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/geo');
                        },
                      ),
                    ],
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  DateTime _parseTime(String date, String time) {
    // Handles both 24-hour and 12-hour (AM/PM) formats
    final dateTimeString = '$date $time';
    try {
      // Try 24-hour format first
      return DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(dateTimeString);
    } catch (_) {
      try {
        return DateFormat('yyyy-MM-dd HH:mm').parseStrict(dateTimeString);
      } catch (_) {
        // Try 12-hour format with AM/PM
        try {
          return DateFormat('yyyy-MM-dd hh:mm:ss a').parseStrict(dateTimeString);
        } catch (_) {
          return DateFormat('yyyy-MM-dd hh:mm a').parseStrict(dateTimeString);
        }
      }
    }
  }
}
