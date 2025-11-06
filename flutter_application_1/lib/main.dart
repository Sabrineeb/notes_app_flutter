// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/notes_screen.dart';

Future<void> main() async {
  // 🧩 Charger les variables d'environnement avant de lancer l'app
  await dotenv.load(fileName: ".env");

  // 🚀 Lancer l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // enlève le bandeau Debug
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/notes': (context) => NotesScreen(),
      },
    );
  }
}
