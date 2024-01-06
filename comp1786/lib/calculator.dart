import 'package:flutter/material.dart';


class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _input = '';
  double _result = 0.0;
  String _currentNumber = '';
  String _operator = '';

  void _handleNumberClick(String number) {
    setState(() {
      _currentNumber += number;
      if(_operator.isEmpty){
        _input = _currentNumber;
      }
    });

  }

  void _handleOperatorClick(String operator) {
    if (_currentNumber.isNotEmpty) {
      setState(() {
        _operator = operator;
        _currentNumber = '';
      });
    }
  }

  void _calculate(){
    double num1 = double.parse(_input);
    double num2 = double.parse(_currentNumber);
    switch (_operator) {
      case '+':
        setState(() {
          _result = num1 + num2;
        });
        break;
      case '-':
        setState(() {
          _result = num1 - num2;
        });
        break;
      case '*':
        setState(() {
          _result = num1 *num2;
        });
        break;
      case '/':
        setState(() {
          _result = num1 / num2;
        });
        break;
    }
    setState(() {
      _input = '';
      _currentNumber = '';
      _operator = '';
    });
  }

  void _handleClear() {
    setState(() {
      _currentNumber = '';
      _input = '';
      _result = 0.0;
      _operator = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_input $_operator ',
                style: const TextStyle(fontSize: 32),
              ),
              _operator.isEmpty ? const Text('') : Text(_currentNumber,style: const TextStyle(fontSize: 32) ),
            ],
          ),
          Text('= $_result',style: const TextStyle(fontSize: 32)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildOperatorButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildOperatorButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildOperatorButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('C'), // Clear button
              _buildButton('0'),
              _buildButton('.'),
              _buildOperatorButton('/'),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentNumber.isNotEmpty && _operator.isNotEmpty) {
                _calculate();
              }
            },
            child: Text('='),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'C') {
          _handleClear();
        }  else {
          _handleNumberClick(text);
        }
      },
      child: Text(text),
    );
  }

  Widget _buildOperatorButton(String operator) {
    return ElevatedButton(
      onPressed: () {
        _handleOperatorClick(operator);
      },
      child: Text(operator),
    );
  }
}
