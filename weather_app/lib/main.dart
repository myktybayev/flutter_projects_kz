import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// MaterialApp арқылы WeatherUI беті көрсетіледі.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather UI',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: WeatherUI(),
    );
  }
}

/// Статикалық ауа райы интерфейсін көрсететін бет
class WeatherUI extends StatelessWidget {
  // Мысал үшін статикалық мәндер
  final String city = 'Алматы';
  final String description = 'Ашық аспан'; // ауа райы сипаттамасы
  final double temperature = 25.0; // температура (мысалы, 25°C)
  final double windSpeed = 5.2; // жел м/с
  final int humidity = 30; // ылғалдылық пайызбен

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ауа райы')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Барлық элементтерді ортасына орналастыру
          children: [
            Text(
              city,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Ауа райы белгішесі мен температураны қатар қою үшін Row қолданамыз
            Row(
              mainAxisSize: MainAxisSize.min, // мазмұнына сәйкес өлшем
              children: [
                Icon(Icons.wb_sunny, size: 64, color: Colors.orange), // Күннің пиктограммасы
                SizedBox(width: 10),
                Text(
                  '${temperature.toStringAsFixed(1)}°C', // температура мәні, мысалы "25.0°C"
                  style: TextStyle(fontSize: 56, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            // Қосымша ақпарат: жел жылдамдығы мен ылғалдылықты бір қатарда көрсету
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('💨 Жел: ${windSpeed.toStringAsFixed(1)} м/с', style: TextStyle(fontSize: 16)),
                  Text('💧 Ылғал: $humidity%', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
