import 'package:flutter/material.dart';
import 'package:h8_fli_geo_maps_starter/model/geo.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TripPointsTable extends StatelessWidget {
  final List<Geo> points;

  const TripPointsTable({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: ShadTable.list(
        header: const [
          ShadTableCell.header(
            child: Text(
              'Lat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
          ShadTableCell.header(
            child: Text(
              'Long',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
        ],
        children: points.map((point) {
          return [
            ShadTableCell(
              child: Text(
                point.latitude.toStringAsFixed(5),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            ShadTableCell(
              child: Text(
                point.longitude.toStringAsFixed(5),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ];
        }).toList(),
      ),
    );
  }
}
