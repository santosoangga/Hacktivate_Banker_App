import 'package:flutter/material.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:h8_fli_geo_maps_starter/utils/map_utils.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'info_row.dart';

class TripOverviewTab extends StatelessWidget {
  final Trip trip;

  const TripOverviewTab({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final distance = MapUtils.calculateDistance(trip);
    final formattedDate = DateFormat('d MMM yy • HH:mm').format(trip.date);
    final pointCount = trip.points.length;

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const Text(
            'Trip Overview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          InfoRow(
            icon: LucideIcons.calendar,
            text: formattedDate,
          ),
          InfoRow(
            icon: LucideIcons.mapPin,
            text: '$pointCount points',
            additionalChild: const SizedBox(width: 12),
            additionalInfo: InfoRow(
              icon: LucideIcons.ruler,
              text: '${distance.toStringAsFixed(2)} km',
            ),
          ),
        ],
      ),
    );
  }
}
