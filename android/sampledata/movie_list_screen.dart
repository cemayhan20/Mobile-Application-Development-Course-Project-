import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movie_provider.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: FutureBuilder(
        future: Provider.of<MovieProvider>(context, listen: false).fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                return ListView.builder(
                  itemCount: movieProvider.movies.length,
                  itemBuilder: (context, index) {
                    final movie = movieProvider.movies[index];
                    return ListTile(
                      leading: Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                      title: Text(movie.title),
                      subtitle: Text(movie.overview),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
