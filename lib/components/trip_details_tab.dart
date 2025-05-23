import 'package:flutter/material.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'trip_points_table.dart';

class TripDetailsTab extends StatelessWidget {
  final Trip trip;

  const TripDetailsTab({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final pointCount = trip.points.length;

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(
            'Trip Details ($pointCount points)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          TripPointsTable(points: trip.points),
        ],
      ),
    );
  }
}
