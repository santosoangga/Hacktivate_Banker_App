import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h8_fli_geo_maps_starter/manager/nfc_bloc.dart';
import 'package:h8_fli_geo_maps_starter/model/assignment.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'dart:async';

class HomeViewManager extends StatefulWidget {
  const HomeViewManager({super.key});

  @override
  State<HomeViewManager> createState() => _HomeViewManagerState();
}

class _HomeViewManagerState extends State<HomeViewManager> {
  final staffCode = {'ST-01': 'ST-01', 'ST-02': 'ST-02'};
  String? _selectedStaffCode;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 59);
  Timer? _nfcTimer;

  @override
  void initState() {
    super.initState();
    _checkNFCAvailabilityAndDispatch();
    _nfcTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkNFCAvailabilityAndDispatch();
    });
  }

  @override
  void dispose() {
    _nfcTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkNFCAvailabilityAndDispatch() async {
    // Only dispatch to bloc, do not keep local state
    final availability = await FlutterNfcKit.nfcAvailability;
    if (mounted) {
      context.read<NfcBloc>().add(UpdateNfcAvailabilityEvent(availability));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: BlocBuilder<NfcBloc, NfcState>(
            builder: (context, state) {
              final nfcAvailability = state.nfcAvailability;
              return ShadCard(
                width: 350,
                title: Text('Assignment Manager'),
                description: Text(
                  'Fill in the assignment details below to write or clear an NFC tag.',
                ),
                footer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadButton(
                      child: const Text('Write NFC Tag'),
                      enabled: _selectedStaffCode != null && _startTime.hour < _endTime.hour && (nfcAvailability == NFCAvailability.available),
                      onPressed: _selectedStaffCode == null || nfcAvailability != NFCAvailability.available
                          ? null
                          : () {
                              final assignment = Assignment(
                                staffId: _selectedStaffCode!,
                                taskDate: _selectedDate.toIso8601String().split('T').first,
                                taskStartTime: _startTime.format(context),
                                taskEndTime: _endTime.format(context),
                              );
                              context.read<NfcBloc>().add(
                                WriteEvent(assignment: assignment),
                              );
                            },
                    ),
                    ShadButton.destructive(
                      child: const Text('Clear NFC Tag'),
                      onPressed: nfcAvailability != NFCAvailability.available
                          ? null
                          : () {
                              context.read<NfcBloc>().add(ClearEvent());
                            },
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (nfcAvailability != null && nfcAvailability != NFCAvailability.available)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.block, color: Colors.red, size: 28),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  nfcAvailability == NFCAvailability.not_supported
                                      ? 'NFC not supported on this device.'
                                      : 'NFC is disabled. Please enable NFC in settings.',
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      BlocBuilder<NfcBloc, NfcState>(
                        builder: (context, state) {
                          IconData icon;
                          Color color;
                          String text = state.status ?? 'Idle';
                          if (state.status == null || state.status!.isEmpty) {
                            icon = Icons.nfc;
                            color = Colors.grey;
                          } else if (state.status!.toLowerCase().contains('writing') || state.status!.toLowerCase().contains('reading') || state.status!.toLowerCase().contains('clearing')) {
                            icon = Icons.sync;
                            color = Colors.blueAccent;
                          } else if (state.status!.toLowerCase().contains('success')) {
                            icon = Icons.check_circle;
                            color = Colors.green;
                          } else if (state.status!.toLowerCase().contains('error') || state.status!.toLowerCase().contains('fail')) {
                            icon = Icons.error;
                            color = Colors.red;
                          } else {
                            icon = Icons.nfc;
                            color = Colors.grey;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon, color: color, size: 28),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    text,
                                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ShadSelect<String>(
                        placeholder: const Text('Select Staff Code'),
                        options: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 6, 6, 6),
                            child: Text(
                              'Staff Code',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...staffCode.entries.map(
                            (e) => ShadOption(value: e.key, child: Text(e.value)),
                          ),
                        ],
                        onChanged: (value) => setState(() => _selectedStaffCode = value),
                        selectedOptionBuilder: (context, value) => Text(staffCode[value]!),
                      ),
                      SizedBox(height: 12),
                      Text('Task Date'),
                      SizedBox(height: 6),
                      ShadDatePickerFormField(
                        label: Text('Select Date'),
                        closeOnSelection: true,
                        initialValue: _selectedDate,
                        onChanged: (date) => setState(() => _selectedDate = date ?? DateTime.now()),
                      ),
                      SizedBox(height: 12),
                      ShadTimePickerFormField(
                        label: Text('Start Time'),
                        initialValue: ShadTimeOfDay(
                          hour: _startTime.hour,
                          minute: _startTime.minute,
                          second: 0,
                        ),
                        onChanged: (shadTime) => setState(() => _startTime = TimeOfDay(hour: shadTime!.hour, minute: shadTime.minute)),
                      ),
                      SizedBox(height: 12),
                      ShadTimePickerFormField(
                        label: Text('End Time'),
                        initialValue: ShadTimeOfDay(
                          hour: _endTime.hour,
                          minute: _endTime.minute,
                          second: 0,
                        ),
                        onChanged: (shadTime) => setState(() => _endTime = TimeOfDay(hour: shadTime!.hour, minute: shadTime.minute)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
