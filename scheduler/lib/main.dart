import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  alignment: Alignment.centerRight,
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Hello World',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 32,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text("Text Button"),
                  style: TextButton.styleFrom(primary: Colors.purple)),
              OutlinedButton(
                  onPressed: () {},
                  child: const Text("OutlinedButton"),
                  style: OutlinedButton.styleFrom(primary: Colors.purple)),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("ElevatedButton"),
                  style: ElevatedButton.styleFrom(primary: Colors.purple)),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("ElevatedButton Shadow"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.purple, elevation: 8))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                  onPressed: null,
                  child: const Text("null TextButton"),
                  style: TextButton.styleFrom(primary: Colors.purple)),
              OutlinedButton(
                  onPressed: null,
                  child: const Text("null OutlinedButton"),
                  style: OutlinedButton.styleFrom(primary: Colors.purple)),
              ElevatedButton(
                  onPressed: null,
                  child: const Text("null ElevatedButton"),
                  style: ElevatedButton.styleFrom(primary: Colors.purple))
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
