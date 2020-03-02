import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;
import 'package:convert/convert.dart';

import 'CommonMethods.dart';

String Password = "jjkaDHJSJFF4385N";
String APPEND = "Salted__";

void main(){
  testEncAndDecryption();
 runApp(EncryptApp());
}

void testEncAndDecryption() {

  var data64 = 'U2FsdGVkX19zdiftLRnTCRmTb3EKtGSxk+HbTZTaN/4wiT32BPwfYm1fyeYjIAbn/q9cr30b84cPFAILe4OYJ0HEIxXeXdjaKaM8HVRZFfv2D0F30UmFj/8IOt84L0VQ0MlstJhI1eQWXIY1Llhq2r3E/K9DzEj6xll/Y8hMtPTyryL0IKzRYFirsEvA08XeM3u8THUeR2PQP6Mxro05EBLfEhULRr2m0AeEeu+KQvh8DyAacwsgSQjsM1anu/M871E4bHTx8WfPpWhrBZPUsiiuBo+/G+pFOsjFSYeEUjmjArAWWWy2C80tQA3dejkhMianYObkNpmm+emP83k9QOM1EHiyKQ+lt6S7Suvq0udRmcsJE+UqYg48gpV6WCRY0VJZbaBquvvb9KdUbBViUJBosfxQGVNCYXEhDAJmBXsIQ9Gr0M4cEiA5zsrrUPgIRopp8ZHrYy2YA2lPnWmOJQ==';
  CommonMethods().printLog('encryted Data : $data64');
  var decrypted = decrypt(data64);
  CommonMethods().printLog('\n\nDec==== : $decrypted');

  var encryption = encrypt(decrypted);
  CommonMethods().printLog('\n\nEnc==== : $encryption');

  decrypted = decrypt(encryption);
  CommonMethods().printLog('\n\nDec2==== : $decrypted');


  encryption = encrypt("Hari Krishna");
  CommonMethods().printLog('\n\nEnc==== : $encryption');

  decrypted = decrypt(encryption);
  CommonMethods().printLog('\n\nDec2==== : $decrypted');

}

decrypt(String data64) {

  CommonMethods().printLog('******************************The data to be decrypted is $data64');

  const base64 = const Base64Codec();

  var decode = base64.decode(data64);

  var salt = hex.encode(decode.sublist(8, 16));
  //CommonMethods().printLog('random $salt');
  var ciphertextBytes =  hex.encode(decode.sublist(16));
  //CommonMethods().printLog('ciphertextBytes $ciphertextBytes');

  var password = hex.encode(Password.codeUnits);
  //CommonMethods().printLog('password $password');

  var derivedBytes = EvpKDF(password, 256, 128, salt, 1);

  var key = derivedBytes.substring(0,64);
  var iv = derivedBytes.substring(64);

  //CommonMethods().printLog('key : $key');
  //CommonMethods().printLog('iv : $iv');

  final key1 = encryptLib.Key.fromBase16(key);
  final iv1 = encryptLib.IV.fromBase16(iv);

  final encrypter = encryptLib.Encrypter(encryptLib.AES(key1, mode: encryptLib.AESMode.cbc, padding: 'PKCS7'));

  var hexData = hex.encode(decode.sublist(16));
  //CommonMethods().printLog('hexData $hexData');

  var decrypted = encrypter.decrypt16(ciphertextBytes, iv: iv1);

  CommonMethods().printLog('\n\n1==== : $decrypted');
  decrypted = encrypter.decrypt16(hexData, iv: iv1);

  CommonMethods().printLog('\n\n2==== : $decrypted');
  return decrypted;

}

encrypt(String planinText) {

  const base64 = const Base64Codec();

  var salt = '737627ED2D19D309';

  var password = hex.encode(Password.codeUnits);
  //CommonMethods().printLog('password $password');

  var derivedBytes = EvpKDF(password, 256, 128, salt, 1);

  var key = derivedBytes.substring(0,64);
  var iv = derivedBytes.substring(64);

  //CommonMethods().printLog('key : $key');
  //CommonMethods().printLog('iv : $iv');

  final key1 = encryptLib.Key.fromBase16(key);
  final iv1 = encryptLib.IV.fromBase16(iv);

  final encrypter = encryptLib.Encrypter(encryptLib.AES(key1, mode: encryptLib.AESMode.cbc, padding: 'PKCS7'));

  var ecncrypted = encrypter.encrypt(planinText, iv: iv1);

 // CommonMethods().printLog('\n\n1 base64==== : ${ecncrypted.base64}');

  //CommonMethods().printLog('\n\n2 base16==== : ${ecncrypted.base16}');

  var data = hex.encode(APPEND.codeUnits) + salt + ecncrypted.base16;

  //CommonMethods().printLog('hexDataEnc : $data');
  var encoded = base64.encode(hex.decode(data));
  //CommonMethods().printLog('encEncoded : $encoded');

  return encoded;

}


EvpKDF(var Password, int keySize, int ivSize, var Salt, int iteration)
{

  try {

    keySize = keySize~/32;
    ivSize = ivSize~/32;
    int targetKeySize = keySize + ivSize;
    //CommonMethods().printLog('targetKeySize $targetKeySize');

    var derivedBytes ="";

    num numberOfDerivedWords = 0;

    var password = hex.decode(Password);
    var salt = hex.decode(Salt);

    var output = new AccumulatorSink<Digest>();
    var input = md5.startChunkedConversion(output);
    var digest;

    while (numberOfDerivedWords < targetKeySize) {
      CommonMethods().printLog("\n\n");

      output = new AccumulatorSink<Digest>();
      input = md5.startChunkedConversion(output);
      if(digest!=null){
        input.add(digest.bytes);
      }
      input.add(password);
      input.add(salt); // call `add` for every chunk of input data
      input.close();
      digest = output.events.single;

      // Iterations
      for (int i = 1; i < iteration; i++) {
        output = new AccumulatorSink<Digest>();
        input = md5.startChunkedConversion(output);

        input.add(digest.bytes);
        input.close();
        digest = output.events.single;

      }
      //CommonMethods().printLog("Digest as bytes: ${digest.bytes}");
      //CommonMethods().printLog("Digest as hex string: $digest");

      int len = digest.bytes.lengthInBytes;
      numberOfDerivedWords += len~/4;
      //CommonMethods().printLog(numberOfDerivedWords);
      derivedBytes += hex.encode(digest.bytes);

    }

    //CommonMethods().printLog('derivedBytes : $derivedBytes');

    //var key = derivedBytes.substring(0,64);
    //var iv = derivedBytes.substring(64);

    //CommonMethods().printLog('key : $key');
    //CommonMethods().printLog('iv : $iv');
    return derivedBytes;

  } catch (e) {
    CommonMethods().printLog(e);

  } finally {}

}

List<int> arrayCopy(bytes, srcOffset, result, destOffset, bytesLength) {
  for (var i = srcOffset; i < bytesLength; i++) {
    result[destOffset + i] = bytes[i];
  }
  return result;
}
class EncryptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrypt App',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Encrypter and Decrypter"),
        ),
        body: Center(
          child: Text("test"),
        ),
      ),

    );
  }
}


