import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Card(
      elevation: 1,
      child: Column(
        children: [Text('Wash the dishes',style: TextStyle(fontFamily: 'Roboto',fontSize: 15),)],
      ),
      ),
    );
  }
}