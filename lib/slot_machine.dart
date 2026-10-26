import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_lab9/slot_row.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {
  final Random _random = Random();

  final List<String> _symbols = [
    'assets/images/cherry.png',
    'assets/images/lemon.png',
    'assets/images/seven.png',
  ];

  var _coins = 10;
  var _slot1 = 'assets/images/cherry.png';
  var _slot2 = 'assets/images/lemon.png';
  var _slot3 = 'assets/images/seven.png';
  var _message = '';

  void _spin() {
    if (_coins <= 0) {
      setState(() {
        _message = 'Монеты закончились! 😢';
      });
      return;
    }

    setState(() {
      _slot1 = _symbols[_random.nextInt(_symbols.length)];
      _slot2 = _symbols[_random.nextInt(_symbols.length)];
      _slot3 = _symbols[_random.nextInt(_symbols.length)];

      if (_slot1 == _slot2 && _slot2 == _slot3) {
        _coins += 3;
        _message = 'Победа! 🎉 +3 монеты';
      } else {
        _coins -= 1;
        _message = 'Попробуй ещё раз 😔 -1 монета';
      }
    });
  }

  void _reset() {
    setState(() {
      _coins = 10;
      _slot1 = 'assets/images/cherry.png';
      _slot2 = 'assets/images/lemon.png';
      _slot3 = 'assets/images/seven.png';
      _message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Монеты: $_coins',
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        SlotRow(
          slot1: _slot1,
          slot2: _slot2,
          slot3: _slot3,
        ),
        const SizedBox(height: 24),
        Text(
          _message,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _coins > 0 ? _spin : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
          ),
          child: const Text(
            'КРУТИТЬ 🎰',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _reset,
          child: const Text(
            'Начать заново',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}