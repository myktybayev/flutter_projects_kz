import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON парсинг үшін

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather API App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherApiPage(),
    );
  }
}

class WeatherApiPage extends StatefulWidget {
  @override
  _WeatherApiPageState createState() => _WeatherApiPageState();
}

class _WeatherApiPageState extends State<WeatherApiPage> {
  final TextEditingController _cityController = TextEditingController();

  String? _weatherInfo;   // Ауа райы мәліметін сақтайтын орын (мысалы: "25°C, ашық аспан")
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _fetchWeather() async {
    String city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        _errorMessage = 'Қала атауын енгізіңіз'; // Егер өріс бос болса
        _weatherInfo = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Төмендегі API URL-ді өз қажеттіліктеріңізге қарай түзетіңіз.
      // "YOUR_API_KEY" орнына OpenWeatherMap-тан алған кілтіңізді қойыңыз.
      String apiKey = 'a0ee119aac0534b3191dd8462ad45ae0';
      String url = 'https://api.openweathermap.org/data/2.5/weather?q=${Uri.encodeComponent(city)}&units=metric&lang=ru&appid=$apiKey';
      // NOTE: lang=ru параметрі жауапты орыс тілінде алуға қойылған (қазақ тілінде қолжетімді болмауы мүмкін, сондықтан орысша немесе ағылшынша аламыз).
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // JSON жауапты Dart құрылымына айналдыру
        final data = jsonDecode(response.body);
        // Негізгі қажетті деректерді шығарамыз: температура және сипаттама
        double temp = data['main']['temp']; // температура (Цельсий)
        String desc = data['weather'][0]['description']; // ауа райының сипаттамасы
        // Бірінші әріпін бас әріпке өзгертіп қояйық (әдемілік үшін):
        if (desc.isNotEmpty) {
          desc = desc[0].toUpperCase() + desc.substring(1);
        }
        // Мәліметтерді сақтап қоямыз
        setState(() {
          _weatherInfo = '${city[0].toUpperCase()}${city.substring(1)}: ${temp.toStringAsFixed(1)}°C, $desc';
          _errorMessage = null;
        });
      } else if (response.statusCode == 404) {
        // Қала табылмады деген жауап
        setState(() {
          _errorMessage = 'Қала табылмады немесе атауы қате';
          _weatherInfo = null;
        });
      } else {
        // Басқа қандай да бір қате
        setState(() {
          _errorMessage = 'Қате коды: ${response.statusCode}. Қайтадан байқап көріңіз.';
          _weatherInfo = null;
        });
      }
    } catch (e) {
      // Интернет байланысы жоқ немесе басқа техникалық қате болса
      setState(() {
        _errorMessage = 'Интернет қате немесе жауап алу мүмкін болмады';
        _weatherInfo = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ауа райы (API)')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Қала атауын енгізу өрісі және іздеу батырмасы
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: 'Қала атауы'),
                    onSubmitted: (_) => _fetchWeather(), // Enter басылса 
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: Text('Ауа райын қарау'),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Нәтиже бөлімі
            if (_isLoading)
              Center(child: CircularProgressIndicator()) // Жүктелу көрсеткіші
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            else if (_weatherInfo != null)
              Text(
                _weatherInfo!,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              )
            else
              Text('Қала атауын енгізіп, ауа райын тексеріңіз'),
          ],
        ),
      ),
    );
  }
}
