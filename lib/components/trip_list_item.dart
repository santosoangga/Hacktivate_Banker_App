import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:h8_fli_geo_maps_starter/utils/map_utils.dart';

class TripListItem extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripListItem({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pointCount = trip.points.length;
    final distance = MapUtils.calculateDistance(trip);

    return ListTile(
      title: Text(
        DateFormat('MMM dd, yyyy - HH:mm').format(trip.date),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '$pointCount location points recorded',
        style: TextStyle(color: ShadTheme.of(context).colorScheme.mutedForeground),
      ),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: ShadTheme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ShadTheme.of(context).colorScheme.border),
        ),
        child: const Center(child: Icon(LucideIcons.mapPin, size: 24)),
      ),
      trailing: Text(
        '${distance.toStringAsFixed(1)} km',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
      onTap: onTap,
    );
  }
}
