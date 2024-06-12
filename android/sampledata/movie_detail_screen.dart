import 'package:flutter/material.dart';
import 'movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Overview:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.overview),
            ),
          ],
        ),
      ),
    );
  }
}
