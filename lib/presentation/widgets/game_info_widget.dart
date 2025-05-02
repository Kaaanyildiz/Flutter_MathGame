import 'package:flutter/material.dart';

class GameInfoWidget extends StatelessWidget {
  final int score;
  final int level;

  const GameInfoWidget({
    super.key,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Puan: $score', 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('Seviye: $level', 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}