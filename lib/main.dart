import 'package:flutter/material.dart';

import 'box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TicTacToeGamePage(),
    );
  }
}

class TicTacToeGamePage extends StatefulWidget {
  const TicTacToeGamePage({super.key});

  @override
  State<TicTacToeGamePage> createState() => _TicTacToeGamePageState();
}

class _TicTacToeGamePageState extends State<TicTacToeGamePage> {
  final int gameSize = 3;

  late double itemBoxSize;
  late List<List<Box>> matrix;

  Player lastPlayer = Player.none;

  @override
  void initState() {
    super.initState();

    resetMatrix();
  }

  @override
  Widget build(BuildContext context) {
    itemBoxSize = MediaQuery.of(context).size.shortestSide * 0.6 / gameSize;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Tic Tac Toe",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.blue),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            gameSize,
            (x) => rowBuild(x),
          ),
        ),
      ),
    );
  }

  void resetMatrix() {
    matrix = List.generate(gameSize,
        (x) => List.generate(gameSize, (y) => Box(x, y, Player.none)));
    lastPlayer = Player.none;
  }

  Widget rowBuild(int x) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        gameSize,
        (y) => itemBoxBuild(matrix[x][y]),
      ),
    );
  }

  Widget itemBoxBuild(Box box) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(itemBoxSize, itemBoxSize),
          backgroundColor: Colors.blue,
        ),
        onPressed: () {
          if (box.player == Player.none) {
            var player = lastPlayer != Player.X ? Player.X : Player.O;
            box.player = player;
            lastPlayer = player;
            setState(() {
              if (isWinner(box)) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: Text("${box.getText()} g'olib bo'ldi"),
                    content: const Text(
                        "Qayta o'ynash uchun quyidagi tugmani bosing"),
                    actions: [
                      InkWell(
                        child: const Text("O'ynash"),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            resetMatrix();
                          });
                        },
                      )
                    ],
                  ),
                );
              } else if (isEndGame()) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text("O'yin durrang bo'ldi"),
                    content: const Text(
                        "Qayta o'ynash uchun quyidagi tugmani bosing"),
                    actions: [
                      InkWell(
                        child: const Text("O'ynash"),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            resetMatrix();
                          });
                        },
                      )
                    ],
                  ),
                );
              }
            });
          }
        },
        child: Text(
          box.getText(),
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  bool isWinner(Box box) {
    bool isRowWinner = true;
    for (int i = 0; i < gameSize; i++) {
      isRowWinner = isRowWinner && matrix[box.x][i].player == box.player;
    }
    bool isColumnWinner = true;
    for (int i = 0; i < gameSize; i++) {
      isColumnWinner = isColumnWinner && matrix[i][box.y].player == box.player;
    }
    bool isLeftDiagonalWinner = true;
    for (int i = 0; i < gameSize; i++) {
      isLeftDiagonalWinner =
          isLeftDiagonalWinner && matrix[i][i].player == box.player;
    }
    bool isRightDiagonalWinner = true;
    for (int i = 0; i < gameSize; i++) {
      isRightDiagonalWinner = isRightDiagonalWinner &&
          matrix[i][gameSize - i - 1].player == box.player;
    }
    return isRowWinner ||
        isColumnWinner ||
        isLeftDiagonalWinner ||
        isRightDiagonalWinner;
  }

  bool isEndGame() {
    for (int i = 0; i < gameSize; i++) {
      for (int j = 0; j < gameSize; j++) {
        if (matrix[i][j].player == Player.none) {
          return false;
        }
      }
    }
    return true;
  }
}
