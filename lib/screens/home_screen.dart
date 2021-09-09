import 'package:flutter/material.dart';
import 'package:peliculas2/providers/movies_provider.dart';
import 'package:peliculas2/search/search_delegate.dart';
import 'package:peliculas2/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('En Cartelera'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate())
                  .then((data) => {print('closeResponse: $data')});
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CardSwiper(movies: moviesProvider.onDisplayMovies),
          MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Los mas vistos',
              onNextPage: () => moviesProvider.getPopularMovies()),
        ]),
      ),
    );
  }
}
