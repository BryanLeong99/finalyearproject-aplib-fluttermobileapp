import 'dart:convert';

import 'package:ap_lib/authenticate/public_key.dart';
import 'package:crypto/crypto.dart';
import 'package:crypton/crypton.dart' as crypton;

class CryptographyHandler {
  String hashString(String rawText) {
    var stringBytes = utf8.encode(rawText);
    var stringDigest = sha256.convert(stringBytes);

    return stringDigest.toString();
  }

  String encryptString(String rawText) {
    crypton.RSAPublicKey publicKey = crypton.RSAPublicKey
        .fromString(CustomPublicKey.getPublicKey());

    return publicKey.encrypt(rawText);
  }
}