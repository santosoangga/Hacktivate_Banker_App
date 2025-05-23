import 'package:h8_fli_geo_maps_starter/model/geo.dart';

class History {
  final List<Trip> trips;
  History({required this.trips});
}

class Trip {
  final DateTime date;
  final List<Geo> points;

  Trip({required this.date, required this.points});
}
