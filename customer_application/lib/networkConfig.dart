import 'dart:convert';
import 'dart:io';
import 'package:customer_application/CommonMethods.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';




class NetworkCommon {
  static final NetworkCommon _singleton = new NetworkCommon._internal();
  List<int> certificateChainBytes = null;

  BuildContext mContext;

  factory NetworkCommon() {
    return _singleton;
  }

  NetworkCommon._internal();

  void netWorkInitilize(BuildContext context){
    mContext = context;
    print('Context is initilized******* ${context.toString()}');

  }

  final JsonDecoder _decoder = new JsonDecoder();

  // decode json response to dynamic (helper function)
  dynamic decodeResp(d) {
    var response = d as Response;
    final dynamic jsonBody = response.data;
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
      throw new Exception("statusCode: $statusCode");
    }

    if (jsonBody is String) {
      return _decoder.convert(jsonBody);
    } else {
      return jsonBody;
    }
  }

  readFile() async {
    certificateChainBytes =
        (await rootBundle.load('assets/certificate.pem')).buffer.asInt8List();
  }
  static bool _certificateCheck(X509Certificate cert, String host, int port){
    return host == 'local.domain.ext';
  }

  // global configuration
  Dio get myDio {
    Dio dio = new Dio();

//    dio.interceptors.add(alice.getDioInterceptor());
//    dio.options.baseUrl = 'https://111.125.203.226:30001/doorstep'; // public server
//    dio.options.baseUrl = 'http://111.125.203.226:30001/doorstep'; // public server


//    dio.options.baseUrl = 'https://dsb.imfast.co.in:9699/doorstep'; // production server
//    dio.options.baseUrl = 'http://10.10.20.80:30000/doorstep';    //office local server
    dio.options.baseUrl = 'https://10.10.20.62:30000/doorstep';    //office local server
//    dio.options.baseUrl = 'http://10.10.20.46:30000/doorstep';  // bhubhaneshvari local server

    // handle timeouts //Bhuvaneswari
    dio.options.connectTimeout = 50000; //5s
    dio.options.receiveTimeout = 50000;


    //dio.httpClientAdapter = new DefaultHttpClientAdapter();


/*
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
      SecurityContext sc = new SecurityContext();
      //file is the path of certificate

//      final List<int> certificateChainBytes =
//      (await rootBundle.load('assets/certificate.pem')).buffer.asInt8List();


      sc.setTrustedCertificates(File("assets/certificate.pem").path, password: "DSB@2019");
      //  sc.setTrustedCertificatesBytes(certificateChainBytes,password: "DSB@2019");
      HttpClient httpClient = new HttpClient(context: sc);
      return httpClient;
    };
*/

    dio.options.contentType = Headers.jsonContentType;
    // dio.httpClientAdapter = new BrowserHttpClientAdapter();
    // dio.httpClientAdapter = new DefaultHttpClientAdapter();

    /*(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
      SecurityContext sc = new SecurityContext();
      //file is the path of certificate

//      final List<int> certificateChainBytes =
//      (await rootBundle.load('assets/certificate.pem')).buffer.asInt8List();


      sc.setTrustedCertificates(File("assets/cert/certificate.pem").path, password: "DSB@2019");
      //  sc.setTrustedCertificatesBytes(certificateChainBytes,password: "DSB@2019");
      HttpClient httpClient = new HttpClient(context: sc);
      return httpClient;
    };*/

   /* (dio.httpClientAdapter as  DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
      SecurityContext sc = new SecurityContext();
      //file is the path of certificate

      HttpClient httpClient = new HttpClient()..badCertificateCallback = (_certificateCheck);
      return httpClient;
    };*/

   /* (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      print('onHttpClientCreate entered...');  // this code is never reached
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };*/

    dio.interceptors
        .add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {

          // set the token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = prefs.getString('token');
          if (token != null) {
            options.headers["Authorization"] = "Bearer " + token;
          }

          // set accept language
          String lang = prefs.getString("lang");
          if (lang != null) {
            options.headers["Accept-Language"] = lang;
          }

          // print requests
          print("Pre request:${options.method},${options.baseUrl}${options.path}");
          print("Pre request:${options.headers.toString()}");

          return options; //continue
        }, onResponse: (Response response) async {

      final int statusCode = response.statusCode;

      // handel response for some endpoints
      if (statusCode == 200 || statusCode == 201) {
        if (response.request.path == "login/" ||
            response.request.path == "signup/" ||
            response.request.path == "login-google/" ||
            response.request.path == "login-facebook/") {

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final JsonDecoder _decoder = new JsonDecoder();
          final JsonEncoder _encoder = new JsonEncoder();
          final resultContainer = _decoder.convert(response.toString());

          prefs.setString("token", resultContainer["token"]);

          prefs.setString(
              "user", _encoder.convert((resultContainer["user"] as Map)));
          prefs.setBool("isLogined", true);
        }
        if (response.request.path == "profile/") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final JsonDecoder _decoder = new JsonDecoder();
          final JsonEncoder _encoder = new JsonEncoder();
          final resultContainer = _decoder.convert(response.toString());
          prefs.setString("user", _encoder.convert((resultContainer as Map)));
        }
        if (response.request.path == "getServiceList/") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final JsonDecoder _decoder = new JsonDecoder();
          final JsonEncoder _encoder = new JsonEncoder();
          final resultContainer = _decoder.convert(response.toString());
          print('response : ${response.toString()}');
          prefs.setString("user", _encoder.convert((resultContainer as Map)));
        }
        if (response.request.path == "fetchUserDetails") {

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final JsonDecoder _decoder = new JsonDecoder();
          final JsonEncoder _encoder = new JsonEncoder();
          final resultContainer = _decoder.convert(response.toString());
          print('response : ${response.toString()}');
          prefs.setString("user", _encoder.convert((resultContainer as Map)));
        }

      }else{

        showDialog(context: mContext,
            builder: (Context) => AlertDialog(
              title: Text('Error'),
              content: Text(
                  '${response.statusCode}:'
                  '${response.statusMessage}\n'

              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('OK'),
                    onPressed: (){
                      Navigator.pop(Context);
                    }

                ),
              ],
            ));
      }

      // log response
      print(
          "Response From:${response.request.method},${response.request.baseUrl}${response.request.path}");
      print("Response From:${response.toString()}");
      return response; // continue
    }, onError: (DioError dioError){

      print(
          "<-- ${dioError.message} ${(dioError.response?.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL')}");
      print(
          "${dioError.response != null ? dioError.response.data : 'Unknown Error'}");

      String errMsg = "Error";
      if(dioError.type == DioErrorType.CONNECT_TIMEOUT){
        errMsg = "Connection Timed Out";
      }else if(dioError.type == DioErrorType.RECEIVE_TIMEOUT){
        errMsg = "RECEIVE_TIMEOUT";
      }else if(dioError.type == DioErrorType.SEND_TIMEOUT){
        errMsg = "SEND_TIMEOUT";
      }else if(dioError.type == DioErrorType.CANCEL) {
        errMsg = "CANCEL";
      } else{
        errMsg = "${dioError.response != null ? dioError.response.data : 'Unknown Error'}";
      }

      if(mContext!=null){
        showDialog(context: mContext,
            builder: (context) => CupertinoAlertDialog(
              title: Text(' Connection Error'),
              /*content: Text('${dioError.toString()} \n '
                  '${dioError.type} \n'
                  '$errMsg \n'
                  '${dioError.response.toString()} \n'
                  '${dioError.request.toString()} \n'),*/
              content: Text(//'${dioError.type.toString()} \n'
                  //'$errMsg \n'
                  'We\'re unable to connect at the moment, make sure the device is connected to internet and try again'),
              actions: <Widget>[
                FlatButton(
                    child: Text('OK', style: TextStyle(color: Colors.blue),),
                    onPressed: (){
                      Navigator.pop(context);
                    }

                ),
              ],
            ));
      }else{
        print('Context is ${mContext}');
      }

      print(
          "Response From:${dioError.request.method},${dioError.request.baseUrl}${dioError.request.path}");
      print("Response From:${dioError.toString()}");

    }
    ));
    return dio;
  }
}