

int evalRPN(List<String> tokens) {

  /// 这里通过栈实现最合适，但是Dart没有提供栈的API，通过一个数组代替栈
  List<int> stack = [];
  for (String token in tokens) {
    if (isOperator(token)) {
      int right = stack.removeLast().toInt();
      int left = stack.removeLast().toInt();
      stack.add(calculate(left, right, token));
    } else {
      stack.add(int.parse(token));
    }
  }
  return stack.last.toInt();
}

int calculate(int left, int right, String operator) {
  switch (operator){
    case "+":
      return left + right;
    case "-":
      return left - right;
    case "*":
      return left * right;
    case "/":
      return left ~/ right;
    default:
      return 0;
  }
}

bool isOperator(String string) {
  return "+-*/".contains(string);
}