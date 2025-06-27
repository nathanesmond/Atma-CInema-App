import 'package:flutter/material.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/entity/Film.dart';

class MovieDescription extends StatelessWidget {
  const MovieDescription({
    super.key,
    required this.movie,
  });

  final Film movie;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Container(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                child: Image.network('$urlGambar${movie.fotoFilm!}',
                    fit: BoxFit.cover, width: 200),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "${movie.judul}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          child: Row(
                            children: [
                              const Text(
                                "Rating: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${movie.jumlahRating.toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      4), // Optional: Adds some space between the rating number and the star
                              Image.asset(
                                'assets/images/star.png', // Replace with the actual path to your star PNG image
                                width: 14, // Adjust the size of the star
                                height: 14, // Adjust the size of the star
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          child: const Text(
                            "Synopsis",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(right: 6),
                          child: Scrollbar(
                            thumbVisibility: true,
                            radius: Radius.circular(8),
                            thickness: 3,
                            child: Container(
                              margin: const EdgeInsets.only(right: 6.0),
                              child: SingleChildScrollView(
                                  child: Text("${movie.sinopsis}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                      ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
