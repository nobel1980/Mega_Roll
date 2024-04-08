import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(myApp());
}

MaterialApp myApp() {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    // theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //     textTheme: GoogleFonts.russoOneTextTheme()),
    home: GamePage(),
  );
}
enum GameStatus {
  running,
  over,
  none,
}

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final diceList = [
    'images/dice1.png',
    'images/dice2.png',
    'images/dice3.png',
    'images/dice4.png',
    'images/dice5.png',
    'images/dice6.png',
  ];
  GameStatus gameStatus = GameStatus.none;
  String result = '';
  int index1 = 0,
      index2 = 0,
      diceSum = 0,
      target = 0;
  final random = Random.secure();
  bool hasTarget = false,
      shouldShowBoard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MEGA ROLL'),),
      body: Center(
        child: shouldShowBoard
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(diceList[index1], width: 100, height: 100,),
                const SizedBox(width: 10,),
                Image.asset(diceList[index2], width: 100, height: 100,),
              ],
            ),
            Text('Dice Sum :$diceSum', style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold),),
            if(hasTarget)
              Text('Your Target: $target \n Keep rolling to match $target',
                style: (const TextStyle(fontSize: 30)),),
            if(gameStatus == GameStatus.over)Text(result, style: const TextStyle(fontSize: 30),),
            if(gameStatus == GameStatus.running)DiceButton(onPressed: rollTheDice, label: 'ROLL',),
            if(gameStatus == GameStatus.over)DiceButton(onPressed: reset, label: 'RESET',),
          ],
        ) :  startPage(onStart: startGame,),),
    );
  }

  void rollTheDice() {
    setState(() {
      index1 = random.nextInt(6);
      index2 = random.nextInt(6);
      diceSum = index1 + index2 + 2;
      if (hasTarget) {
        checkTerget();
      } else {
        checkFirstRoll();
      }
    });
  }

  void checkTerget() {
    if (diceSum == target) {
      result = 'You win !';
      gameStatus = GameStatus.over;
    } else if (diceSum == 7) {
      result = 'You lost !!';
      gameStatus = GameStatus.over;
    }
  }

  void checkFirstRoll() {
    if (diceSum == 7 || diceSum == 11) {
      result = 'You win !';
      gameStatus = GameStatus.over;
    } else if (diceSum == 2 || diceSum == 3 || diceSum == 12) {
      result = 'You lost !';
      gameStatus = GameStatus.over;
    } else {
      hasTarget = true;
      target = diceSum;
    }
  }

  void reset() {
    setState(() {
      index1 = 0;
      index2 = 0;
      diceSum = 0;
      target = 0;
      result = '';
      hasTarget = false;
      shouldShowBoard = false;
      gameStatus = GameStatus.none;
    });
  }

  void startGame() {
    setState(() {
      shouldShowBoard = true;
      gameStatus = GameStatus.running;
    });
  }
}

class startPage extends StatelessWidget {
  final VoidCallback onStart;
  const startPage({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('images/diceLogo.png', width: 150, height: 150,),
        RichText(text: TextSpan(text: 'MEGA',
            style: GoogleFonts.russoOne().copyWith(
              color: Colors.red, fontSize: 40,), children: [
                TextSpan(text: ' ROLL', style: GoogleFonts.russoOne().copyWith(color: Colors.black) ),
            ]),),
        const Spacer(),
        DiceButton(label: 'START', onPressed: onStart),
        DiceButton(label: 'HOW TO PLAY', onPressed: () {
          showInstruction(context);
    },),
      ],
    );
  }

  void showInstruction(BuildContext context) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('INSTRUCTION'),
      content: Text(gameRules),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('CLOSE'),)
      ],
    ));
  }
}

class DiceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const DiceButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 20, color: Colors.white),),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
    );
  }
}
const gameRules = '''
* AT THE FIRST ROLL, IF THE DICE SUM IS 7 OR 11, YOU WIN! 
* AT THE FIRST ROLL, IF THE  DICE SUM IS 2,3 OR 12, YOU LOST!!
* AT THE FIRST ROLL, IF THE DICE SUM IS 4, 5, 6, 8, 9, 10 THEN THIS DICE SUM WILL BE YOUR TARGET POINT, AND KEEP ROLLING
* IF THE DICE SUM MATCHES YOUR TARGET POINT, YOU WIN!
* IF THE DICE SUM IS 7, YOU LOST!!  
''';

