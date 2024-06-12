import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=YOUR_API_KEY&language=en-US&page=1'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      _movies = jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

