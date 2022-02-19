import 'package:flutter/material.dart';

const String appTitle = "Motivate Scheduler";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: appTitle),
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              floating: true,
              title: Text(appTitle),
              leading:
                  IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
                IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
              ]),
          SliverFixedExtentList(
            itemExtent: 60,
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  title: Text("ListTile 1"),
                  subtitle: Text("SubTitle"),
                  trailing: Icon(Icons.more_vert),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(100, 0, 100, 0),
                  child: Container(
                      child: Text("card"),
                      height: 60,
                      width: double.infinity,
                      alignment: Alignment.center),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.beenhere),
                    title: Text("ListTile in Card"),
                    trailing: Icon(Icons.beenhere),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
