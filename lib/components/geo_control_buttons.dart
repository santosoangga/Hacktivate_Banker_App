import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h8_fli_geo_maps_starter/manager/geo_bloc.dart';
import 'package:h8_fli_geo_maps_starter/manager/history_bloc.dart';
import 'package:h8_fli_geo_maps_starter/view/history_sheet.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class GeoControlButtons extends StatelessWidget {
  final bool isRecording;

  const GeoControlButtons({
    super.key,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShadButton(
          trailing: Icon(
            isRecording ? LucideIcons.circleStop : LucideIcons.circleDot,
            size: 20,
            color: isRecording ? Colors.red : null,
          ),
          child: Text(isRecording ? 'Stop' : 'Record'),
          onPressed: () {
            final historyBloc = context.read<HistoryBloc>();
            final geoBloc = context.read<GeoBloc>();

            if (isRecording) {
              historyBloc.add(HistoryStopRecordEvent());
            } else {
              geoBloc.add(GeoClearPointsEvent());
              historyBloc.add(HistoryStartRecordEvent());
            }
          },
        ),
        // Only show History button when not recording
        if (!isRecording)
          ShadButton(
            leading: const Icon(LucideIcons.history, size: 20),
            child: const Text('History'),
            onPressed: () => showShadSheet(
              side: ShadSheetSide.bottom,
              context: context,
              builder: (context) => HistorySheet(),
            ),
          ),
      ],
    );
  }
}
