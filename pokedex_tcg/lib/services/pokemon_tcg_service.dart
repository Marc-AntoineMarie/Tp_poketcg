import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/card_model.dart';

class PokemonTcgService {
  static const String baseUrl = 'https://api.pokemontcg.io/v2';

  Future<List<PokemonCard>> searchCards(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cards?q=name:$query*'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((card) => PokemonCard.fromJson(card)).toList();
      } else {
        throw Exception('Failed to search cards');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PokemonCard>> getCards({int page = 0, int pageSize = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cards?page=${page + 1}&pageSize=$pageSize'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((card) => PokemonCard.fromJson(card)).toList();
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<PokemonCard> getCardDetail(String cardId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cards/$cardId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PokemonCard.fromJson(json['data']);
      } else {
        throw Exception('Failed to load card detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
