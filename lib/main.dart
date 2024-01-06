import 'package:flutter/material.dart';
import 'pokemon_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PokiiPoke',
        home: PokemonList(),
        debugShowCheckedModeBanner: false);
  }
}
