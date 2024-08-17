import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:future_hub/employee/components/map_pop_up_widget.dart';
import 'package:future_hub/employee/orders/cubit/employee_punchers_cubit.dart';
import 'package:future_hub/employee/orders/models/puncher_branch.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/map_services.dart';

class MapWidget extends StatefulWidget {
  final EmployeePunchersCubit cubit;
  const MapWidget({super.key, required this.cubit});

  @override
  createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static Position? position;
  final Completer<GoogleMapController> _mapController = Completer();
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );
  Set<Marker> markers = {};
  // ignore: unused_field
  double _topPosition = -200;
  PuncherBranch? _selectedPuncher;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMyCurrentLocation();
    });
  }

  Future<Uint8List> _assetImageBytes(String asset, int width) {
    final completer = Completer<Uint8List>();
    final config = createLocalImageConfiguration(context);
    final image = AssetImage(asset);
    final stream = image.resolve(config);

    stream.addListener(ImageStreamListener((info, _) async {
      final byteData = await info.image.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      final codec = await instantiateImageCodec(bytes, targetWidth: width);
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ImageByteFormat.png);
      completer.complete(data!.buffer.asUint8List());
    }));

    return completer.future;
  }

  Future<void> getMyCurrentLocation() async {
    position = await MapServices.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
    final image = await _assetImageBytes('assets/icons/map_marker.png', 100);
    final icon = BitmapDescriptor.fromBytes(image);

    // for (final branch in widget.cubit.cubitPunchers) {
    //   markers.add(Marker(
    //     onTap: () {
    //       setState(() {
    //         _selectedPuncher = branch;
    //         _topPosition = 0;
    //       });
    //     },
    //     markerId: MarkerId("id-${branch.id}"),
    //     icon: icon,
    //     position: LatLng(double.parse(branch.latitude.toString()),
    //         double.parse(branch.latitude.toString())),
    //   ));
    // }
    setState(() {
      markers.add(
        Marker(
          onTap: () {
            setState(() {
              _selectedPuncher = widget.cubit.cubitPunchers[0];
              _topPosition = 0;
            });
          },
          markerId: MarkerId("id-${widget.cubit.cubitPunchers[0].id}"),
          icon: icon,
          position: LatLng(
            double.parse(widget.cubit.cubitPunchers[0].latitude.toString()),
            double.parse(widget.cubit.cubitPunchers[0].longitude.toString()),
          ),
        ),
      );
    });

    // markers.add(
    //   Marker(
    //     onTap: () {
    //       setState(() {
    //         _selectedPuncher = widget.cubit.cubitPunchers[2];
    //         _topPosition = 0;
    //       });
    //     },
    //     markerId: MarkerId("id-${widget.cubit.cubitPunchers[2].id}"),
    //     icon: icon,
    //     position: LatLng(
    //       double.parse(widget.cubit.cubitPunchers[2].latitude.toString()),
    //       double.parse(widget.cubit.cubitPunchers[2].longitude.toString()),
    //     ),
    //   ),
    // );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.terrain,
      myLocationEnabled: true,
      onTap: (latlng) {
        setState(() {
          _topPosition = -200;
        });
      },
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
      markers: markers,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
    setState(() {
      _topPosition = -200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
          _selectedPuncher == null
              ? Container()
              : AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  right: 0,
                  left: 0,
                  top: MediaQuery.of(context).size.height * 0.2,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MapPopUpWidget(
                      id: _selectedPuncher!.puncher.id,
                      title:
                          "${_selectedPuncher!.puncher.name}  (${_selectedPuncher!.title})",
                      imageUrl: _selectedPuncher!.puncher.imageUrl,
                      location: _selectedPuncher!.city!.title!,
                    ),
                  ),
                )
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 4, 45),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: _goToMyCurrentLocation,
          child: const Icon(Icons.place, color: Colors.white),
        ),
      ),
    );
  }
}
