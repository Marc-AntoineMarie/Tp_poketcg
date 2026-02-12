import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/pokemon_tcg_service.dart';

enum LoadingState { idle, loading, success, error }

class DetailViewModel extends ChangeNotifier {
  final PokemonTcgService _service = PokemonTcgService();

  PokemonCard? _card;
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';

  PokemonCard? get card => _card;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> loadCardDetail(String cardId) async {
    _state = LoadingState.loading;
    notifyListeners();

    try {
      _card = await _service.getCardDetail(cardId);
      _state = LoadingState.success;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _state = LoadingState.error;
    }
    notifyListeners();
  }

  void reset() {
    _card = null;
    _state = LoadingState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
