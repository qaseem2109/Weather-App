import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'secrets.dart';
import 'weather_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityname = 'Karachi';
  late Future<Map<String, dynamic>> weatherapp;
  Future<Map<String, dynamic>> getCurrentTemp() async {
    try {
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname,PK&APPID=$openWeatherApiKey',
        ),
      );
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occur';
      }
      return data;

    } catch (e) {
      throw e.toString();
    }
  }
  @override
  void initState(){
    super.initState();
    weatherapp = getCurrentTemp();
  }

  void cards() {
    const SizedBox(
      width: 100,
      child: Card(
        child: Column(
          children: [
            Text(
              '03:00',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Icon(
              Icons.sunny,
              size: 25,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '300.07',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          '$cityname weather ',
          style:const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherapp = getCurrentTemp();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weatherapp,
        builder: (context, snapshot) {
          // print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;
          final double currentTemp = (data['list'][0]['main']['temp'])-273.15;
          final weatherCond = data['list'][0]['weather'][0]['main'];
          final windspeed = data['list'][0]['wind']['speed'];
          final humidity = data['list'][0]['main']['humidity'];
          final pressure = data['list'][0]['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${currentTemp.toStringAsFixed(0)} °C",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Icon(
                                weatherCond == 'Cloud'
                                    ? Icons.cloud
                                    : weatherCond == 'Rain'
                                        ? Icons.grain
                                        : Icons.sunny,
                                size: 60,
                              ),
                              Text(
                                '$weatherCond ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index)  {
                      final fut_temp = data['list'][index+1]['main']['temp']-273.15;
                      final timelapse = data['list'][index+1]['dt_txt'].toString();
                      final time = DateTime.parse(timelapse);
                      return WeatherCard(
                        time: DateFormat.jm().format(time),
                        icon:
                            data['list'][index+1]['weather'][0]['main'] == 'Rain'
                                ? Icons.grain
                                : data['list'][index+1]['weather'][0]['main'] ==
                                        'Clouds'
                                    ? Icons.cloud
                                    : Icons.sunny,
                        temperature: fut_temp.toStringAsFixed(2),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Additional Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoCard(
                      text: 'humidity',
                      digit: '$humidity',
                      icon: Icons.water_drop_rounded,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AdditionalInfoCard(
                      text: 'Wind Speed',
                      digit: '$windspeed m/s',
                      icon: Icons.air_outlined,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AdditionalInfoCard(
                      text: 'Pressure',
                      digit: '$pressure',
                      icon: Icons.device_thermostat_sharp,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
