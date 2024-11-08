import 'package:books/geolocator.dart';
import 'package:books/navigation_dialog.dart';
import 'package:books/navigation_first.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ricky Putra Pratama Tedjo', // Soal 1
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: const NavigationDialogScreen(),
    );
  }
}

class FuturePage extends StatefulWidget{
  const FuturePage({super.key});

  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage>{
  String result = '';

  late Completer completer;

  Future getNumber() {
    completer = Completer<int>();
    calculate();
    return completer.future;
  }

  Future calculate() async {
    try{
      await Future.delayed(const Duration(seconds : 5));
      completer.complete(42);
    }
    catch (_){
      completer.completeError({});
    }
  }

  Future returnError() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Something terrible happened');
  }

  void returnFG(){
    final futures = Future.wait<int>([
      returnOneAsync(),
      returnTwoAsync(),
      returnThreeAsync(),
    ]); //Soal 8 - Snippet langkah 1 bisa menambahkan future dengan lebih dinamis dari snippet langkah 4

    FutureGroup<int> futureGroup = FutureGroup();
    futureGroup.add(returnOneAsync());
    futureGroup.add(returnTwoAsync());
    futureGroup.add(returnThreeAsync());
    
    

    futureGroup.close();
    futureGroup.future.then((List <int> value){
      int total = 0;
      for (var element in value){
        total += element;
      }
      setState(() {
        result = total.toString();
      });
    });

    
  }

  Future handleError() async{
    try{
      await returnError();
    }
    catch(error){
      setState(() {
        result = error.toString();
      });
    }
    finally{
      print('Complete');
    }
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back from the Future'),
      ),
      body: Center(
        child: Column(children: [
          const Spacer(),
          ElevatedButton(onPressed: (){
            handleError().then((value){
              setState(() {
                result = 'Success';
              });
            }).catchError((onError){
              setState(() {
                result = onError.toString();
              });
            }).whenComplete(()=>print('Complete'));
            // Soal 7 - 
            // setState((){});
            // getData().then((value){
            //   result = value.body.toString().substring(0,450);
            //   setState((){});
            // }).catchError((_){
            //   result = "An error occurred";
            //   setState((){});
            // });
            // count();
            // // Soal 4 - Langkah 1 dan 2 untuk melakukan penjumlahan 1,2,dan 3 dengan delay setiap angka 3 detik 
            // getNumber().then((value) {
            //   setState(() {
            //     result = value.toString();
            //   });
            // }).catchError((e) {
            //   result = 'An error occurred';
            // });
            // // Soal 6 - Langkah 5-6 menambahkan try-catch untuk skenario error
            // // Soal 5 - dengan delay 5 detik, variabel completer di isi dengan nilai 42 ketika fungsi calculate dipanggil method getNumber
          }, child: const Text('Go!')),
          // Soal 3 - Jika getData berhasil, data yang didapat diambil 450 karakter pertamanya dan akan ditampilkan
          // Namun Jika gagal, notifikasi error yang ditampilkan
          const Spacer(),
          Text(result),
          const Spacer(),
          const CircularProgressIndicator(),
          const Spacer()
        ],),
      ),
    );
  }

  Future<Response> getData() async{ // Soal 2
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/MugHAy_Atz4C';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }

  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1; 
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  Future count() async{
    int total = 0;
    total = await returnOneAsync();
    total += await returnTwoAsync();
    total += await returnThreeAsync();
    setState(() {
      result = total.toString();
    });
  }
}