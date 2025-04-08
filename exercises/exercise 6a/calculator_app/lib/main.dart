import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

/// MyApp is the root of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4-Function Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
    );
  }
}

/// CalculatorScreen builds the main user interface of the calculator.
class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Holds the current arithmetic expression that the user is building.
  String _expression = "";

  /// Handles the logic for button presses.
  void _onButtonPressed(String value) {
    setState(() {
      if (value == "=") {
        _evaluateExpression();
      } else {
        _expression += value;
      }
    });
  }

  /// Uses math_expressions to parse and compute the arithmetic expression.
  void _evaluateExpression() {
    try {
      // Create a parser and parse the current expression string.
      Parser parser = Parser();
      Expression exp = parser.parse(_expression);
      // Use a ContextModel for variables (if any) and evaluate the expression.
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      // Update the expression with the result.
      _expression = eval.toString();
    } catch (e) {
      // In case of any error (e.g., malformed expression), display an error.
      _expression = "Error";
    }
  }

  /// Helper method to generate calculator buttons.
  Widget _buildButton(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20.0),
          backgroundColor: Colors.grey[200],
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("4-Function Calculator"),
      ),
      body: Column(
        children: [
          // The display area that shows the current input and results.
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Text(
                _expression,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          // The buttons arranged in a grid (4 columns).
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("/"),
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("*"),
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("-"),
                  _buildButton("0"),
                  _buildButton("."),
                  _buildButton("="),
                  _buildButton("+"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
