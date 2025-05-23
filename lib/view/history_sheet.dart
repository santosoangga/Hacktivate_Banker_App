import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h8_fli_geo_maps_starter/manager/history_bloc.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:h8_fli_geo_maps_starter/components/trip_list_item.dart';

class HistorySheet extends StatelessWidget {
  const HistorySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        final historyBloc = context.read<HistoryBloc>();
        final History history = historyBloc.history;
        final trips = history.trips;

        return ShadSheet(
          constraints: const BoxConstraints(minHeight: 600, maxHeight: 700),
          title: const Text('Trip History'),
          description: const Text("Click a trip to view its details."),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: trips.isEmpty
                  ? _buildEmptyState()
                  : _buildTripList(context, trips, historyBloc),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(LucideIcons.circleAlert, size: 50, color: Colors.red),
        Text(
          "No trips found",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          "You haven't recorded any trips yet. Start recording to see your history.",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTripList(BuildContext context, List<Trip> trips, HistoryBloc historyBloc) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: trips.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final trip = trips[trips.length - 1 - index]; // Display newest first
        return TripListItem(
          trip: trip,
          onTap: () {
            Navigator.pop(context);
            historyBloc.add(HistorySelectTripEvent(trip));
          },
        );
      },
    );
  }
}
