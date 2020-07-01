import 'package:online_school/common/config/config.dart';
import 'package:flutter/foundation.dart';

debugLog(dynamic msg, {bool loudly = true, String tag = 'DEBUG_LOG'}) {
  if (msg is Map) {
    msg = mergeMsgs(msg);
  }
  if (Config.DEBUG) {
    if (loudly) {
      debugPrint('''
-------------- $tag --------------
${msg.toString()}
    
    ''');
    } else {
      debugPrint('$tag: msg.toString()');
    }
  }
}

mergeMsgs(Map<dynamic, dynamic> msgs) => msgs.entries
    .map((e) => '${e.key}: ${e.value.toString()}')
    .toList()
    .join('\n');

main(List<String> args) {
  print('object');
  debugLog({'name': 'zwx', 'age': 18, 'job': 'coder'}, tag: '---->', loudly: true);
}
