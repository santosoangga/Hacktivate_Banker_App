import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:h8_fli_geo_maps_starter/model/geo.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:h8_fli_geo_maps_starter/utils/map_utils.dart';

class GeoMap extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Function(GoogleMapController) onMapCreated;
  final Geo currentLocation;
  final List<Geo> points;
  final Trip? selectedTrip;
  final bool isRecording;

  const GeoMap({
    super.key,
    required this.initialCameraPosition,
    required this.onMapCreated,
    required this.currentLocation,
    required this.points,
    this.selectedTrip,
    this.isRecording = false,
  });

  @override
  Widget build(BuildContext context) {
    final Set<Polyline> polylines = _buildPolylines();
    final Set<Circle> circles = _buildCircles();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: onMapCreated,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        circles: selectedTrip == null ? circles : {},
        polylines: polylines,
        markers:
            selectedTrip == null
                ? {}
                : {
                  Marker(
                    markerId: const MarkerId('start'),
                    position: LatLng(
                      selectedTrip!.points.first.latitude,
                      selectedTrip!.points.first.longitude,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('finish'),
                    position: LatLng(
                      selectedTrip!.points.last.latitude,
                      selectedTrip!.points.last.longitude,
                    ),
                  ),
                },
        compassEnabled: false,
        mapToolbarEnabled: false,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: false,
        minMaxZoomPreference: const MinMaxZoomPreference(3, 18),
      ),
    );
  }

  Set<Polyline> _buildPolylines() {
    final Set<Polyline> polylines = {};
    if (selectedTrip != null) {
      polylines.add(MapUtils.createTripPolyline(selectedTrip!));
    } else if (isRecording && points.length > 1) {
      polylines.add(MapUtils.createRecordingPolyline(points));
    }

    return polylines;
  }

  Set<Circle> _buildCircles() {
    return {
      Circle(
        circleId: const CircleId('current_location'),
        center: LatLng(currentLocation.latitude, currentLocation.longitude),
        radius: 50,
        fillColor: Colors.blueAccent.withOpacity(0.7),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    };
  }
}
