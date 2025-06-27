import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubez/widgets/historyWidgets/isiReview.dart';

// ignore: must_be_immutable
class IsiHistory extends StatelessWidget {
  IsiHistory({
    super.key,
    required this.image,
    required this.title,
    required this.status,
    required this.studio,
    required this.date,
    required this.total,
    required this.isReview,
    required this.ticketCount,
    required this.idFilm, // Tambahkan idFilm
    required this.idHistory, // Tambahkan idHistory
  });

  final String image;
  final String title;
  final String status;
  final int studio;
  final String date;
  final String total;
  bool isReview;
  final int ticketCount;
  final int idFilm; // ID Film untuk dikirim ke IsiReview
  final BigInt idHistory; // ID History untuk dikirim ke IsiReview

  void _showReviewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return IsiReview(
          image: image,
          title: title,
          status: status,
          studio: studio,
          date: date,
          total: total,
          isReview: isReview,
          ticketCount: ticketCount,
          idFilm: idFilm, // Kirim idFilm
          idHistory: idHistory, // Kirim idHistory
          onReview: handleIsReview,
        );
      },
    );
  }

  void handleIsReview(bool isReviewUpdate) {
    print('Selected Day: ${isReviewUpdate}');
    isReview = isReviewUpdate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 90,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Status: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: status,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Studio: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: studio.toString(),
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: date,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Total: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      total,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tickets: $ticketCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 90),
              SizedBox(
                width: 100,
                height: 30,
                child: ElevatedButton(
                  onPressed: () => _showReviewModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isReview ? Colors.transparent : Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isReview
                            ? Colors.white
                            : Colors.black, // Warna border sesuai status
                        width: 2, // Lebar border
                      ),
                    ),
                  ),
                  child: Text(
                    isReview ? 'Reviewed' : 'Review',
                    style: TextStyle(
                      color: isReview
                          ? Colors.white
                          : Colors.black, // Warna teks sesuai status
                      fontSize: 10, // Ukuran font
                      fontWeight: FontWeight.bold, // Ketebalan font
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
