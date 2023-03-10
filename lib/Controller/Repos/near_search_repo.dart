import 'dart:convert';
import 'dart:io';

import 'package:animation_task/Controller/Repos/status_code.dart';
import 'package:http/http.dart' as http;

class NearSearchRepo {
  getNearPlaces(String type, lat, lng) async {
    try {
      type = type.replaceAll(" ", "_");
      var baseUrl =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
      var apiKey = 'AIzaSyAWmPl-hWW9bxKhB0PB_8RGxS_ZZrtqEtM';
      var request =
          "$baseUrl?location=$lat%2C$lng&radius=1500&type=$type&key=$apiKey";
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        nearPlaces = await jsonDecode(response.body)['results'];
      }
      return response.statusCode;
    } on SocketException {
      return StatusCode.socketException;
    } catch (e) {
      return StatusCode.exception;
    }
  }
}
