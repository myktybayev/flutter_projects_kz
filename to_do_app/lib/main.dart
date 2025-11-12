import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// MaterialApp іске қосылады, бастапқы бет ретінде TodoPage беріледі.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do қолданбасы',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TodoPage(),
    );
  }
}

/// Тапсырмалар тізімі беті – StatefulWidget, себебі тізімге элементтер қосылған сайын өзгеріп, қайта сызылуы керек.
class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<String> _tasks = []; // Тапсырмаларды сақтайтын тізім (бастапқыда бос).
  final TextEditingController _textController = TextEditingController(); // Мәтін енгізу контроллері

  void _addTask() {
    String text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _tasks.add(text); // Жаңа тапсырманы тізімге қосу
      });
      _textController.clear(); // Енгізу өрісін тазалау
    }
    // Егер мәтін бос болса, ештеңе істемейміз.
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index); // Көрсетілген индекс бойынша тапсырманы тізімнен жою
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Менің тапсырмаларым')),
      body: Column(
        children: [
          // Жаңа тапсырма қосу бөлімі: TextField + "Қосу" кнопкасы
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Жаңа тапсырма енгізіңіз',
                    ),
                    onSubmitted: (value) => _addTask(), // Enter басылса, тапсырма қосу
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Қосу'),
                ),
              ],
            ),
          ),
          // Тапсырмалар тізімін көрсететін ListView
          Expanded(
            child: _tasks.isEmpty 
              ? Center(child: Text('Тізімде әлі тапсырмалар жоқ')) 
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    String task = _tasks[index];
                    return ListTile(
                      title: Text(task),
                      // Егер Checkbox пайдаланғымыз келсе, мына жолды қосуға болады:
                      // leading: Checkbox(value: false, onChanged: (val){}),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTask(index), // Тапсырманы жою
                        tooltip: 'Жою',
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
