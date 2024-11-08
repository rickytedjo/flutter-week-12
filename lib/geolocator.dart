import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:async/async.dart';

class LocationScreen extends StatefulWidget{
    const LocationScreen({super.key});

    @override
    State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String myPosition = '';
  Future<Position>? position;
  
  @override
  void initState(){
    super.initState();
    position = getPosition();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Ricky - Current Location')), // Soal 11
      body: Center(
        child: FutureBuilder(future: position, builder: (BuildContext context, AsyncSnapshot<Position> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasError) {
              return Text('Something terrible happened!');
            }
            return Text(snapshot.data.toString());
          }
          
          else{
            return const Text('');
          }
        }),
      ),
    );
  }

  Future<Position> getPosition() async{
    await Geolocator.isLocationServiceEnabled();
    await Future.delayed(const Duration(seconds: 3));

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}