import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/movieDetail.dart';
import 'package:tubez/entity/Film.dart';

class nowPlayingScreen extends StatefulWidget {
  const nowPlayingScreen({super.key, required this.movieList});

  final Iterable<Film> movieList;

  @override
  State<nowPlayingScreen> createState() => _nowPlayingScreenState();
}

class _nowPlayingScreenState extends State<nowPlayingScreen>
    with TickerProviderStateMixin {
  late List<Film> nowPlayingMovies;
  @override
  void initState() {
    super.initState();
    nowPlayingMovies = widget.movieList
        .where((movie) => movie.status == 'Now Playing')
        .toList();
  }

  @override
  void didUpdateWidget(covariant nowPlayingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.movieList != oldWidget.movieList) {
      setState(() {
        nowPlayingMovies = widget.movieList
            .where((movie) => movie.status == 'Now Playing')
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(), // Prevent scrolling
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          mainAxisSpacing: 13,
          crossAxisSpacing: 8,
          childAspectRatio: 0.5, // Aspect ratio for each cell
        ),
        itemCount: nowPlayingMovies.length, // Use widget.movieList here
        itemBuilder: (context, index) {
          final movie = nowPlayingMovies[index];

          return GestureDetector(
            onTap: () {
              // On tapping a movie, navigate to the MovieDetailScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => moveiDetailScreen(movie: movie),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    Colors.transparent, // Transparent background for separation
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Movie poster image
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '$urlGambar${movie.fotoFilm}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Movie title
                  Expanded(
                    flex: 1,
                    child: Text(
                      movie.judul,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
