import 'dart:convert';
import 'dart:io';

import 'package:animation_task/Controller/Repos/status_code.dart';
import 'package:http/http.dart' as http;

class TimeDistanceRepo {
  Future getTimedistance(endDistination, source) async {
    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${endDistination.latitude},${endDistination.longitude}&origins=${source.value.latitude},${source.value.longitude}&key=AIzaSyAWmPl-hWW9bxKhB0PB_8RGxS_ZZrtqEtM"));
      if (response.statusCode == 200) {
        var decode = await json.decode(response.body);
        totalDistance = decode['rows'][0]['elements'][0]['distance']['text'];
        totalTime = decode['rows'][0]['elements'][0]['duration']['text'];
      }
      return response.statusCode;
    } on SocketException {
      return StatusCode.socketException;
    } catch (e) {
      return StatusCode.exception;
    }
  }
}
