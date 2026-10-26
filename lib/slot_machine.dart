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
  var _isSpinning = false;

  Future<String> _spinReel({
    required int totalTicks,
    required void Function(String) onTick,
  }) async {
    String result = _symbols[0];
    for (int i = 0; i < totalTicks; i++) {
      final progress = i / totalTicks;
      final delay = progress < 0.5
          ? 40
          : progress < 0.8
              ? 100
              : 200;
      await Future.delayed(Duration(milliseconds: delay));
      result = _symbols[_random.nextInt(_symbols.length)];
      onTick(result);
    }
    return result;
  }

  Future<void> _spin() async {
    if (_coins <= 0 || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _message = '';
    });

    final result1 = await _spinReel(
      totalTicks: 10,
      onTick: (val) => setState(() => _slot1 = val),
    );
    final result2 = await _spinReel(
      totalTicks: 13,
      onTick: (val) => setState(() => _slot2 = val),
    );
    final result3 = await _spinReel(
      totalTicks: 16,
      onTick: (val) => setState(() => _slot3 = val),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isSpinning = false;
      if (result1 == result2 && result2 == result3) {
        if (result1 == 'assets/images/seven.png') {
          _coins += 10;
          _message = 'ДЖЕКПОТ! +10 монет';
        } else {
          _coins += 3;
          _message = 'Победа! +3 монеты';
        }
      } else {
        _coins -= 1;
        _message = 'Попробуй ещё раз -1 монета';
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
      _isSpinning = false;
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
        AnimatedOpacity(
          opacity: _isSpinning ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SlotRow(
            slot1: _slot1,
            slot2: _slot2,
            slot3: _slot3,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 36,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              _isSpinning ? '🎰 Крутим...' : _message,
              key: ValueKey(
                _isSpinning ? 'spinning' : _message,
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: _message.contains('ДЖЕКПОТ')
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _coins > 0 && !_isSpinning ? _spin : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
          ),
          child: Text(
            _isSpinning ? '🎰 Крутим...' : 'КРУТИТЬ 🎰',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _isSpinning ? null : _reset,
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