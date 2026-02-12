import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import '../models/card_model.dart';

class PokemonTcgService {
  static const String baseUrl = 'https://api.pokemontcg.io/v2';
  static const Duration requestTimeout = Duration(seconds: 15);
  static const int _maxRetries = 3;

  // Allow configuring an API key either via constructor or via
  // --dart-define=POKEMON_TCG_API_KEY=your_key at build time.
  final String? apiKey;

  const PokemonTcgService({this.apiKey});

  Future<List<PokemonCard>> searchCards(String query) async {
    try {
      final uri = Uri.parse('$baseUrl/cards?q=name:$query*');
      final response = await _getWithRetry(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((card) => PokemonCard.fromJson(card)).toList();
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests - API rate limit exceeded');
      } else {
        throw Exception('Failed to search cards (${response.statusCode})');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error searching cards: $e');
    }
  }

  Future<List<PokemonCard>> getCards({int page = 0, int pageSize = 20}) async {
    try {
      final uri = Uri.parse('$baseUrl/cards?page=${page + 1}&pageSize=$pageSize');
      final response = await _getWithRetry(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((card) => PokemonCard.fromJson(card)).toList();
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests - API rate limit exceeded');
      } else {
        throw Exception('Failed to load cards (${response.statusCode})');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error loading cards: $e');
    }
  }

  Future<PokemonCard> getCardDetail(String cardId) async {
    try {
      final uri = Uri.parse('$baseUrl/cards/$cardId');
      final response = await _getWithRetry(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return PokemonCard.fromJson(data);
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests - API rate limit exceeded');
      } else {
        throw Exception('Failed to load card detail (${response.statusCode})');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error loading card detail: $e');
    }
  }

  // Helper: perform GET with retries and timeout. Retries on network errors
  // and on 5xx / 504 responses.
  Future<http.Response> _getWithRetry(Uri uri) async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    // Use provided apiKey or compile-time define
    final key = apiKey ?? const String.fromEnvironment('POKEMON_TCG_API_KEY', defaultValue: '');
    if (key.isNotEmpty) headers['X-Api-Key'] = key;

    int attempt = 0;
    while (true) {
      attempt++;
      try {
        final response = await http.get(uri, headers: headers).timeout(requestTimeout);

        if (response.statusCode == 200) return response;

        // Retry on server errors (5xx) or gateway timeouts
        if ((response.statusCode >= 500 && response.statusCode < 600) || response.statusCode == 504) {
          if (attempt >= _maxRetries) return response;
          final waitMs = pow(2, attempt) * 250; // exponential backoff
          await Future.delayed(Duration(milliseconds: waitMs.toInt()));
          continue;
        }

        return response;
      } on http.ClientException catch (_) {
        if (attempt >= _maxRetries) rethrow;
        final waitMs = pow(2, attempt) * 250;
        await Future.delayed(Duration(milliseconds: waitMs.toInt()));
      } on SocketException catch (_) {
        if (attempt >= _maxRetries) rethrow;
        final waitMs = pow(2, attempt) * 250;
        await Future.delayed(Duration(milliseconds: waitMs.toInt()));
      } on TimeoutException catch (_) {
        if (attempt >= _maxRetries) rethrow;
        final waitMs = pow(2, attempt) * 250;
        await Future.delayed(Duration(milliseconds: waitMs.toInt()));
      }
    }
  }
}
