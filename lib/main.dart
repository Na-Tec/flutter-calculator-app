import 'package:flutter/material.dart';
import 'ui/pages/calculator_page.dart';
import 'ui/pages/enhanced_calculator_page.dart' as enhanced;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange,
        ),
      ),
      home: const CombinedCalculatorScreen(),
    );
  }
}

class CombinedCalculatorScreen extends StatefulWidget {
  const CombinedCalculatorScreen({super.key});

  @override
  State<CombinedCalculatorScreen> createState() =>
      _CombinedCalculatorScreenState();
}

class _CombinedCalculatorScreenState extends State<CombinedCalculatorScreen> {
  bool _showEnhanced = false;

  void _toggleCalculator() {
    setState(() {
      _showEnhanced = !_showEnhanced;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showEnhanced ? 'Enhanced Calculator' : 'Standard Calculator',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange.withValues(alpha: 0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _toggleCalculator,
              icon: const Icon(Icons.swap_horiz, color: Colors.white),
              label: Text(
                _showEnhanced ? 'Standard' : 'Enhanced',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: _showEnhanced
          ? const enhanced.EnhancedCalculator()
          : const CalculatorApp(), // now unambiguous
    );
  }
}
