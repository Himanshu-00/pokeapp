import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Pocket Monster',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: FutureBuilder<List<Pokemon>>(
        future: PokemonAPI().fetchPokemonList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  PokemonTile(snapshot.data![index]),
            );
          }
        },
      ),
    );
  }
}

class PokemonAPI {
  final String apiUrl = 'https://pokeapi.co/api/v2/pokemon?limit=15';

  Future<List<Pokemon>> fetchPokemonList() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        return data
            .map<Pokemon>((pokemonData) => Pokemon.fromJson(pokemonData))
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to make the request');
    }
  }
}

class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${json['url'].split('/')[6]}.png';
    return Pokemon(name: name, imageUrl: imageUrl);
  }
}

class PokemonTile extends StatelessWidget {
  final Pokemon pokemon;

  PokemonTile(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(pokemon.imageUrl, fit: BoxFit.cover),
      footer: Container(
        color: Colors.black.withOpacity(0.7),
        child: ListTile(
          title: Text(pokemon.name, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
