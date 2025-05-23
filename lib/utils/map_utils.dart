import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:h8_fli_geo_maps_starter/model/geo.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';

class MapUtils {
  // Cache for polylines with size limit to prevent memory issues
  static final Map<String, Polyline> _polylineCache = {};
  static const int _maxCacheSize = 50;

  /// Center the camera on a trip's points by calculating bounds
  static Future<void> centerCameraOnTrip(GoogleMapController controller, Trip trip) async {
    if (trip.points.isEmpty) return;

    try {
      double minLat = double.infinity;
      double maxLat = -double.infinity;
      double minLng = double.infinity;
      double maxLng = -double.infinity;

      // Single pass bounds calculation
      for (final point in trip.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      // Add padding proportional to the area size
      final latDelta = maxLat - minLat;
      final lngDelta = maxLng - minLng;
      final padding = math.max(latDelta, lngDelta) * 0.15;

      final bounds = LatLngBounds(
        southwest: LatLng(minLat - padding, minLng - padding),
        northeast: LatLng(maxLat + padding, maxLng + padding),
      );

      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    } catch (e) {
      log("Error centering camera on trip: $e");
    }
  }

  /// Create a polyline for a selected trip with caching
  static Polyline createTripPolyline(Trip trip) {
    final tripId = trip.date.toString();

    // Return cached polyline if available
    if (_polylineCache.containsKey(tripId)) {
      return _polylineCache[tripId]!;
    }

    // Create new polyline
    final polyline = Polyline(
      polylineId: PolylineId('history_$tripId'),
      color: Colors.green.withOpacity(0.7),
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      width: 10,
      points: trip.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
    );

    // Manage cache size
    if (_polylineCache.length >= _maxCacheSize) {
      _polylineCache.remove(_polylineCache.keys.first);
    }

    // Cache the polyline
    _polylineCache[tripId] = polyline;
    return polyline;
  }

  /// Create polylines for multiple trips efficiently
  static Set<Polyline> createTripPolylines(List<Trip> trips) {
    return trips.map((trip) => createTripPolyline(trip)).toSet();
  }

  /// Create a polyline for current recording
  static Polyline createRecordingPolyline(List<Geo> points) {
    return Polyline(
      polylineId: const PolylineId('current_polyline'),
      color: Colors.redAccent.withOpacity(0.7),
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      width: 5,
      points: points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
    );
  }

  /// Optimized distance calculation using haversine formula
  static double calculateDistance(Trip trip) {
    if (trip.points.length <= 1) return 0;

    double totalDistance = 0;
    const double R = 6371; // Earth radius in kilometers
    const double toRad = math.pi / 180.0;

    for (int i = 0; i < trip.points.length - 1; i++) {
      final p1 = trip.points[i];
      final p2 = trip.points[i + 1];

      final double lat1 = p1.latitude * toRad;
      final double lat2 = p2.latitude * toRad;
      final double dLat = (p2.latitude - p1.latitude) * toRad;
      final double dLon = (p2.longitude - p1.longitude) * toRad;

      final double sinDLat = math.sin(dLat / 2);
      final double sinDLon = math.sin(dLon / 2);

      final double a = sinDLat * sinDLat +
          math.cos(lat1) * math.cos(lat2) * sinDLon * sinDLon;

      final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      totalDistance += R * c;
    }

    return totalDistance;
  }

  /// Clear polyline cache to prevent memory leaks
  static void clearCache() {
    _polylineCache.clear();
  }
}
