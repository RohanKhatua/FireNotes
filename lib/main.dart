import 'package:firebase_notes_2/note_adder.dart';
import 'package:firebase_notes_2/notes_from_stream.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireNotes',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const MyHomePage(title: 'FireNotes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("FireNotes")),
      body: Column(
        children: const [
          Expanded(
            child: notesFromStream(),
          ),
          noteAdder(),
        ],
      ),
    );
  }
}
