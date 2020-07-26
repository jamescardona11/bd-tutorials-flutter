import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedTextField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final Function(String) onChanged;
  final Duration debounceDuration;

  DebouncedTextField({
    this.controller,
    this.decoration,
    this.onChanged,
    this.debounceDuration,
  });

  @override
  _DebouncedTextFieldState createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  Timer timer;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: widget.decoration,
      onChanged: (value) {
        if (timer?.isActive == true) {
          timer.cancel();
        }

        timer = Timer(widget.debounceDuration, () {
          widget.onChanged(value);
        });
      },
    );
  }
}
