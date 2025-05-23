import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:h8_fli_geo_maps_starter/components/geo_control_buttons.dart';
import 'package:h8_fli_geo_maps_starter/components/geo_map.dart';
import 'package:h8_fli_geo_maps_starter/components/trip_details_card.dart';
import 'package:h8_fli_geo_maps_starter/constants/map_styles.dart';
import 'package:h8_fli_geo_maps_starter/manager/geo_bloc.dart';
import 'package:h8_fli_geo_maps_starter/manager/history_bloc.dart';
import 'package:h8_fli_geo_maps_starter/model/geo.dart';
import 'package:h8_fli_geo_maps_starter/model/history.dart';
import 'package:h8_fli_geo_maps_starter/utils/map_utils.dart';

class GeoView extends StatefulWidget {
  const GeoView({super.key});

  @override
  State<GeoView> createState() => _GeoViewState();
}

class _GeoViewState extends State<GeoView> {
  // Initial position - could be moved to a constants file
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-6.3021047, 106.6499596),
    zoom: 14,
  );

  GoogleMapController? _controller;
  bool _followCurrentLocation = true;
  String? _currentTripId;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _updateCameraPosition(Geo geo) {
    if (_controller != null && _followCurrentLocation) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(geo.latitude, geo.longitude), zoom: 14),
        ),
      );
    }
  }

  void _handleMapCreated(GoogleMapController controller) {
    _controller = controller;
    controller.setMapStyle(darkMapStyle);
  }

  void _handleTripCentering(Trip trip) {
    // Only center if it's a new trip
    if (_currentTripId != trip.date.toString()) {
      _followCurrentLocation = false;
      _currentTripId = trip.date.toString();

      if (_controller != null) {
        MapUtils.centerCameraOnTrip(_controller!, trip);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeoBloc, GeoState>(
      listener: (context, state) {
        if (state is GeoLoaded) {
          _updateCameraPosition(state.geo);
        }
      },
      builder: (context, geoState) {
        return BlocConsumer<HistoryBloc, HistoryState>(
          listener:(context, state) {
            // Simplified listener logic
            context.read<GeoBloc>().add(
              state is HistoryStartRecording
                ? GeoStartRealtimeEvent()
                : GeoStopRealtimeEvent()
            );
          },
          builder: (context, historyState) {
            final isRecording = historyState is HistoryStartRecording;
            final selectedTrip = historyState is HistoryTripSelected
                ? historyState.selectedTrip
                : null;

            // Handle trip selection and camera centering
            if (selectedTrip != null) {
              _handleTripCentering(selectedTrip);
            } else {
              _currentTripId = null;
            }

            return Scaffold(
              body: _buildBody(geoState, selectedTrip, isRecording),
              floatingActionButton: selectedTrip == null
                  ? GeoControlButtons(isRecording: isRecording)
                  : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            );
          },
        );
      },
    );
  }

  Widget _buildBody(GeoState geoState, Trip? selectedTrip, bool isRecording) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 50.0,
          bottom: 16.0,
        ),
        child: switch (geoState) {
          GeoInitial() => const SizedBox(),
          GeoLoading() => const CircularProgressIndicator(),
          GeoLoaded() => _buildMapStack(geoState, selectedTrip, isRecording),
          GeoError() => Text('${geoState.message}'),
        },
      ),
    );
  }

  Widget _buildMapStack(GeoLoaded state, Trip? selectedTrip, bool isRecording) {
    return Stack(
      children: [
        GeoMap(
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: _handleMapCreated,
          currentLocation: state.geo,
          points: state.points,
          selectedTrip: selectedTrip,
          isRecording: isRecording,
        ),
        if (selectedTrip != null)
          Positioned(
            top: 10,
            right: 10,
            child: TripDetailsCard(
              trip: selectedTrip,
              onClose: () {
                context.read<HistoryBloc>().add(
                  HistoryCloseSelectedTripEvent(),
                );
                setState(() {
                  _followCurrentLocation = true;
                  _updateCameraPosition(state.geo);
                });
              },
            ),
          ),
      ],
    );
  }
}
