import 'package:flutter/material.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'trip_overview_tab.dart';
import 'trip_details_tab.dart';

class TripDetailsCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onClose;

  const TripDetailsCard({super.key, required this.trip, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShadIconButton.destructive(
          decoration: ShadDecoration(
            border: ShadBorder(radius: BorderRadius.circular(99)),
          ),
          icon: const Icon(LucideIcons.x, size: 14),
          onPressed: onClose,
        ),
        ShadTabs<String>(
          value: 'overview',
          tabBarConstraints: const BoxConstraints(maxWidth: 220, minWidth: 220),
          contentConstraints: const BoxConstraints(
            maxWidth: 250,
            minWidth: 250,
          ),
          gap: 1,
          tabs: [
            ShadTab(
              value: 'overview',
              content: TripOverviewTab(trip: trip),
              child: const Text('Overview'),
            ),
            ShadTab(
              value: 'details',
              content: TripDetailsTab(trip: trip),
              child: const Text('Details'),
            ),
          ],
        ),
      ],
    );
  }
}
