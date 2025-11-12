import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// Негізгі қолданба виджеті - MaterialApp арқылы бастапқы бет ретінде CounterPage көрсетіледі.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterPage(), // Бастапқы экран - CounterPage
    );
  }
}

/// CounterPage – StatefulWidget, себебі мұнда күй (сан мәні) өзгеріп отырады.
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

/// StatefulWidget-тің күй классы
class _CounterPageState extends State<CounterPage> {
  int _counter = 0; // Санақты сақтайтын күй айнымалысы, бастапқысы 0.

  /// Бұл функция батырма басылғанда шақырылады – санағышты 1-ге арттырады.
  void _incrementCounter() {
    setState(() {
      _counter++; // _counter мәнін бір бірлікке өсіреміз
    });
    // setState() шақырылған соң Flutter автоматты түрде build() методын қайта шақырып,
    // экранды жаңартады, сондықтан ортасында көрсетілген сан мәні өзгеретін болады.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter қолданбасы'), // Қолданба тақырыбы
      ),
      body: Center(
        child: Text(
          'Санағыш мәні: $_counter',
          style: TextStyle(fontSize: 32),
        ), // Ортасында санның ағымдағы мәнін көрсететін мәтін
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Батырма басылғанда санағышты арттыру функциясын шақыру
        child: Icon(Icons.add),
        tooltip: 'Санағышты 1-ге арттыру', // Батырманы ұзақ басқанда көрінетін көмекші жазу
      ),
    );
  }
}
