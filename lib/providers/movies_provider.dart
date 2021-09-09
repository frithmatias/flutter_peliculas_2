import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas2/helpers/debuncer.dart';
import 'package:peliculas2/models/models.dart';
import 'package:peliculas2/models/popular_response.dart';
import 'package:peliculas2/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = '83970b5ff81e73ba079594bf4bad6e04';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;

  Map<int, List<Cast>> moviesCasts = {};

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  MoviesProvider() {
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getResponse(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final response = await this._getResponse('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(response);

    this.onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    print('Obteniendo películas... página $_popularPage');
    final response = await _getResponse('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(response);
    this.popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int idMovie) async {
    if (this.moviesCasts.containsKey(idMovie)) {
      return moviesCasts[idMovie] as List<Cast>;
    }

    final response = await _getResponse('3/movie/$idMovie/credits');
    final creditsResponse = CreditsResponse.fromJson(response);
    moviesCasts[idMovie] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchBuffer) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchBuffer;
    });

    Future.delayed(Duration(milliseconds: 305)).then((_) => timer.cancel());
  }
}
