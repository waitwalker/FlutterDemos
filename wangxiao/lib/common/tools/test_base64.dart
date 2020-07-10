import 'dart:convert';
import 'dart:io';

void main() {
  foo('/Users/etiantian/Work/aixue40/a.jpg');
}

foo(path) {
  var file = new File(path);
  file.readAsBytes().then((bs) {
    var base64encoded = base64Encode(bs);
  });
}
