import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase қызметтерін бастау (міндетті)
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

/// Пайдаланушы кіретін/тіркелетін экран
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String? _error; // Қате хабарын сақтау

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String pass = _passController.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _error = 'Email және құпия сөзді енгізіңіз';
      });
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      // Тіркелу сәтті болды, автоматты түрде жүйеге кіреді
      _goToHome();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _error = 'Құпия сөз өте қарапайым (күрделірек етіңіз)';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _error = 'Бұл email тіркелген, кіріңіз немесе басқа email көрсетіңіз';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _error = 'Email форматы қате';
        });
      } else {
        setState(() {
          _error = 'Тіркелу қатесі: ${e.code}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Белгісіз қате орын алды';
      });
    }
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String pass = _passController.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _error = 'Барлық өрісті толтырыңыз';
      });
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      // Кіру сәтті
      _goToHome();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _error = 'Мұндай қолданушы табылмады';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _error = 'Құпия сөз қате';
        });
      } else {
        setState(() {
          _error = 'Кіру қатесі: ${e.code}';
        });
      }
    } catch (e) {
      setState(() {
        print('EXCEPTION: $e');
        _error = 'Кіру жүзеге аспады (байланыс қатесі)';
      });
    }
  }

  void _goToHome() {
    // HomePage-ке ауысамыз да, осы Login бетін стектен алып тастаймыз
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Кіру / Тіркелу')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passController,
              decoration: InputDecoration(labelText: 'Құпия сөз'),
              obscureText: true, // құпия сөзді жасыру (●●●)
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _register, child: Text('Тіркелу')),
                ElevatedButton(onPressed: _login, child: Text('Кіру')),
              ],
            ),
            if (_error != null) ...[
              SizedBox(height: 16),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}

/// Қош келдіңіз/Logout экраны
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Ағымдағы кірген user
    String email = user?.email ?? 'Белгісіз';
    return Scaffold(
      appBar: AppBar(
        title: Text('Қош келдіңіз'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginPage()));
            },
            tooltip: 'Шығу',
          )
        ],
      ),
      body: Center(
        child: Text(
          'Сіз кірдіңіз: $email',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
