import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/pokemon_tcg_service.dart';

enum LoadingState { idle, loading, success, error }

class ExploreViewModel extends ChangeNotifier {
  final PokemonTcgService _service = PokemonTcgService();

  List<PokemonCard> _cards = [];
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  List<PokemonCard> get cards => _cards;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadCards() async {
    _state = LoadingState.loading;
    notifyListeners();

    try {
      final newCards = await _service.getCards(page: _currentPage, pageSize: 20);
      _cards = newCards;
      _state = LoadingState.success;
      _errorMessage = '';
      _hasMore = newCards.length == 20;
    } catch (e) {
      _errorMessage = e.toString();
      _state = LoadingState.error;
    }
    notifyListeners();
  }

  Future<void> loadMoreCards() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newCards =
          await _service.getCards(page: _currentPage, pageSize: 20);
      _cards.addAll(newCards);
      _hasMore = newCards.length == 20;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _currentPage--;
    }
    _isLoadingMore = false;
    notifyListeners();
  }

  void reset() {
    _cards = [];
    _state = LoadingState.idle;
    _errorMessage = '';
    _currentPage = 0;
    _hasMore = true;
    _isLoadingMore = false;
    notifyListeners();
  }
}
