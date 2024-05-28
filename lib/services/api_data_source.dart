import 'package:weather/model/weather_model.dart';
import 'base_network.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<List<dynamic>> loadWeatherData() async {
    const String fullUrl =
        'https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json';
    final response = await http.get(Uri.parse(fullUrl));
    final body = response.body;
    if (body.isNotEmpty) {
      return json.decode(body);
    } else {
      throw Exception('Failed to load data');
    }
    // if (response.containsKey("error")) {
    //   throw Exception("Failed to load weather data");
    // }
    // List<dynamic> data = response as List;
    // return data.map((item) => WeatherModel.fromJson(item)).toList();
  }

  Future<List<dynamic>> loadWeatherDetail(String id) async {
    const String baseUrl = "https://ibnux.github.io/BMKG-importer/cuaca";
    final String fullUrl = "$baseUrl/$id.json";
    final response = await http.get(Uri.parse(fullUrl));
    final body = response.body;
    if (body.isNotEmpty) {
      return json.decode(body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  //   final response = await BaseNetwork.get("cuaca/$id.json");
  //   if (response.containsKey("error")) {
  //     throw Exception("Failed to load weather detail");
  //   }
  //   return json.decode(response);
  // }
}
