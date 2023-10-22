import 'package:flutter/material.dart';

void main(){
  runApp(const MainApp());

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});


Widget build(BuildContext context){
  return const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('HELLO WORLD'),
      ),
    ),
  );
}



}