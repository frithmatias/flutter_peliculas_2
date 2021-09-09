import 'package:flutter/material.dart';
import 'package:peliculas2/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider(
      {Key? key, required this.movies, required this.onNextPage, this.title})
      : super(key: key);

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  bool _canGetMore = true;

  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final double diff = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      if (diff <= 500) {
        if (_canGetMore) {
          _canGetMore = false;
          widget.onNextPage();
        }
      } else {
        _canGetMore = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (this.widget.title != null)
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(this.widget.title!,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.movies.length,
                  itemBuilder: (_, int index) =>
                      _MovieCard(movie: widget.movies[index])),
            ),
          ],
        ));
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.idHero = 'slider-${movie.id}';
    return Container(
        width: 120,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.idHero!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    image: movie.fullPosterImg,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ]));
  }
}
