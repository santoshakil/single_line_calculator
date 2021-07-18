import 'dart:io';

num add(a, b) => a + b;
num subtract(a, b) => a - b;
num multiply(a, b) => a * b;
num divide(a, b) => a / b;
num modulo(a, b) => a % b;

const operators = {
  '+': add,
  '-': subtract,
  '*': multiply,
  '/': divide,
  '%': modulo
};

final RegExp expression =
    RegExp(r'(\d+\.\d+|\d+)(?:\s*)(\+|\-|\*|\/|\%|\^*)(?:\s*)(\d+\.\d+|\d+)');
final RegExp parens = RegExp(r'\((.*)\)');

String calculate(String input) {
  if (!expression.hasMatch(input)) {
    throw Exception('Invalid Input');
  }

  var expr = input;

  expr = expr.replaceAllMapped(parens, (match) => calculate(match[1]!));

  while (expression.hasMatch(expr) && num.tryParse(expr) == null) {
    var match = expression.firstMatch(expr);
    var left = num.tryParse(match![1]!);
    var op = match[2];
    var right = num.tryParse(match[3]!);

    expr = expr.replaceAll(match[0]!, operators[op]!(left, right).toString());
  }

  return expr;
}

Future<void> main() async {
  try {
    stdout.write('> ');
    print(calculate(stdin.readLineSync()!));
  } catch (e) {
    print('ERROR: $e');
  }
}
