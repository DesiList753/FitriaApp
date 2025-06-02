import 'package:flutter/material.dart';

class Decision1Screen extends StatefulWidget {
  const Decision1Screen({super.key});

  @override
  State<Decision1Screen> createState() => _Decision1ScreenState();
}

class _Decision1ScreenState extends State<Decision1Screen> {
  int _numero = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EJEMPLO DE STATEFULL'),
      ),
      body: Column(
        children: [
          Container(
            child: Text('Valor: $_numero ',style: TextStyle(fontSize: 30),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(onPressed: (){
                _numero++;
                setState(() {
                  
                });
              }, child: Text('Aumentar')),
              
              OutlinedButton(onPressed: (){
                _numero--;
                setState(() {
                  
                });
              }, child: Text('Disminuir'))],
              ),
              
        ],
      ),
    );
  }
}