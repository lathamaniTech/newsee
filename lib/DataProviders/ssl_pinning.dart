// import 'dart:io';
// import 'package:dio/io.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter/services.dart';
// import 'package:dio/dio.dart';

// Future<Dio> createPinnedDioClient() async {
//   // Load your certificate
//   final sslCert = await rootBundle.load('assets/certificates/PSB.crt');

//   // Create SecurityContext and set trusted certs
//   final SecurityContext context = SecurityContext();
//   context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

//   // Create custom HttpClient
//   final httpClient = HttpClient(context: context);
//   httpClient.badCertificateCallback = (
//     X509Certificate cert,
//     String host,
//     int port,
//   ) {
//     // You can add additional checks here if needed
//     return true;
//   };

//   // Create Dio instance with custom HttpClient
//   final dio = Dio();
//   (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
//       () => httpClient;

//   return dio;
// }
