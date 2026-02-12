import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/pokemon_tcg_service.dart';

enum LoadingState { idle, loading, success, error }

class SearchViewModel extends ChangeNotifier {
  final PokemonTcgService _service = PokemonTcgService();

  List<PokemonCard> _cards = [];
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';

  List<PokemonCard> get cards => _cards;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> searchCards(String query) async {
    if (query.isEmpty) {
      _cards = [];
      _state = LoadingState.idle;
      notifyListeners();
      return;
    }

    _state = LoadingState.loading;
    notifyListeners();

    try {
      _cards = await _service.searchCards(query);
      _state = _cards.isEmpty ? LoadingState.idle : LoadingState.success;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _state = LoadingState.error;
    }
    notifyListeners();
  }

  void reset() {
    _cards = [];
    _state = LoadingState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
