import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/movieDetail.dart';
import 'package:tubez/entity/Film.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({
    super.key,
    required this.filmList,
  });

  final List<Film> filmList;

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel>
    with TickerProviderStateMixin {
  late List<Film> carouselFilm;
  @override
  void initState() {
    super.initState();
    carouselFilm = widget.filmList
        .where((movie) => movie.status == 'Now Playing')
        .toList();
  }

  @override
  void didUpdateWidget(covariant HomeCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filmList != oldWidget.filmList) {
      setState(() {
        carouselFilm = widget.filmList
            .where((movie) => movie.status == 'Now Playing')
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          autoPlay: true,
          height: 370.0,
          aspectRatio: 0.6,
          enlargeCenterPage: true,
          viewportFraction: 0.65),
      items: carouselFilm.map((movie) {
        if (movie.status != "Now Playing") {
          return Container();
        } else {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => moveiDetailScreen(
                            movie: movie,
                          )));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        '$urlGambar${movie.fotoFilm!}',

                        fit: BoxFit.cover,
                        width: 220,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0), // Space between image and text
                  Text(
                    movie.judul!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
