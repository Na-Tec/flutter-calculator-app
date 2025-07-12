import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_caculator/models/calculator_models.dart';
import 'package:interactive_caculator/services/calculator_logic.dart';

class EnhancedCalculator extends StatefulWidget {
  const EnhancedCalculator({Key? key}) : super(key: key);

  @override
  State<EnhancedCalculator> createState() => _EnhancedCalculatorState();
}

class _EnhancedCalculatorState extends State<EnhancedCalculator> {
  CalculatorState _state = const CalculatorState();
  late FocusNode _focusNode;

  final List<List<String>> _buttonLayout = [
    ["sin", "cos", "tan", "π", "C"],
    ["ln", "log", "√", "x²", "CE"],
    ["7", "8", "9", "÷", "^"],
    ["4", "5", "6", "×", "1/x"],
    ["1", "2", "3", "-", "e"],
    ["±", "0", ".", "+", "="],
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        autofocus: true,
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Column(
            children: [
              _buildDisplay(),
              const Divider(color: Colors.grey),
              Expanded(child: _buildButtonGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _state.display,
            style: const TextStyle(fontSize: 48, color: Colors.white),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    return Column(
      children: _buttonLayout.map((row) {
        return Expanded(
          child: Row(
            children: row.map((value) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _buildButton(value),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButton(String value) {
    final backgroundColor = _getButtonColor(value);

    return ElevatedButton(
      onPressed: () => _handleButtonPress(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
      ),
      child: Text(value, style: const TextStyle(fontSize: 22)),
    );
  }

  Color _getButtonColor(String value) {
    const orangeOps = {"+", "-", "×", "÷"};
    const blueOps = {
      "sin",
      "cos",
      "tan",
      "π",
      "ln",
      "log",
      "√",
      "x²",
      "1/x",
      "e",
      "±",
      "^",
    };

    if (value == "C") return Colors.red[400]!;
    if (orangeOps.contains(value)) return Colors.orange;
    if (blueOps.contains(value)) return Colors.blue[700]!;

    return Colors.grey[850]!; // Default
  }

  void _handleButtonPress(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      _state = CalculatorLogic.processInput(_state, value);
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;

      if (key.keyId >= LogicalKeyboardKey.digit0.keyId &&
          key.keyId <= LogicalKeyboardKey.digit9.keyId) {
        final digit = (key.keyId - LogicalKeyboardKey.digit0.keyId).toString();
        _handleButtonPress(digit);
        return KeyEventResult.handled;
      }

      switch (key.keyLabel) {
        case "+":
        case "-":
        case ".":
          _handleButtonPress(key.keyLabel);
          return KeyEventResult.handled;
        case "*":
          _handleButtonPress("×");
          return KeyEventResult.handled;
        case "/":
          _handleButtonPress("÷");
          return KeyEventResult.handled;
        case "=":
        case "Enter":
          _handleButtonPress("=");
          return KeyEventResult.handled;
        case "Escape":
          _handleButtonPress("C");
          return KeyEventResult.handled;
        case "Backspace":
          _handleButtonPress("CE");
          return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }
}
