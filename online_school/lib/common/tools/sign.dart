import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:tripledes/tripledes.dart';

class SignUtil {
  ///爱学签名规则：
  ///1.参数添加到map，去除value为null，或者为''的值
  ///2.按key排序，
  ///3.参数拼接：
  ///4.${接口名}&k1=v1&k2=v2...&${cipher}
  ///5.拼接后，求md5
  ///6.将md5摘要用base64编码，注意是urlsafe base64 encode
  ///eg.encodeBase64URLSafeString(md5(${接口名}&k1=v1&k2=v2...&${cipher}))
  static Object makeSign(String url, Map<String, Object> param) {
    var cipher = '*ETT#HONER#2014*';
    // 去除空值
    var noneNullParam = filterNull(param);
    // 拼接：a=b&c=d
    var strParam = joinParam(noneNullParam);
    var md5 = generateMd5(url + '&' + strParam + cipher);
    var base64 = base64Url.encode(md5.toString().codeUnits);
    return base64.replaceAll('=', '');
  }

  ///query参数拼接
  static String joinParam(Map<String, Object> param) {
    var notNullList = param.entries.toList();
    var newList = [];
    for (var value in notNullList) {
      newList.add(value);
    }
    newList.sort((a, b) => compare(a.key, b.key));

    var pairList = [];
    for (var value1 in newList) {
      pairList.add(value1.key + "=" + value1.value.toString());
    }
    return pairList.join('&');
  }

  ///滤除value空值
  static Map<String, dynamic> filterNull(Map<String, Object> param) {
    var newMap = new HashMap<String, dynamic>();
    try {
      var where = param.entries.where((kv) => notNull(kv.value));
      for (var kv in where) {
        newMap[kv.key] = kv.value;
      }
      ;
    } catch (e) {}
    return newMap;
  }

  static bool notNull(Object value) {
    return value != null && value != '';
  }

  // md5 加密
  static String generateMd5(String data) {
    var content = utf8.encode(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  ///字典序，标准库没找到，所以自己写了
  static int compare(String key, String key2) {
    int minLen = min(key.length, key2.length);
    for (var i = 0; i < minLen; i++) {
      var char1 = key.codeUnitAt(i);
      var char2 = key2.codeUnitAt(i);
      if (char1 > char2) {
        return 1;
      } else if (char1 < char2) {
        return -1;
      }
    }
    if (key.length < key2.length) {
      return -1;
    }
    return 1;
  }

  static String desEncrypt(String plain, {String key: "etiantianim"}) {
    var blockCipher = new BlockCipher(new DESEngine(), key);
    return hex.encode(blockCipher.encode(plain).codeUnits);
  }

  static String aesDecrypt(String encryptText,
      {String key: "#YXW#COMMON#2016"}) {
    final encrypter = new Encrypter(new AES(key));
    final decryptedText = encrypter.decrypt(encryptText);

    var codeUnits = decryptedText.codeUnits;
    var decode = utf8.decode(codeUnits);
    return decode;
  }
}
