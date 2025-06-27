import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/entity/Film.dart';

class MovieDescription extends StatelessWidget {
  MovieDescription({
    super.key,
    required this.movie,
    required this.currentDate,
  });

  final Film movie;
  String currentDate = DateFormat('EEEEEE, dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Take up full width
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 63, 62, 62),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        child: Row(
          children: [
            Image.network(
              '$urlGambar${movie.fotoFilm}',
              width: 100,
              height: 160,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to start (left)

                children: [
                  Text(
                    "${movie.judul}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    softWrap: true, // Ensure text wraps
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.clapperboard,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Atma Cinema",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                        softWrap: true, // Ensure text wraps
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis, // Ellipsis if text overflows
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Universitas Atma Jaya Yogyakarta",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          softWrap: true, // Ensure text wraps
                          maxLines: 2,
                          overflow: TextOverflow
                              .ellipsis, // Ellipsis if text overflows
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "$currentDate",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          softWrap: true, // Ensure text wraps
                          maxLines: 2,
                          overflow: TextOverflow
                              .ellipsis, // Ellipsis if text overflows
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
