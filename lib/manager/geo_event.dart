part of 'geo_bloc.dart';

@immutable
sealed class GeoEvent {}

class GeoInitEvent extends GeoEvent {}

class GeoGetLocationEvent extends GeoEvent {}

class GeoStartRealtimeEvent extends GeoEvent {}

class GeoStopRealtimeEvent extends GeoEvent {}

class GeoUpdateLocationEvent extends GeoEvent {
  GeoUpdateLocationEvent(this.geo);
  final Geo geo;
}

// New event to clear tracked points
class GeoClearPointsEvent extends GeoEvent {}
