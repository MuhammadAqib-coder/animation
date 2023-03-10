import 'dart:async';

import 'package:animation_task/Controller/Cubits/nearSearchCubit/near_search_state.dart';
import 'package:animation_task/Controller/Cubits/timedistanceCubit/time_distance_cubit.dart';
import 'package:animation_task/Controller/Cubits/timedistanceCubit/time_distance_state.dart';
import 'package:animation_task/Controller/Repos/status_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Controller/Cubits/nearSearchCubit/near_search_cubit.dart';
import 'auto_complete_search_view.dart';

class GoogleMapPractice extends StatefulWidget {
  const GoogleMapPractice({super.key});

  @override
  State<GoogleMapPractice> createState() => _GoogleMapPracticeState();
}

class _GoogleMapPracticeState extends State<GoogleMapPractice> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  List<LatLng> polylineCoordinates = [];
  var markerCounter = 0;
  final Set<Marker> _markers = <Marker>{};
  // Position? currentPosition;
  var lat, lng;
  // final Set<Polyline> _polyline = {};
  // final Set<Marker> _markers = {};
  // LatLng? sourceDistination;
  var source = ValueNotifier<Position>(const Position(
      longitude: 71.5249,
      latitude: 34.0151,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0));
  LatLng endDistination =
      const LatLng(0, 0); //= const LatLng(33.9984, 71.5391);
  var distance = ValueNotifier<String>("");
  var time = ValueNotifier<String>("");
  // List<LatLng> latlng = [];
  final LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      intervalDuration: const Duration(seconds: 1));
  StreamSubscription<Position>? positionStream;
  var showSearch = ValueNotifier<bool>(false);
  var controller = TextEditingController();

  // var uid = const Uuid();
  // String? _sessionToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.add(Marker(
        position: LatLng(source.value.latitude, source.value.longitude),
        markerId: MarkerId(markerCounter.toString())));
    markerCounter++;

    // getPosition();
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((event) async {
      // setState(() {
      // currentPosition = event;
      // lat = currentPosition!.latitude;
      // lng = currentPosition!.longitude;
      // sourceDistination = LatLng(lat, lng);
      // });
      // source.value = event;
      // await getPointes();

      // sourceDistination = LatLng(source.value.latitude, source.value.longitude);
    });
  }

  getPosition() async {
    // if (source.value.latitude == 0) {
    await _determinePosition();
    // setState(() {});
    // sourceDistination = LatLng(source.value.latitude, source.value.longitude);
    // }
    // if (currentPosition != null) {
    // lat = currentPosition!.latitude;
    // lng = currentPosition!.longitude;
    // sourceDistination = LatLng(lat, lng);

    // var response = await http.get(Uri.parse(
    //     "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${endDistination.latitude},${endDistination.longitude}&origins=${source.value.latitude},${source.value.longitude}&key=AIzaSyAWmPl-hWW9bxKhB0PB_8RGxS_ZZrtqEtM"));
    // var decode = await json.decode(response.body);
    // distance.value = decode['rows'][0]['elements'][0]['distance']['text'];
    // time.value = decode['rows'][0]['elements'][0]['duration']['text'];
    // }
    // setState(() {});

    // await getPointes();
  }

  getPointes() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      avoidHighways: true,
      optimizeWaypoints: true,

      "AIzaSyAWmPl-hWW9bxKhB0PB_8RGxS_ZZrtqEtM", // Your Google Map Key
      PointLatLng(source.value.latitude, source.value.longitude),
      PointLatLng(endDistination.latitude, endDistination.longitude),
    );
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      context.read<TimeDistanceCubit>().getTimeDistance(endDistination, source);
      // var response = await http.get(Uri.parse(
      //     "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${endDistination.latitude},${endDistination.longitude}&origins=${source.value.latitude},${source.value.longitude}&key=AIzaSyAWmPl-hWW9bxKhB0PB_8RGxS_ZZrtqEtM"));
      // var decode = await json.decode(response.body);
      // distance.value = decode['rows'][0]['elements'][0]['distance']['text'];
      // time.value = decode['rows'][0]['elements'][0]['duration']['text'];

      setState(() {});
    }
  }

  // nearSearchPlaces() async {
  //   var response = await http.get(Uri.parse(
  //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=${sourceDistination!.latitude},${sourceDistination!.longitude}&type=restaurant&key=AIzaSyAWmPl-hWW9bxKhB0PB_8RGxS_ZZrtqEtM'));
  //   var body = await json.decode(response.body);
  //   print(body);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: ValueListenableBuilder(
            valueListenable: showSearch,
            builder: (context, value, child) {
              if (value) {
                return IconButton(
                    onPressed: () {
                      showSearch.value = !showSearch.value;
                    },
                    icon: const Icon(Icons.arrow_back));
              } else {
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
              }
            },
          ),
          title: ValueListenableBuilder(
            valueListenable: showSearch,
            builder: (context, value, child) {
              if (value) {
                return TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'restuarant, hospital etc',
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.sp))),
                );
              } else {
                return const Text('Google Maps Flutter');
              }
            },
          ),
          actions: [
            ValueListenableBuilder(
              valueListenable: showSearch,
              builder: (context, value, child) {
                if (value) {
                  return TextButton(
                      onPressed: () async {
                        if (controller.text.isNotEmpty) {
                          try {
                            await getPosition();
                            await context.read<NearSearchCubit>().getNearPlaces(
                                controller.text.trim(),
                                source.value.latitude,
                                source.value.longitude);
                            controller.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                      child: BlocConsumer<NearSearchCubit, NearSearchState>(
                          listener: (context, state) async {
                        if (state is NearSearchLoadedState) {
                          _markers.clear();
                          markerCounter = 0;
                          nearPlaces.forEach((map) {
                            var location = map['geometry']['location'];
                            var lat = location['lat'];
                            var lng = location['lng'];
                            _markers.add(Marker(
                                markerId: MarkerId(markerCounter.toString()),
                                position: LatLng(lat, lng)));
                            markerCounter++;
                          });
                          setState(() {});
                          final GoogleMapController googleMapController =
                              await _controller.future;
                          googleMapController.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  zoom: 14,
                                  target: LatLng(source.value.latitude,
                                      source.value.longitude))));
                        }
                      }, builder: (context, state) {
                        if (state is NearSearchLoadingState) {
                          return const CircularProgressIndicator();
                        }
                        return const Text("Search");
                      }));
                } else {
                  return IconButton(
                      onPressed: () {
                        showSearch.value = !showSearch.value;
                      },
                      icon: const Icon(Icons.search));
                }
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AutoCompleteSearchView()));
            if (!mounted) return;
            if (result != null) {
              var firstLocation = await locationFromAddress(result[0]);

              if (result[1].isNotEmpty) {
                var secondLocation = await locationFromAddress(result[1]);
                source.value = Position(
                    accuracy: 0,
                    altitude: 0,
                    timestamp: secondLocation[0].timestamp,
                    heading: 0,
                    speed: 0,
                    speedAccuracy: 0,
                    latitude: secondLocation[0].latitude,
                    longitude: secondLocation[0].longitude);
              } else {
                Position position = result[2];
                source.value = position;
              }
              endDistination =
                  LatLng(firstLocation[0].latitude, firstLocation[0].longitude);
              markerCounter = 0;
              _markers.clear();
              _markers.add(Marker(
                  infoWindow: const InfoWindow(
                      title: "source", snippet: 'your location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta),
                  markerId: MarkerId(markerCounter.toString()),
                  position:
                      LatLng(source.value.latitude, source.value.longitude)));
              markerCounter++;
              _markers.add(Marker(
                  infoWindow: const InfoWindow(
                      title: 'destination', snippet: 'your end'),
                  markerId: MarkerId(markerCounter.toString()),
                  position: endDistination));
              markerCounter++;
              await getPointes();
              final GoogleMapController controller = await _controller.future;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(source.value.latitude, source.value.longitude),
                zoom: 14,
              )));
            }
          },
          child: const Icon(Icons.search),
        ),
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                padding: EdgeInsets.all(10.sp),
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                indoorViewEnabled: true,
                trafficEnabled: true,
                mapType: MapType.normal,
                markers: _markers,
                polylines: {
                  Polyline(
                      polylineId: const PolylineId('route'),
                      points: polylineCoordinates,
                      width: 8,
                      color: Colors.blue)
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(source.value.latitude, source.value.longitude),
                    zoom: 14.4),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.green,
              ),
              title: const Text("Yours Journey"),
              subtitle: BlocBuilder<TimeDistanceCubit, TimeDistanceState>(
                  builder: (context, state) {
                if (state is TimeDistanceLoadedState) {
                  return Text(
                    "$totalDistance - $totalTime",
                  );
                }
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
              }),
            )
          ],
        ));
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      source.value = await Geolocator.getCurrentPosition();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    source.value = await Geolocator.getCurrentPosition();
  }
}
