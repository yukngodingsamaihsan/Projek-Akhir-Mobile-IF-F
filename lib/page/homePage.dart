import 'package:flutter/material.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/services/api_data_source.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<WeatherModel>> _weatherData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Data'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiDataSource.instance.loadWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final weather = snapshot.data![index];
                return ListTile(
                  title: Text(weather['kota'] ?? 'Unknown City'),
                  subtitle:
                      Text('Province: ${weather['propinsi'] ?? 'Unknown'}\n'
                          'District: ${weather['kecamatan'] ?? 'Unknown'}\n'
                          'Latitude: ${weather['lat'] ?? 'Unknown'}\n'
                          'Longitude: ${weather['lon'] ?? 'Unknown'}\n'),
                  onTap: () => _navigateToDetailPage(context, weather['id']),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context, String? id) {
    if (id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailPage(id: id),
        ),
      );
    }
  }
}

class WeatherDetailPage extends StatelessWidget {
  final String id;

  WeatherDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Detail'),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: ApiDataSource.instance.loadWeatherDetail(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final weather = snapshot.data![index];
                  return ListTile(
                    title: Text(weather['jamCuaca'] ?? 'Unknown'),
                    subtitle: Text(
                        'Kode Cuaca: ${weather['kodeCuaca'] ?? 'Unknown'}\n'
                        'Cuaca: ${weather['cuaca'] ?? 'Unknown'}\n'
                        'Humidity: ${weather['humidity'] ?? 'Unknown'}\n'
                        'Temperatur Celcius: ${weather['tempC'] ?? 'Unknown'}\n'
                        'Temperatur Fahrenheit ${weather['tempF'] ?? 'Unknown'}\n'),
                  );
                },
              );
            }
          }),
    );
  }
}
