import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

late final FirebaseApp app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp();

  runApp(const MyApp());
}

enum Status { active, inactive }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DatabaseReference dbRef;
  Status statusSelected = Status.inactive;
  bool switchSelected = false;
  @override
  void initState() {
    dbRef = FirebaseDatabase.instance.ref();
    readData();
    super.initState();
  }

  void createData() {
    log('creating');
    dbRef.child("Mqtt").set({'status': true}).then((value) {});
  }

  void readData() {
    log('getting hre');
    dbRef.once().then((DatabaseEvent snapshot) {
      print('Data : ${snapshot.snapshot.value}');

      Map<dynamic, dynamic> data =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      log(data.toString());
      // InternalLinkedHashMap<Object?, Object?> originalMap =
      //     snapshot.snapshot.value; // Your original map
      // Map<String, dynamic> convertedMap = {};
      // for (var key in originalMap.keys) {
      //   convertedMap[key.toString()] = originalMap[key];
      // }

      switchSelected = data['Mqtt']['status'];
      setState(() {});
    });
  }

  void updateData() {
    dbRef.child('Mqtt').update({'status': switchSelected});
  }

  int _counter = 0;

  void _incrementCounter() {
    updateData();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Switch(
              value: switchSelected,
              onChanged: (value) {
                setState(() {
                  switchSelected = value;
                });
                updateData();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
