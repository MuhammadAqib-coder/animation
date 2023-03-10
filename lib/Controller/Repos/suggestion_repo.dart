import 'dart:convert';
import 'dart:io';

import 'package:animation_task/Controller/Repos/status_code.dart';
import 'package:http/http.dart' as http;

class SuggestionRepo {
  Future<int> suggestionList(input) async {
    try {
      var baseUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      var apiKey = 'AIzaSyAWmPl-hWW9bxKhB0PB_8RGxS_ZZrtqEtM';
      var request = "$baseUrl?input=$input&key=$apiKey";
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        placesList = jsonDecode(response.body.toString())['predictions'];
      }
      return response.statusCode;
    } on SocketException {
      return StatusCode.socketException;
    } catch (e) {
      return StatusCode.exception;
    }
  }
}
