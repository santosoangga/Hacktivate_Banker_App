part of 'geo_bloc.dart';

@immutable
sealed class GeoState {}

final class GeoInitial extends GeoState {}

final class GeoLoading extends GeoState {}

final class GeoLoaded extends GeoState {
  GeoLoaded({required this.geo, this.points = const <Geo>[]});
  final Geo geo;
  final List<Geo> points;

  GeoLoaded copyWith({Geo? geo, List<Geo>? points}) {
    return GeoLoaded(geo: geo ?? this.geo, points: points ?? this.points);
  }
}

final class GeoError extends GeoState {
  GeoError({this.message});
  final String? message;
}
