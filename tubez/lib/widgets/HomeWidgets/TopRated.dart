import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/entity/Film.dart';
import 'package:tubez/screens/movieDetail.dart';

class TopRated extends StatelessWidget {
  const TopRated({
    super.key,
    required this.filmList,
  });

  final List<Film> filmList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filmList.map((movie) {
            if (movie.jumlahRating <= 9) {
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '$urlGambar${movie.fotoFilm!}', // Ensure you append the correct path
                            width: 140,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 140,
                          child: Text(
                            movie.judul ?? 'No Title', // Handle null title
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ));
            }
          }).toList(),
        ),
      ),
    );
  }
}
