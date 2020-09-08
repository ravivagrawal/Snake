import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake/grid.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Snake'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var tn = 0;
  final List<List<Color>> theme = [
    [Colors.lightGreenAccent, Colors.greenAccent, Colors.blue, Colors.red],
    [Colors.lightBlue, Colors.lightBlueAccent, Colors.red, Colors.purple],
  ];
  var _grid;
  int n = 15;
  bool start = false;
  bool _new = true;
  int _length = 2;
  var _snake;
  var apple;
  int gameswon = 0;
  int gameslost = 0;
  List<bool> wbp = [false, false, false, false];
  var sizes=[7,15];
  var sn=1;
  List<String> level=["Easy","Med","Hard"];
  var ls=0;

  void _generateApple() {
    if (!won()) {
      var rng = Random();
      while (true) {
        int x = rng.nextInt(n);
        int y = rng.nextInt(n);
        if ((_grid[x][y] == 0 || _grid[x][y] == 1)) {
          apple[0] = x;
          apple[1] = y;
          _grid[x][y] = 3;
          break;
        }
      }
    }
  }

  void themeChange(){
    setState(() {
      tn = (tn + 1) % 2;
    });
  }

  void levelChange(){
    setState(() {
      ls = (ls + 1) % 3;
      _newGame();
    });
  }

  void sizeChange(){
    setState(() {
      sn = (sn + 1) % 2;
      n=sizes[sn];
      _newGame();
    });
  }

  bool out(int x, int y) {
    if (x >= 0 && x < n && y >= 0 && y < n) {
      if (_grid[x][y] == 2) {
        print("Overlap");
        _newGame();
        setState(() {
          gameslost++;
        });
        return true;
      }
      return false;
    } else {
      print("Out of bounds");
      _newGame();
      setState(() {
        gameslost++;
      });
      return true;
    }
  }

  void _grow(int x, int y) {
    _grid[apple[0]][apple[1]] = 2;
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++)
        if (_snake[i][j] != 0 && _snake[i][j] < _length) _snake[i][j]++;
    }
    _snake[x][y] = 1;
    _generateApple();
  }

  void snakeupdate(int x, int y) {
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        if (_snake[i][j] != 0 && _snake[i][j] < _length)
          _snake[i][j]++;
        else if (_snake[i][j] == _length) _snake[i][j] = 0;
      }
    }
    _snake[x][y] = 1;
  }

  List<int> head() {
    List<int> headcood = [0, 0];
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        if (_snake[i][j] == 1) {
          headcood[0] = i;
          headcood[1] = j;
        }
      }
    }
    return headcood;
  }

  List<int> tail() {
    List<int> tailcood = [0, 0];
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        if (_snake[i][j] == _length) {
          tailcood[0] = i;
          tailcood[1] = j;
        }
      }
    }
    return tailcood;
  }

  void _left() {
    var headco = head();
    var tailco = tail();
    print(headco);
    print(tailco);
    if (!start) {
      start = true;
      _new = false;
    }
    if (!out(headco[0], headco[1] + 1)) {
      if (headco[1] < n &&
          !(apple[0] == headco[0] && apple[1] == (headco[1] + 1))) {
        _grid[headco[0]][headco[1] + 1] = 2;
        _grid[tailco[0]][tailco[1]] =
            ((tailco[0] + tailco[1]) % 2 == 0 ? 1 : 0);
        snakeupdate(headco[0], headco[1] + 1);
      } else if (apple[0] == headco[0] && apple[1] == (headco[1] + 1)) {
        _length++;
        _grow(headco[0], headco[1] + 1);
      }
      headco = head();
      tailco = tail();
      print(headco);
      print(tailco);
    }
    setState(() {
      _grid;
    });
  }

  void _right() {
    var headco = head();
    var tailco = tail();
    print(headco);
    print(tailco);
    if (!start) {
      start = true;
      _new = false;
    }
    if (!out(headco[0], headco[1] - 1)) {
      if (headco[1] > 0 &&
          !(apple[0] == headco[0] && apple[1] == (headco[1] - 1))) {
        _grid[headco[0]][headco[1] - 1] = 2;
        _grid[tailco[0]][tailco[1]] =
            ((tailco[0] + tailco[1]) % 2 == 0 ? 1 : 0);
        snakeupdate(headco[0], headco[1] - 1);
      } else if (apple[0] == headco[0] && apple[1] == (headco[1] - 1)) {
        _length++;
        _grow(headco[0], headco[1] - 1);
      }
      headco = head();
      tailco = tail();
      print(headco);
      print(tailco);
    }
    setState(() {
      _grid;
    });
  }

  void _up() {
    var headco = head();
    var tailco = tail();
    print(headco);
    print(tailco);
    if (!start) {
      start = true;
      _new = false;
    }
    if (!out(headco[0] - 1, headco[1])) {
      if (headco[0] > 0 &&
          !(apple[0] == (headco[0] - 1) && apple[1] == headco[1])) {
        _grid[headco[0] - 1][headco[1]] = 2;
        _grid[tailco[0]][tailco[1]] =
            ((tailco[0] + tailco[1]) % 2 == 0 ? 1 : 0);
        snakeupdate(headco[0] - 1, headco[1]);
      } else if (apple[0] == (headco[0] - 1) && apple[1] == headco[1]) {
        _length++;
        _grow(headco[0] - 1, headco[1]);
      }
      headco = head();
      tailco = tail();
      print(headco);
      print(tailco);
    }
    setState(() {
      _grid;
    });
  }

  void _down() {
    var headco = head();
    var tailco = tail();
    print(headco);
    print(tailco);
    if (!start) {
      start = true;
      _new = false;
    }
    if (!out(headco[0] + 1, headco[1])) {
      if (headco[0] < n &&
          !(apple[0] == (headco[0] + 1) && apple[1] == headco[1])) {
        _grid[headco[0] + 1][headco[1]] = 2;
        _grid[tailco[0]][tailco[1]] =
            ((tailco[0] + tailco[1]) % 2 == 0 ? 1 : 0);
        snakeupdate(headco[0] + 1, headco[1]);
      } else if (apple[0] == (headco[0] + 1) && apple[1] == headco[1]) {
        _length++;
        _grow(headco[0] + 1, headco[1]);
      }
      headco = head();
      tailco = tail();
      print(headco);
      print(tailco);
    }
    setState(() {
      _grid;
    });
  }

  bool won() {
    bool flag = true;
    for (var i = 0; i < n; i++)
      for (var j = 0; j < n; j++) if (_grid[i][j] != 2) flag = false;
    if (flag) {
      gameswon++;
      _newGame();
    }
    return flag;
  }

  void _newGame() {
    setState(() {
      wbp = [false, false, false, false];
      _new = false;
      _grid = (List.generate(n, (_) => List.generate(n, (_) => 0)));
      _snake = (List.generate(n, (_) => List.generate(n, (_) => 0)));
      _length = 2;
      for (var i = 0; i < n; i++)
        for (var j = 0; j < n; j++) if ((i + j) % 2 == 0) _grid[i][j] = 1;
      _grid[n ~/ 2][2] = 2;
      _grid[n ~/ 2][1] = 2;
      _snake[n ~/ 2][2] = 1;
      _snake[n ~/ 2][1] = 2;
      _grid[n ~/ 2][n - 3] = 3;
      apple = [n ~/ 2, n - 3];
    });
  }

  void resetStat() {
    gameswon = 0;
    gameslost = 0;
    _newGame();
  }

  Future<void> lleft() async {
    wbp = [false, false, false, true];
    while (!won() && wbp[3]) {
      _left();
      switch (ls) {
          case 1:
          await new Future.delayed(const Duration(milliseconds: 350));
          break;
          case 2:
          await new Future.delayed(const Duration(milliseconds: 250));
          break;
          break;
        default:
        await new Future.delayed(const Duration(milliseconds: 500));
      }      
    }
  }

  Future<void> rright() async {
    wbp = [true, false, false, false];
    while (!won() && wbp[0]) {
      _right();
      switch (ls) {
          case 1:
          await new Future.delayed(const Duration(milliseconds: 350));
          break;
          case 2:
          await new Future.delayed(const Duration(milliseconds: 250));
          break;
          break;
        default:
        await new Future.delayed(const Duration(milliseconds: 500));
      }    
    }
  }

  Future<void> uup() async {
    wbp = [false, true, false, false];
    while (!won() && wbp[1]) {
      _up();
      switch (ls) {
          case 1:
          await new Future.delayed(const Duration(milliseconds: 350));
          break;
          case 2:
          await new Future.delayed(const Duration(milliseconds: 250));
          break;
          break;
        default:
        await new Future.delayed(const Duration(milliseconds: 500));
      }    
    }
  }

  Future<void> ddown() async {
    wbp = [false, false, true, false];
    while (!won() && wbp[2]) {
      _down();
      switch (ls) {
          case 1:
          await new Future.delayed(const Duration(milliseconds: 350));
          break;
          case 2:
          await new Future.delayed(const Duration(milliseconds: 250));
          break;
          break;
        default:
        await new Future.delayed(const Duration(milliseconds: 500));
      }    
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!start && _new) {
      _newGame();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: themeChange,
                  child: Text("Theme"),
                ),
                RaisedButton(
                  onPressed: resetStat,
                  child: Text("Reset Stats"),
                ),
                RaisedButton(
                  onPressed: (){levelChange();_newGame();},
                  child: Text("Level-"+level[ls]),
                ),
                RaisedButton(
                  onPressed: sizeChange,
                  child: Text("Size"),
                ),
              ],
            ),
            Grid(n, _grid, theme[tn]),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 10,
                      child: RaisedButton(
                        onPressed: uup,
                        child: Text("^\n|"),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 10,
                      child: RaisedButton(
                        onPressed: rright,
                        child: Text("<-"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 10,
                      child: null,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 10,
                      child: RaisedButton(
                        onPressed: lleft,
                        child: Text("->"),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 10,
                      child: RaisedButton(
                        onPressed: ddown,
                        child: Text("|\nv"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "Games Lost:\t" +
                  gameslost.toString() +
                  "\nGames Won:\t" +
                  gameswon.toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          start = false;
          _new = true;
          _newGame();
        },
        tooltip: 'New Game',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
