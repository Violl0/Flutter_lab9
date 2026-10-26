import 'package:flutter/material.dart';
import 'package:flutter_lab9/slot_machine.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: const SlotMachine(),
      ),
    ),
  );
}