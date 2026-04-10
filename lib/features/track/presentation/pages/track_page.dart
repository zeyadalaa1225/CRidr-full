import 'dart:math';
import 'package:cridr/core/utils/constants/api_keys.dart';
import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/home/presentation/pages/home_page.dart';
import 'package:cridr/features/track/presentation/cubit/track_cubit.dart';
import 'package:cridr/features/track/presentation/cubit/track_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackPage extends StatefulWidget {
  final RequestModel request;

  const TrackPage({super.key, required this.request});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final MapController _mapController = MapController();
  LatLng? currentLocation;
  LatLng? targetLocation;
  double? etaMinutes;
  bool _mapReady = false;
  bool? iscustomer;
  bool _mapInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<TrackCubit>().getLocation(widget.request.id);
    getCurrentLocation();
    checkCustomer();
    context.read<TrackCubit>().connectToSocket();
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      currentLocation = LatLng(
        widget.request.latitude,
        widget.request.longitude,
      );
    });
  }

  Future<void> checkCustomer() async {
    String role = await LocalStorage().readData("role");
    setState(() {
      iscustomer = role == "User";
    });
  }

  void _moveMapToCurrent() {
    if (_mapReady && currentLocation != null) {
      _mapController.move(currentLocation!, 14.0);
    }
  }

  // -------------------
  // ETA calculation
  // -------------------
  double _haversineDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371000; // earth radius in m
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final dPhi = (lat2 - lat1) * pi / 180;
    final dLambda = (lon2 - lon1) * pi / 180;

    final a =
        pow(sin(dPhi / 2), 2) +
        cos(phi1) * cos(phi2) * pow(sin(dLambda / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _estimateEtaMinutes(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
    double speedKmh,
  ) {
    final distance = _haversineDistanceMeters(lat1, lon1, lat2, lon2);
    final speedMs = (speedKmh * 1000) / 3600;
    final seconds = distance / speedMs;
    return seconds / 60; // minutes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TrackCubit, TrackState>(
        listener: (context, state) {
          if (state is LocationLoaded && currentLocation != null) {
            final cubit = context.read<TrackCubit>();
            setState(() {
              targetLocation = LatLng(cubit.lat, cubit.long);
              etaMinutes = _estimateEtaMinutes(
                currentLocation!.latitude,
                currentLocation!.longitude,
                targetLocation!.latitude,
                targetLocation!.longitude,
                40, // assume 40 km/h
              );
            });
            _moveMapToCurrent();
          } else if (state is RequestCompleted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Request Completed")));
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  HomePage()), (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          if (state is LocationLoading || currentLocation == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LocationError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (targetLocation == null) {
            return const Center(
              child: Text("Waiting for provider location..."),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentLocation!,
                  initialZoom: 14,
                  onMapReady: () {
                    setState(() => _mapReady = true);
                    _moveMapToCurrent();
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$Map_API_KEY",
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: currentLocation!,
                        child: const Icon(
                          Icons.person_pin_circle,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      Marker(
                        width: 40,
                        height: 40,
                        point: targetLocation!,
                        child: const Icon(
                          Icons.directions_car,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [currentLocation!, targetLocation!],
                        strokeWidth: 4,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
              if (etaMinutes != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Estimated arrival: ${etaMinutes!.toStringAsFixed(1)} min",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    iscustomer == null || iscustomer == false
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<TrackCubit>(
                                    context,
                                  ).completeRequest(widget.request.id);
                                },
                                child: const Text(
                                  "complete request",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
