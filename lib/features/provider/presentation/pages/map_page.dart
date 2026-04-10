import 'package:cridr/core/utils/constants/api_keys.dart';
import 'package:cridr/core/utils/constants/colors.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_cubit.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_state.dart';
import 'package:cridr/features/home/presentation/pages/vehicle_information.dart';
import 'package:cridr/features/provider/presentation/cubit/provider_cubit.dart';
import 'package:cridr/features/provider/presentation/cubit/provider_state.dart';
import 'package:cridr/features/provider/presentation/pages/pending_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? currentLocation;
  LatLng? selectedLocation;
  bool isChangingLocation = false;
  initState() {
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permissions are denied")),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permissions are permanently denied")),
      );
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      selectedLocation = currentLocation;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //ensures that the map is rendered before moving the camera
      _mapController.move(currentLocation!, 16.0);
    });
  }

  void _onMapTap(LatLng latlng) {
    if (isChangingLocation) {
      setState(() {
        selectedLocation = latlng;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderCubit, ProviderState>(
      listener: (context, state) {
        if (state is update_location_success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PendingRequest()),
          );
        } else if (state is update_location_error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },

      child: Scaffold(
        body: currentLocation == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: currentLocation!,
                      initialZoom: 16.0,
                      onTap: (tapPosition, latlng) => _onMapTap(latlng),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=${Map_API_KEY}",
                        userAgentPackageName: 'com.example.app',
                      ),
                      if (selectedLocation != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: selectedLocation!,
                              child: Icon(
                                Icons.location_pin,
                                size: 40,
                                color: Color(0xffAF99CC),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Confirm the location is correct",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Location confirmed")),
                              );
                              print(selectedLocation);
                              setState(() {
                                isChangingLocation = false;
                                BlocProvider.of<ProviderCubit>(
                                  context,
                                ).updateLocation(selectedLocation!);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ZColors.primaryColor,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("Confirm Location"),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isChangingLocation = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Text(
                              "Change Location",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
