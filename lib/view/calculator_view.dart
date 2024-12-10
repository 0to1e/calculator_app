import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _textController = TextEditingController();
  List<String> lstSymbols = [
    "C",
    "/",
    "%",
    "<-",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "0",
    ".",
    "=",
  ];

  void _onButtonPressed(String symbol) {
    setState(() {
      if (symbol == "C") {
        // Clear the input
        _textController.text = "";
      } else if (symbol == "<-") {
        // Remove the last character
        if (_textController.text.isNotEmpty) {
          _textController.text =
              _textController.text.substring(0, _textController.text.length - 1);
        }
      } else if (symbol == "=") {
        // Evaluate the expression
        try {
          final result = _evaluateExpression(_textController.text);
          _textController.text = result.toString();
        } catch (e) {
          _textController.text = "Error";
        }
      } else {
        // Append the symbol to the text
        _textController.text += symbol;
      }
    });
  }

  double _evaluateExpression(String expression) {
    try {
      // Replace percentage with division by 100
      expression = expression.replaceAll('%', '/100');

      // Parse and calculate the expression manually
      final tokens = _tokenize(expression);
      final result = _calculate(tokens);
      return result;
    } catch (e) {
      throw Exception("Invalid Expression");
    }
  }

  List<String> _tokenize(String expression) {
    final tokens = <String>[];
    String current = "";
    for (var char in expression.split('')) {
      if ("0123456789.".contains(char)) {
        // Build numbers
        current += char;
      } else {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = "";
        }
        // Add operator
        tokens.add(char);
      }
    }
    if (current.isNotEmpty) tokens.add(current);
    return tokens;
  }

  double _calculate(List<String> tokens) {
    // Simple left-to-right calculation (no operator precedence)
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double nextNumber = double.parse(tokens[i + 1]);

      switch (operator) {
        case "+":
          result += nextNumber;
          break;
        case "-":
          result -= nextNumber;
          break;
        case "*":
          result *= nextNumber;
          break;
        case "/":
          result /= nextNumber;
          break;
        default:
          throw Exception("Unsupported operator");
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rohan Calculator App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              textDirection: TextDirection.rtl,
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: lstSymbols.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () => _onButtonPressed(lstSymbols[index]),
                    child: Text(
                      lstSymbols[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
