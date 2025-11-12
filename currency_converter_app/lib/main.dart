import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(primarySwatch: Colors.green),
      home: CurrencyConverterPage(),
    );
  }
}

enum ConversionDirection { USD_TO_KZT, KZT_TO_USD }

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  ConversionDirection _direction = ConversionDirection.USD_TO_KZT;
  bool _isLoading = false;
  String? _result;
  String? _error;

  final String _accessKey = '3a0c0b894488d165b327c2f5646d7eeb'; // 👈 Мұнда нақты кілтіңізді қойыңыз

  Future<void> _convertCurrency() async {
    double? amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null) {
      setState(() {
        _error = 'Дұрыс сан енгізіңіз';
        _result = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      String fromCurrency, toCurrency;
      if (_direction == ConversionDirection.USD_TO_KZT) {
        fromCurrency = 'USD';
        toCurrency = 'KZT';
      } else {
        fromCurrency = 'KZT';
        toCurrency = 'USD';
      }

      // 🔑 access_key параметрі міндетті
      String url =
          'https://api.exchangerate.host/convert?access_key=$_accessKey&from=$fromCurrency&to=$toCurrency&amount=$amount';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Егер нәтижесі бар болса
        if (data['result'] != null) {
          double resultValue = (data['result'] as num).toDouble();
          setState(() {
            _result = '$amount $fromCurrency = ${resultValue.toStringAsFixed(2)} $toCurrency';
          });
        } else {
          // Fallback: USD->KZT бағамын кері есептеп шығару
          if (fromCurrency == 'KZT' && toCurrency == 'USD') {
            String fallbackUrl =
                'https://api.exchangerate.host/convert?access_key=$_accessKey&from=USD&to=KZT&amount=1';
            final fallbackResponse = await http.get(Uri.parse(fallbackUrl));

            if (fallbackResponse.statusCode == 200) {
              final fallbackData = jsonDecode(fallbackResponse.body);
              if (fallbackData['result'] != null) {
                double kztPerUsd = (fallbackData['result'] as num).toDouble();
                double reverseRate = amount / kztPerUsd;

                setState(() {
                  _result = '$amount KZT = ${reverseRate.toStringAsFixed(2)} USD';
                });
                return;
              }
            }
          }

          setState(() {
            _error = 'Айырбастау мүмкін болмады';
          });
        }
      } else {
        setState(() {
          _error = 'Қате: сервер код ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Интернет немесе байланыс қатесі орын алды';
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
      appBar: AppBar(title: Text('Валюта конвертері')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Сома', hintText: 'мысалы, 100'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Column(
              children: [
                RadioListTile<ConversionDirection>(
                  title: Text('USD -> KZT'),
                  value: ConversionDirection.USD_TO_KZT,
                  groupValue: _direction,
                  onChanged: (ConversionDirection? value) {
                    if (value != null) {
                      setState(() {
                        _direction = value;
                      });
                    }
                  },
                ),
                RadioListTile<ConversionDirection>(
                  title: Text('KZT -> USD'),
                  value: ConversionDirection.KZT_TO_USD,
                  groupValue: _direction,
                  onChanged: (ConversionDirection? value) {
                    if (value != null) {
                      setState(() {
                        _direction = value;
                      });
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text('Айырбастау'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red, fontSize: 16))
            else if (_result != null)
              Text(_result!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
