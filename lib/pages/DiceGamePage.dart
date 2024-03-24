import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DiceGamePage extends StatefulWidget {
  const DiceGamePage({super.key});
  @override
  State<DiceGamePage> createState() => _DiceGamePageState();
}
class _DiceGamePageState extends State<DiceGamePage> {
  final dicelist = <String> [
    'image/one.jpg',
    'image/two.jpg',
    'image/three.jpg',
    'image/four.jpg',
    'image/five.jpg',
    'image/six.jpg',
  ];
  bool isGameOver = false;
  bool isGameStart = true;
  String status = '';
  int index1 = 0, index2 = 0 , dicesum = 0, target = 0;
  final random = Random.secure();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade700,
      appBar: AppBar(
        title: Text('Dice Game'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isGameStart ? startBody(context) : gameBody(),
    );
  }

  Widget startBody(BuildContext context){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Dice Masters',style: GoogleFonts.rubikBurned(fontSize: 40), ),
          SizedBox(height: 50,),
          DiceButton(
              onPressed: _startButton,
              title: 'START'
          ),
          SizedBox(height: 10,),
          DiceButton(
              onPressed: _howToPlay,
              title:'HOW TO PLAY')
        ],
      ),
    );
  }

  Widget gameBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(dicelist[index1], width: 100, height: 100, fit: BoxFit.cover,),
            SizedBox(width: 10,),
            Image.asset(dicelist[index2], width: 100, height: 100, fit: BoxFit.cover,),
          ],
        ),
        Text('Dicesum : $dicesum' ),
       if(target>0) Text('Your target is : $target'),
      if(target> 0)  Text('Keep rolling until you match your target point \n $target',textAlign: TextAlign.center,),
       if(!isGameOver) ElevatedButton(onPressed: _rollTheDice, child: Text('Roll')),
       if(isGameOver) ElevatedButton(onPressed: _resetTheDice, child: Text('Reset')),
        Text(status)
      ],
    );
  }
  void _rollTheDice() {
    setState(() {
      index1 = random.nextInt(6);
      index2 = random.nextInt(6);
      dicesum = index1 + index2 + 2;
      if(target > 0){
        if(dicesum == target){
          status = 'Players Wins';
          isGameOver = true;
        }else if(dicesum == 7){
          status = 'Players lost';
          isGameOver = true;
        }
      }else{
        if(dicesum == 7 || dicesum == 11){
          status ='Players Wins';
          isGameOver = true;
        }else if ( dicesum == 2 || dicesum == 3 || dicesum == 12){
          status = ' Players Lost';
          isGameOver = true;
        }else{
          target = dicesum;
        }
      }
    });
  }
  void _resetTheDice() {
    setState(() {
      index1 = 0;
      index2 = 0;
      status = '';
      isGameOver = false;
      dicesum = 0;
      target = 0;
      isGameStart = true;
    });
  }

  void _startButton() {
    setState(() {
      isGameStart = false;
    });
  }
  void _howToPlay() {
    showDialog(barrierDismissible: false ,context: context, builder: (context) => AlertDialog(
      title: Text('Game Rules'),
      content: Text(rules),
      actions: [
        OutlinedButton(onPressed: ()=> Navigator.pop(context), child: Text('CLOSE'))
      ],
    ));
  }
}

class DiceButton extends StatelessWidget {
  final String  title;
  final VoidCallback onPressed;
  const DiceButton({super.key,required this.title,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.black
          ),
            onPressed: onPressed,
            child: Text(title)),
      ),
    );
  }
}

const rules = '''
 1. At the first roll, if the dice sum is 7 or 11 , Players Wins.
 2. At the first roll, if the dice sum is 2,3 or 12, Players Lose.
 3. At the first roll, if the dice sum is 4,5,6,8,9 or 10, dice sum will be the target point.
  4. If the dice sum matches the target point, Players Wins.
  5. If the dice sum is 7 while chasing the target, Players lose.
''';




