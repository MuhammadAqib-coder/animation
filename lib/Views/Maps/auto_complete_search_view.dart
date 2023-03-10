import 'package:animation_task/Controller/Cubits/suggetionCubit/suggesion_cubit.dart';
import 'package:animation_task/Controller/Cubits/suggetionCubit/suggestion_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../Controller/Repos/status_code.dart';

class AutoCompleteSearchView extends StatefulWidget {
  const AutoCompleteSearchView({super.key});
  //  VoidCallback onPressed(){}

  @override
  State<AutoCompleteSearchView> createState() => _AutoCompleteSearchViewState();
}

class _AutoCompleteSearchViewState extends State<AutoCompleteSearchView> {
  var destinationAddress = TextEditingController();
  var myAddress = TextEditingController();
  // var _placesList = [];
  var focusNode = FocusNode();
  String destination = '';
  String source = '';
  Position? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    destinationAddress.addListener(() {
      isDestination = true;
      onChange();
    });
    myAddress.addListener(() {
      isDestination = false;
      onChange();
    });
  }

  onChange() {
    // if (_sessionToken == null) {
    //   setState(() {
    //     _sessionToken = uid.v4();
    //   });
    // }
    getSuggesion(
        isDestination ? destinationAddress.text.trim() : myAddress.text.trim());
  }

  getSuggesion(String text) async {
    context.read<SuggesionCubit>().getSuggesionList(text);
  }

  bool isDestination = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        actions: [
          TextButton(
              onPressed: () {
                if (destinationAddress.text.isNotEmpty &&
                    myAddress.text.isNotEmpty) {
                  Navigator.pop(context, [destination, source, position]);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('enter something')));
                }
              },
              child: const Text("Search"))
        ],
        title: const Text("search with place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: destinationAddress,
              decoration: InputDecoration(
                  hintText: 'destination Place',
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          BorderSide(color: Colors.black, width: 2.sp))),
            ),
            SizedBox(
              height: 5.h,
            ),
            TextField(
                controller: myAddress,
                decoration: InputDecoration(
                    hintText: 'source place',
                    isDense: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.sp)))),
            SizedBox(
              height: 1.h,
            ),
            const Text("OR"),
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      try {
                        await _determinePosition();
                        var placeMarkers = await placemarkFromCoordinates(
                            position!.latitude, position!.longitude);
                        // print(placeMarkers);
                        myAddress.text =
                            "${placeMarkers.first.name!} ${placeMarkers.first.locality!} ${placeMarkers.first.country!}";
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    )),
                SizedBox(
                  width: 4.w,
                ),
                const Text('Your current location')
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(child: BlocBuilder<SuggesionCubit, SuggesionState>(
                builder: (context, state) {
              if (state is SuggesionLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SuggesionLoadedState) {
                return ListView.builder(
                    itemCount: placesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: isDestination
                            ? () {
                                destinationAddress.text =
                                    placesList[index]['description'];
                                destination = placesList[index]['description'];
                              }
                            : () {
                                myAddress.text =
                                    placesList[index]['description'];
                                source = placesList[index]['description'];
                              },
                        title: Text(placesList[index]['description']),
                      );
                    });
              }
              if (state is SuggesionSocketExceptionState) {
                return const Center(
                  child: Text("No Internet"),
                );
              }
              return const SizedBox(
                height: 0,
                width: 0,
              );
            }))
          ],
        ),
      ),
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      position = await Geolocator.getCurrentPosition();
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

    position = await Geolocator.getCurrentPosition();
  }
}
