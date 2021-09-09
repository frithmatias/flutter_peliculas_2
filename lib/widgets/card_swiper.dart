import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculas2/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;
  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (this.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
        width: double.infinity,
        height: size.height * .5,
        child: Swiper(
            itemCount: movies.length,
            layout: SwiperLayout.STACK,
            itemWidth: size.width * .6,
            itemHeight: size.height * .4,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];
              movie.idHero = 'swiper-${movie.id}';

              return GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, 'details', arguments: movie),
                  child: Hero(
                    tag: movie.idHero!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage(
                          placeholder: AssetImage('assets/no-image.jpg'),
                          image: movie.fullPosterImg,
                          fit: BoxFit.cover),
                    ),
                  ));
            }));
  }
}
