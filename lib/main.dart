import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myBingoFlutter/card.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Ganger-Bingo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String game = "";
  String userName = "";
  Carton carton;
  List<bool> _selections1 = List.generate(9, (_) => false);
  List<bool> _selections2 = List.generate(9, (_) => false);
  List<bool> _selections3 = List.generate(9, (_) => false);
  String botonLineaText='Linea!';
  String botonBingoText='Bingo!';
  bool linea = false;
  bool bingo = false;
  String isL = "";
  Map<String, dynamic> gameDetail;

  final _myController = TextEditingController();
  final NameController = TextEditingController();

  Future<void> _goToGame() async {
    var c = await Carton.newCarton(_myController.text);
    var name = NameController.text;
    setState(() {
      game = _myController.text;
      userName = name;
      carton = c;
    });
    Timer.periodic(Duration(milliseconds: 1000), (_) => loadGame());
  }

  Future<void> _isLinea() async {
    setState(() {
      isL = '';
    });
    var r = await carton.isLinea(userName);
    print(r.body);

    setState(() {
      linea = toBoolean(r.body);
    });
    if (!linea)
      setState(() {
        isL = 'Aún no!!!';
      });
  }

  Future<void> _isBingo() async {
    setState(() {
      isL = '';
    });
    var r = await carton.isBingo(userName);
    print(r.body);

    setState(() {
      bingo = toBoolean(r.body);
    });
    if (!linea)
      setState(() {
        isL = 'Aún no!!!';
      });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    gameDetail = null;
    super.dispose();
  }

  Container getTable(Carton c) {
    var _1 =
        new List<Text>.from(c.value.take(9).map((e) =>spanText(e)));
    var _2 = new List<Text>.from(
        c.value.skip(9).take(9).map((e) =>spanText(e)));
    var _3 = new List<Text>.from(
        c.value.skip(18).take(9).map((e) =>spanText(e)));

    var t1 = new ToggleButtons(
        children: _1,
        isSelected: _selections1,
        onPressed: (int index) {
          setState(() {
            _selections1[index] = !_selections1[index];
          });
        });
    var t2 = new ToggleButtons(
        children: _2,
        isSelected: _selections2,
        onPressed: (int index) {
          setState(() {
            _selections2[index] = !_selections2[index];
          });
        });
    var t3 = new ToggleButtons(
        children: _3,
        isSelected: _selections3,
        onPressed: (int index) {
          setState(() {
            _selections3[index] = !_selections3[index];
          });
        });

    var t = Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          if (gameDetail != null && gameDetail['extracted'] != null)
            Text(new List<int>.from(gameDetail['extracted']).toString()),
          t1,
          t2,
          t3,
          Container(
            margin: EdgeInsets.all(20),
            child: Row(children: [
              FlatButton(
                child: Text(botonLineaText),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                  _isLinea();
                },
              ),
              FlatButton(
                child: Text(botonBingoText),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                  _isBingo();
                }
              ),Text(isL)
            ]),
          )
        ]));
    return t;
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (carton == null) Text("Nickname"),
            if (carton == null)
              TextFormField(
                controller: NameController,
                decoration: InputDecoration(hintText: 'NickName'),
              ),
            if (carton == null) enterGameText(),
            if (carton == null) enterGameField(),
            if (carton == null) enterGameButton(),
            if (carton != null) getTable(carton)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget enterGameButton() {
    return FloatingActionButton(
      onPressed: _goToGame,
      tooltip: 'Go',
      child: Icon(Icons.call_to_action),
    );
  }

  Widget enterGameField() {
    return TextFormField(
      controller: _myController,
      decoration: InputDecoration(hintText: 'PIN'),
    );
  }

  Widget enterGameText() {
    return Text(
      'PIN:',
    );
  }

  loadGame() async {
    var r = await http.get("https://ganger-bingo.herokuapp.com/game/${game}");
    var g = json.decode(r.body);
    print(g);
    setState(() {
      gameDetail = g;
      if(gameDetail['line']!=null)
      botonLineaText = 'Linea para ${gameDetail['line']}';
      if(gameDetail['bingo']!=null)
      botonBingoText = 'Bingo para ${gameDetail['bingo']}';

    });
  }
}
Text spanText (int e){
  if(e==0)
    return Text(' ') ;
  else
    return Text(e.toString()) ;
}
bool toBoolean(String str) {
  return str != '0' && str != 'false' && str != '';
}
